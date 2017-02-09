note
	description: "Summary description for {SEARCH_HANDLER}."
	author: ""
	date: "$Date: 2013-08-20 17:51:39 -0300 (mar, 20 ago 2013) $"
	revision: "$Revision: 205 $"

class
	SEARCH_HANDLER
inherit

	WSF_FILTER

	WSF_URI_TEMPLATE_HANDLER

	WSF_RESOURCE_HANDLER_HELPER
		redefine
			do_get
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
		end

feature -- HTTP Methods

	do_get (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		do
			if attached req.path_info as path_info then
				if attached {WSF_STRING} req.path_parameter ("option") as l_all and then l_all.value.same_string("all") then
						-- retrieve all
						compute_response_get (req, res,"all")
				elseif attached {WSF_STRING} req.path_parameter ("option") as l_all and then l_all.value.same_string("closed") then
						compute_response_get(req, res,"closed")
				elseif attached {WSF_STRING} req.path_parameter ("option") as l_all and then l_all.value.same_string("open") then
								compute_response_get (req, res,"open")
				else
					handle_resource_not_found_response ("The following resource" + path_info + " is not found ", req, res)
				end
			end
		end

	compute_response_get (req: WSF_REQUEST; res: WSF_RESPONSE; query : STRING)
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
			if query.same_string ("all") then
				l_list := task_mgr.retrieve_all
			elseif query.same_string ("closed") then
				l_list := task_mgr.retrieve_close
			else
				l_list := task_mgr.retrieve_open
			end
			from
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



end
