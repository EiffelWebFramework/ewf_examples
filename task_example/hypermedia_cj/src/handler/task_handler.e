note
	description: "Summary description for {TASK_HANDLER}."
	author: ""
	date: "$Date: 2013-08-20 17:51:39 -0300 (mar, 20 ago 2013) $"
	revision: "$Revision: 205 $"

class
	TASK_HANDLER

inherit

	WSF_FILTER

	WSF_URI_TEMPLATE_HANDLER

	WSF_RESOURCE_HANDLER_HELPER
		redefine
			do_get,
			do_post,
			do_put,
			do_delete
		end

	REFACTORING_HELPER

	WSF_SELF_DOCUMENTED_HANDLER

	SHARED_DATABASE_API

	COLLECTION_JSON_HELPER

feature -- Execute

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request handler
		do
			initialize_converters (json)
			execute_methods (req, res)
			execute_next (req, res)
		end

feature -- Documentation

	mapping_documentation (m: WSF_ROUTER_MAPPING; a_request_methods: detachable WSF_REQUEST_METHODS): WSF_ROUTER_MAPPING_DOCUMENTATION
		do
			create Result.make (m)
			if a_request_methods /= Void then
				if a_request_methods.has_method_post then
					Result.add_description ("URI:/tasks METHOD: POST GET")
				elseif a_request_methods.has_method_get or a_request_methods.has_method_put or a_request_methods.has_method_delete then
					Result.add_description ("URI:/tasks/{task_id} METHOD: GET, PUT, DELETE")
				end
			end
		end

feature -- HTTP Methods

	do_get (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		local
			id: INTEGER_64
		do
			if attached req.path_info as path_info then
				id := get_task_id_from_path (req)
				if id /= 0 and then attached retrieve_task (id) as l_task then
					if is_conditional_get (req, l_task) then
						handle_resource_not_modified_response ("The resource" + path_info + "does not change", req, res)
					else
						compute_response_get (req, res, l_task)
					end
				elseif id /= 0 then
					handle_resource_not_found_response ("The following resource" + path_info + " is not found ", req, res)
				else
					compute_response_get_all (req, res)
				end
			end
		end

	is_conditional_get (req: WSF_REQUEST; l_task: TASK): BOOLEAN
			-- Check if If-None-Match is present and then if there is a representation that has that etag
			-- if the representation hasn't changed, we return TRUE
			-- then the response is a 304 with no entity body returned.
		local
			etag_util: ETAG_UTILS
		do
			if attached req.meta_string_variable ("HTTP_IF_NONE_MATCH") as if_none_match then
				create etag_util
				if if_none_match.same_string (etag_util.md5_digest (l_task.out).as_string_32) then
					Result := True
				end
			end
		end

	compute_response_get (req: WSF_REQUEST; res: WSF_RESPONSE; l_task: TASK)
		local
			h: HTTP_HEADER
			l_msg: STRING
			etag_utils: ETAG_UTILS
			l_cj: CJ_COLLECTION
		do
			l_cj := collection_json_root_builder (req)
			build_task_item (req, l_task, l_cj)
			create h.make
			h.put_content_type ("application/vnd.collection+json")
			create etag_utils
			if attached json.value (l_cj) as l_cj_answer then
				l_msg := l_cj_answer.representation
				h.put_content_length (l_msg.count)
				if attached req.request_time as time then
					h.add_header ("Date:" + time.formatted_out ("ddd,[0]dd mmm yyyy [0]hh:[0]mi:[0]ss.ff2") + " GMT")
				end
				h.add_header ("etag:" + etag_utils.md5_digest (l_task.out))
				res.set_status_code ({HTTP_STATUS_CODE}.ok)
				res.put_header_text (h.string)
				res.put_string (l_msg)
			end
		end

	compute_response_get_all (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			h: HTTP_HEADER
			l_msg: STRING
			etag_utils: ETAG_UTILS
			l_list: LIST [TASK]
			l_items: STRING
			l_cj: CJ_COLLECTION
		do
			l_cj := collection_json_root_builder (req)
			create h.make
			create etag_utils
			from
				l_list := task_mgr.retrieve_all
				l_list.start
				create l_items.make_empty
			until
				l_list.after
			loop
				build_task_item (req, l_list.item, l_cj)
				l_list.forth
			end
			h.put_content_type ("application/vnd.collection+json")
			create etag_utils
			if attached json.value (l_cj) as l_cj_answer then
				l_msg := l_cj_answer.representation
				h.put_content_length (l_msg.count)
				if attached req.request_time as time then
					h.add_header ("Date:" + time.formatted_out ("ddd,[0]dd mmm yyyy [0]hh:[0]mi:[0]ss.ff2") + " GMT")
				end
				res.set_status_code ({HTTP_STATUS_CODE}.ok)
				res.put_header_text (h.string)
				res.put_string (l_msg)
			end
		end

	do_put (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Updating a resource with PUT
			-- A successful PUT request will not create a new resource, instead it will
			-- change the state of the resource identified by the current uri.
			-- If success we response with 200 and the updated task.
			-- 404 if the task is not found
			-- 400 in case of a bad request
			-- 500 internal server error
			-- If the request is a Conditional PUT, and it does not mat we response
			-- 415, precondition failed.
		local
			l_put: STRING
			l_task: detachable TASK
			id: INTEGER_64
		do
			if attached req.path_info as path_info then
				id := get_task_id_from_path (req)
				l_put := retrieve_data (req)
				l_task := extract_cj_request (l_put)
				if l_task /= Void and then attached retrieve_task (id) then
					l_task.set_id (id)
					if is_valid_to_update (l_task) then
						if not is_conditional_put (req, l_task) then
							update_task (l_task)
							compute_response_put (req, res, l_task)
						else
							handle_precondition_fail_response ("", req, res)
						end
					else
							--| FIXME: Here we need to define the Allow methods
						handle_resource_conflict_response (l_put + "%N There is conflict while trying to update the task, the task could not be update in the current state", req, res)
					end
				else
					handle_bad_request_response (l_put + "%N is not a valid task, maybe the task does not exist in the system", req, res)
				end
			end
		end

	is_conditional_put (req: WSF_REQUEST; task: TASK): BOOLEAN
			-- Check if If-Match is present and then if there is a representation that has that etag
			-- if the representation hasn't changed, we return TRUE
		local
			etag_util: ETAG_UTILS
		do
			if attached retrieve_task (task.id) as l_task then
				if attached req.meta_string_variable ("HTTP_IF_MATCH") as if_match then
					create etag_util
					if if_match.same_string (etag_util.md5_digest (task.out).as_string_32) then
						Result := True
					end
				else
					Result := True
				end
			end
		end

	compute_response_put (req: WSF_REQUEST; res: WSF_RESPONSE; l_task: TASK)
		local
			h: HTTP_HEADER
			etag_utils: ETAG_UTILS
			l_cj: CJ_COLLECTION
			l_msg: STRING
		do
			l_cj := collection_json_root_builder (req)
			build_task_item (req, l_task, l_cj)
			create h.make
			h.put_content_type ("application/vnd.collection+json")
			create etag_utils
			if attached json.value (l_cj) as l_cj_answer then
				l_msg := l_cj_answer.representation
				h.put_content_length (l_msg.count)
				if attached req.request_time as time then
					h.add_header ("Date:" + time.formatted_out ("ddd,[0]dd mmm yyyy [0]hh:[0]mi:[0]ss.ff2") + " GMT")
				end
				h.add_header ("etag:" + etag_utils.md5_digest (l_task.out))
				res.set_status_code ({HTTP_STATUS_CODE}.ok)
				res.put_header_text (h.string)
				res.put_string (l_msg)
			end
		end

	do_delete (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Here we use DELETE to cancel an task, if that task is in state where
			-- it can still be canceled.
			-- 200 if is ok
			-- 404 Resource not found
			-- 405 if consumer and service's view of the resouce state is inconsisent
			-- 500 if we have an internal server error
		local
			id: INTEGER_64
		do
			if attached req.path_info as path_info then
				id := get_task_id_from_path (req).to_integer_64
				if attached retrieve_task (id) then
					if is_valid_to_delete (id) then
						delete_task (id)
						compute_response_delete (req, res)
					else
							--| FIXME: Here we need to define the Allow methods
						handle_method_not_allowed_response (path_info + "%N There is conflict while trying to delete the task, the task could not be deleted in the current state", req, res)
					end
				else
					handle_resource_not_found_response (path_info + " not found in this server", req, res)
				end
			end
		end

	compute_response_delete (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			h: HTTP_HEADER
			l_msg: STRING
			l_cj: CJ_COLLECTION
		do
			l_cj := collection_json_root_builder (req)
			create h.make
			h.put_content_type ("application/vnd.collection+json")
			if attached json.value (l_cj) as l_cj_answer then
				l_msg := l_cj_answer.representation
				h.put_content_length (l_msg.count)
				if attached req.request_time as time then
					h.add_header ("Date:" + time.formatted_out ("ddd,[0]dd mmm yyyy [0]hh:[0]mi:[0]ss.ff2") + " GMT")
				end
				res.set_status_code ({HTTP_STATUS_CODE}.ok)
				res.put_header_text (h.string)
				res.put_string (l_msg)
			end
		end

	do_post (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Here the convention is the following.
			-- POST is used for creation and the server determines the URI
			-- of the created resource.
			-- If the request post is SUCCESS, the server will create the task and will response with
			-- HTTP_RESPONSE 201 CREATED, the Location header will contains the newly created task's URI
			-- if the request post is not SUCCESS, the server will response with
			-- HTTP_RESPONSE 400 BAD REQUEST, the client send a bad request
			-- HTTP_RESPONSE 500 INTERNAL_SERVER_ERROR, when the server can deliver the request
		local
			l_post: STRING
		do
			l_post := retrieve_data (req)
			if attached {TASK} extract_cj_request (l_post) as l_task then
				task_mgr.new_task (l_task)
				compute_response_post (req, res, l_task)
			else
				handle_bad_request_response (l_post + "%N is not a valid task", req, res)
			end
		end

	compute_response_post (req: WSF_REQUEST; res: WSF_RESPONSE; l_task: TASK)
		local
			h: HTTP_HEADER
			l_msg: STRING
			etag_utils: ETAG_UTILS
			l_cj: CJ_COLLECTION
		do
			l_cj := collection_json_root_builder (req)
			build_task_item (req, l_task, l_cj)
			create h.make
			h.put_content_type ("application/vnd.collection+json")
			create etag_utils
			if attached json.value (l_cj) as l_cj_answer then
				l_msg := l_cj_answer.representation
				h.put_content_length (l_msg.count)
				if attached req.request_time as time then
					h.add_header ("Date:" + time.formatted_out ("ddd,[0]dd mmm yyyy [0]hh:[0]mi:[0]ss.ff2") + " GMT")
				end
				h.add_header ("etag:" + etag_utils.md5_digest (l_task.out))
				res.set_status_code ({HTTP_STATUS_CODE}.created)
				res.put_header_text (h.string)
				res.put_string (l_msg)
			end
		end

feature {NONE} -- URI helper methods

	get_task_id_from_path (req: WSF_REQUEST): INTEGER_64
		do
			if attached {WSF_STRING} req.path_parameter ("task_id") as l_id and then l_id.is_integer then
				Result := l_id.value.to_integer_64
			end
		end

feature {NONE} -- Implementation Repository Layer

	retrieve_task (id: INTEGER_64): detachable TASK
			-- get the task by id if it exist, in other case, Void
		do
			Result := task_mgr.retrieve_by_id (id)
		end

	save_task (a_task: TASK)
			-- save the task to the repository
		do
			task_mgr.new_task (a_task)
		end

	is_valid_to_delete (an_id: INTEGER_64): BOOLEAN
			-- Is the task identified by `an_id' in a state where it can still be deleted?
		do
			if attached retrieve_task (an_id) then
				Result := True
			end
		end

	is_valid_to_update (a_task: TASK): BOOLEAN
			-- Check if there is a conflict while trying to update the task
		do
			if attached retrieve_task (a_task.id) then
				Result := True
			end
		end

	update_task (a_task: TASK)
			-- update the a_task to the repository
		do
			task_mgr.update (a_task)
		end

	delete_task (an_task_id: INTEGER_64)
			-- delete a task with id = an_task_id to the repository
		do
			task_mgr.delete_by_id (an_task_id)
		end

	json_tasks: STRING_32 = "[
			[$items]
		]"

	extract_cj_request (l_post: STRING): detachable TASK
			-- extract an object Task from the request, or Void
			-- if the request is invalid
		local
			l_description: detachable STRING_32
			l_completed: detachable STRING_32
			l_date_due: detachable STRING_32
		do
			if attached json_to_cj_template (l_post) as template then
				across
					template.data as ic
				loop
					if ic.item.name.same_string ("description") then
						l_description := ic.item.value
					end
					if ic.item.name.same_string ("dateDue") then
						l_date_due := ic.item.value
					end
					if ic.item.name.same_string ("completed") then
						l_completed := ic.item.value
					end
				end
				if attached l_description as l_descr and then attached l_completed as l_comp and then attached l_date_due as l_date then
					create Result
					Result.set_date_due_from_string (l_date)
					Result.set_created_from_string (l_date)
					Result.set_description (l_description)
					if l_completed.is_boolean and then l_completed.to_boolean then
						Result.mark_completed
					end
				end
			end
		end

end
