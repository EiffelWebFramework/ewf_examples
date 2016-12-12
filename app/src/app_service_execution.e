note
	description: "Summary description for {APP_SERVICE_EXECUTION}."
	date: "$Date$"
	revision: "$Revision$"

class
	APP_SERVICE_EXECUTION

inherit

	WSF_ROUTED_EXECUTION
		redefine
			initialize
		end

	WSF_URI_HELPER_FOR_ROUTED_EXECUTION

	WSF_URI_TEMPLATE_HELPER_FOR_ROUTED_EXECUTION

	SHARED_EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	initialize
			-- Initialize current service.
		do
			Precursor
			create {APP_FS_DATABASE} database.make (execution_environment.current_working_path.extended (".db"))
			initialize_router
		end

	setup_router
			-- Setup `router'
		local
			fhdl: WSF_FILE_SYSTEM_HANDLER
			doc: WSF_ROUTER_SELF_DOCUMENTATION_HANDLER
		do
			create doc.make (router)
			router.handle ("/api/doc", doc, router.methods_GET)
			map_uri_template_agent ("/api/message/time/now", agent handle_time_now_utc, router.methods_GET)
			map_uri_template_agent ("/api/message/hover/{name}", agent handle_hover_message, router.methods_GET)
			map_uri_template_agent ("/api/session/{session}/item/{name}", agent handle_interface_id_set_value, router.methods_POST)
--			map_uri_template_agent ("/api/session/{session}/item/{name}", agent handle_interface_id_get_text, router.methods_GET)
			map_uri_template_agent ("/api/{operation}", agent handle_api, router.all_allowed_methods)
			create fhdl.make_hidden ("www")
			fhdl.set_directory_index (<<"index.html">>)
			router.handle ("", fhdl, router.methods_GET)
		end

feature -- Access

	database: APP_DATABASE

feature -- Execution

	handle_time_now_utc (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			hdate: HTTP_DATE
			s: STRING
		do
			create hdate.make_from_date_time (create {DATE_TIME}.make_now_utc)
			s := hdate.rfc1123_string
			res.set_status_code ({HTTP_STATUS_CODE}.ok)
			res.put_header_line ("Content-Type: text/plain")
			res.put_header_line ("Content-Length: " + s.count.out)
			res.put_string (s)
		end

	handle_hover_message (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			hdate: HTTP_DATE
			n: READABLE_STRING_8
			s: STRING
		do
			if attached {WSF_STRING} req.path_parameter ("name") as p_name then
				n := p_name.url_encoded_value
			else
				n := "?"
			end
			create hdate.make_from_date_time (create {DATE_TIME}.make_now_utc)
			s := n + " hovered at " + hdate.rfc1123_string
			res.set_status_code ({HTTP_STATUS_CODE}.ok)
			res.put_header_line ("Content-Type: text/plain")
			res.put_header_line ("Content-Length: " + s.count.out)
			res.put_string (s)
		end

	handle_interface_id_set_value (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			sess: APP_SESSION
			v: READABLE_STRING_32
			s: STRING
		do
			if
				attached {WSF_STRING} req.path_parameter ("session") as p_session and then
				attached {WSF_STRING} req.path_parameter ("name") as p_name and then
				attached {WSF_STRING} req.form_parameter ("value") as p_value
			then
				v := p_value.value
				create sess.make (p_session.value)
				database.put (p_name.value, v, sess)

				if database.only_numeric_items (sess) then
					s := "True"
				else
					s := "False"
				end
				res.set_status_code ({HTTP_STATUS_CODE}.ok)
				res.put_header_line ("Content-Type: text/plain")
				res.put_header_line ("Content-Length: " + s.count.out)
				res.put_string (s)
			else
				res.send (create {WSF_NOT_FOUND_RESPONSE}.make (req))
			end
		end

	handle_api (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			pg: WSF_PAGE_RESPONSE
		do
			if attached {WSF_STRING} req.path_parameter ("operation") then

			end
			create pg.make_with_body (req.path_info)
			res.send (pg)
		end

end
