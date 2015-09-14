note
	description: "Summary description for {PERSON_HANDLER}."
	author: ""
	date: "$Date: 2013-08-20 17:56:26 -0300 (mar, 20 ago 2013) $"
	revision: "$Revision: 206 $"

class
	PERSON_HANDLER


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


create
	make

feature {NONE}
	make (a_storage: PERSON_EXPOSER_PERSISTENCE)
		do
			storage := a_storage
		ensure
			storage_set: storage = a_storage
		end

	storage:  PERSON_EXPOSER_PERSISTENCE
		-- person storage

feature -- Execute

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request handler
		do
			execute_methods (req, res)
			execute_next (req, res)
		end

feature -- Documentation

	mapping_documentation (m: WSF_ROUTER_MAPPING; a_request_methods: detachable WSF_REQUEST_METHODS): WSF_ROUTER_MAPPING_DOCUMENTATION
		do
			create Result.make (m)
			if a_request_methods /= Void then
				if a_request_methods.has_method_post then
					Result.add_description ("URI:/persons METHOD: POST GET")
				elseif a_request_methods.has_method_get or a_request_methods.has_method_put or a_request_methods.has_method_delete then
					Result.add_description ("URI:/persons/{person_id} METHOD: GET, PUT, DELETE")
				end
			end
		end

feature -- HTTP Methods

	do_get (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		local
			id: READABLE_STRING_GENERAL
		do
			if attached req.path_info as path_info then
				id := get_task_id_from_path (req)
				if not id.same_string ("") and then attached retrieve_person (id) as l_person then
					if is_conditional_get (req, l_person) then
						handle_resource_not_modified_response ("The resource" + path_info + "does not change", req, res)
					else
						compute_response_get (req, res, l_person)
					end
				elseif not id.same_string ("") then
					handle_resource_not_found_response ("The following resource" + path_info + " is not found ", req, res)
				else
					compute_response_get_all (req, res)
				end
			end
		end

	is_conditional_get (req: WSF_REQUEST; l_task: PERSON_EXPOSER): BOOLEAN
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

	compute_response_get (req: WSF_REQUEST; res: WSF_RESPONSE; l_task: PERSON_EXPOSER)
		local
			h: HTTP_HEADER
			l_msg: STRING
			etag_utils: ETAG_UTILS
			etj : PERSON_EXPOSER_JSON
		do
			create h.make
			create etag_utils
			create etj.make
			create l_msg.make_from_string (json_item)
			h.put_content_type_application_json
			if attached {JSON_VALUE} etj.to_json (l_task) as jv then
				l_msg.replace_substring_all ("$content",jv.representation)
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
			l_list: LIST [PERSON_EXPOSER]
			l_items: STRING
			etj : PERSON_EXPOSER_JSON
		do
			create h.make
			create etag_utils
			create etj.make
			from
				l_list := storage.all_persons
				l_list.start
				create l_items.make_empty
			until
				l_list.after
			loop
				if attached {JSON_VALUE} etj.to_json (l_list.item) as jv then
					l_items.append (jv.representation)
					l_list.forth
					if not l_list.after then
						l_items.append (",")
					end
				else
					l_list.forth
				end
			end
			h.put_content_type_application_json
			create l_msg.make_from_string (json_persons)
			l_msg.replace_substring_all ("$items", l_items)
			h.put_content_length (l_msg.count)
			if attached req.request_time as time then
				h.add_header ("Date:" + time.formatted_out ("ddd,[0]dd mmm yyyy [0]hh:[0]mi:[0]ss.ff2") + " GMT")
			end
			res.set_status_code ({HTTP_STATUS_CODE}.ok)
			res.put_header_text (h.string)
			res.put_string (l_msg)
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
			l_person: detachable PERSON_EXPOSER
			id: READABLE_STRING_GENERAL
		do
			if attached req.path_info as path_info then
				id := get_task_id_from_path (req)
				l_put := retrieve_data (req)
				l_person := extract_person_request (l_put)
				if l_person /= Void and then attached retrieve_person (id) then
					l_person.set_username (id)
					if is_valid_to_update (l_person) then
						if is_conditional_put (req, l_person) then
							update_person (l_person)
							compute_response_put (req, res, l_person)
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

	is_conditional_put (req: WSF_REQUEST; person: PERSON_EXPOSER): BOOLEAN
			-- Check if If-Match is present and then if there is a representation that has that etag
			-- if the representation hasn't changed, we return TRUE
		local
			etag_util: ETAG_UTILS
		do
			if attached retrieve_person (person.username) as l_person then
				if attached req.meta_string_variable ("HTTP_IF_MATCH") as if_match then
					create etag_util
					if if_match.same_string (etag_util.md5_digest (l_person.out).as_string_32) then
						Result := True
					end
				else
					Result := True
				end
			end
		end

	compute_response_put (req: WSF_REQUEST; res: WSF_RESPONSE; l_task: PERSON_EXPOSER)
		local
			h: HTTP_HEADER
			etag_utils: ETAG_UTILS
			etj : PERSON_EXPOSER_JSON
		do
			create h.make
			create etag_utils
			create h.make
			create etj.make
			h.put_content_type_application_json
			if attached req.request_time as time then
				h.add_header ("Date:" + time.formatted_out ("ddd,[0]dd mmm yyyy [0]hh:[0]mi:[0]ss.ff2") + " GMT")
			end
			h.add_header ("etag:" + etag_utils.md5_digest (l_task.out))
			if attached {JSON_VALUE} etj.to_json (l_task) as jv then
				h.put_content_length (jv.representation.count)
				res.set_status_code ({HTTP_STATUS_CODE}.ok)
				res.put_header_text (h.string)
				res.put_string (jv.representation)
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
			id: READABLE_STRING_GENERAL
		do
			if attached req.path_info as path_info then
				id := get_task_id_from_path (req)
				if attached retrieve_person (id) as l_person then
					if is_valid_to_delete (id) then
						delete_person (l_person)
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
		do
			create h.make
			h.put_content_type_application_json
			if attached req.request_time as time then
				h.put_utc_date (time)
			end
			res.set_status_code ({HTTP_STATUS_CODE}.no_content)
			res.put_header_text (h.string)
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
			if attached extract_person_request (l_post) as l_person then
				new_person (l_person)
				compute_response_post (req, res, l_person)
			else
				handle_bad_request_response (l_post + "%N is not a valid person", req, res)
			end
		end

	compute_response_post (req: WSF_REQUEST; res: WSF_RESPONSE; l_person: PERSON_EXPOSER)
		local
			h: HTTP_HEADER
			l_msg: STRING
			l_location: STRING
			joc: PERSON_EXPOSER_JSON
		do
			create h.make
			create joc.make
			h.put_content_type_application_json
			if attached {JSON_VALUE} joc.to_json (l_person) as jv then
				l_msg := jv.representation
				h.put_content_length (l_msg.count)
				if attached req.http_host as host then
					l_location := "http://" + host + req.request_uri + "/" + l_person.username
					h.put_location (l_location)
				end
				if attached req.request_time as time then
					h.put_utc_date (time)
				end
				res.set_status_code ({HTTP_STATUS_CODE}.created)
				res.put_header_text (h.string)
				res.put_string (l_msg)
			end
		end

feature {NONE} -- URI helper methods

	get_task_id_from_path (req: WSF_REQUEST): READABLE_STRING_GENERAL
		do
			Result := ""
			if attached {WSF_STRING} req.path_parameter ("person_id") as l_id and then l_id.is_string then
				Result := l_id.value
			end
		end

feature {NONE} -- Implementation Repository Layer

	retrieve_person (name: READABLE_STRING_GENERAL): detachable PERSON_EXPOSER
			-- get the person by username if it exist, in other case, Void
		do
			Result := storage.person_by_username (name)
		end

	new_person (a_person: PERSON_EXPOSER)
			-- save the task to the repository
		do
			storage.new (a_person)
		end

	is_valid_to_delete (username: READABLE_STRING_GENERAL): BOOLEAN
			-- Is the person identified by `username' in a state where it can still be deleted?
		do
			if attached retrieve_person (username) then
				Result := True
			end
		end

	is_valid_to_update (a_person: PERSON_EXPOSER): BOOLEAN
			-- Check if there is a conflict while trying to update the task
		do
			if attached retrieve_person (a_person.username) then
				Result := True
			end
		end

	update_person (a_person: PERSON_EXPOSER)
			-- update the a_person to the repository
		do
			storage.update (a_person)
		end

	delete_person (a_person :PERSON_EXPOSER)
			-- delete a person
		do
			storage.delete (a_person)
		end

	extract_person_request (l_post: STRING): detachable PERSON_EXPOSER
			-- extract an object person from the request, or Void
			-- if the request is invalid
		local
			etj: PERSON_EXPOSER_JSON
		do
			create etj.make
			if attached etj.from_json (l_post) as l_exp then
				Result := l_exp
			end
		end


	json_persons: STRING_32 = "[
				[$items]
		]"

	json_item : STRING_32 = "[
						{"content" : $content }
					]"

end
