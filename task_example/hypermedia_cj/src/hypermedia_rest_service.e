note
	description: "Hypermedia server"
	date: "$Date: 2013-06-28 12:44:39 -0300 (vie 28 de jun de 2013) $"
	revision: "$Revision: 79 $"
	EIS: "name=REST APIs", "src=http://roy.gbiv.com/untangled/2008/rest-apis-must-be-hypertext-driven", "protocol=url"
	EIS: "name=Hypermedia Controls", "src=http://blueprintforge.com/blog/2012/01/01/a-short-explanation-of-hypermedia-controls-in-restful-services/", "protocol=url"

deferred class
	HYPERMEDIA_REST_SERVICE

inherit

	WSF_LAUNCHABLE_SERVICE
		redefine
			initialize
		end

	WSF_FILTERED_SERVICE
		redefine
			execute
		end


	WSF_ROUTED_SKELETON_SERVICE
		rename
			execute as execute_router
		undefine
			requires_proxy
		end

	WSF_URI_TEMPLATE_HELPER_FOR_ROUTED_SERVICE

	WSF_HANDLER_HELPER

	WSF_NO_PROXY_POLICY

	WSF_FILTER
		rename
			execute as execute_router
		end

	SHARED_EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end

	COLLECTION_JSON_HELPER


feature {NONE} -- Initialization

	initialize
		do
			Precursor
			initialize_router
			initialize_filter
			create {WSF_SERVICE_LAUNCHER_OPTIONS_FROM_INI} service_options.make_from_file ("server.ini")
----			make_and_launch
		end

	setup_router
		local
			task_handler: TASK_HANDLER
			search_handler : SEARCH_HANDLER
			doc: WSF_ROUTER_SELF_DOCUMENTATION_HANDLER
			l_options_filter: WSF_CORS_OPTIONS_FILTER
			l_methods: WSF_REQUEST_METHODS
			fhdl: WSF_FILE_SYSTEM_HANDLER

		do
			create l_options_filter.make (router)
			create task_handler
			l_options_filter.set_next (task_handler)
			map_uri_template_agent_with_request_methods (api_uri, agent handle_root, router.methods_GET)

			create l_methods
			l_methods.enable_options
			l_methods.enable_get
			l_methods.enable_post
			router.handle_with_request_methods (task_uri, create {WSF_URI_TEMPLATE_AGENT_HANDLER}.make (agent l_options_filter.execute), l_methods)

			create l_methods
			l_methods.enable_options
			l_methods.enable_get
			l_methods.enable_delete
			l_methods.enable_put
			router.handle_with_request_methods (task_id_uri_template.template, create {WSF_URI_TEMPLATE_AGENT_HANDLER}.make (agent l_options_filter.execute), l_methods)

			create search_handler
			create l_options_filter.make (router)
			l_options_filter.set_next (search_handler)
			create l_methods
			l_methods.enable_options
			l_methods.enable_get
			router.handle_with_request_methods (query_uri_template.template, create {WSF_URI_TEMPLATE_AGENT_HANDLER}.make (agent l_options_filter.execute), l_methods)

			create doc.make_hidden (router)
			create fhdl.make_hidden ("www")
			fhdl.set_directory_index (<<"index.html">>)
			router.handle_with_request_methods (root_uri, fhdl, router.methods_GET)
			router.handle_with_request_methods ("/api/doc", doc, router.methods_GET)
		end

	setup_filter
			-- Setup `filter'
		do
			filter.set_next (Current)
		end

	create_filter
			-- Create `filter'
		do
			create {WSF_CORS_FILTER} filter
		end

feature -- Root Handler

	handle_root (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			h: HTTP_HEADER
			l_msg: STRING
		do
			initialize_converters (json)
			create h.make
			h.put_content_type ("application/collection+json")
			if attached json.value (collection_json_root_builder (req)) as l_cj_answer then
				l_msg := l_cj_answer.representation
				h.put_content_length (l_msg.count)
				if attached req.request_time as time then
					h.put_utc_date (time)
				end
				res.set_status_code ({HTTP_STATUS_CODE}.ok)
				res.put_header_text (h.string)
				res.put_string (l_msg)
			end
		end

feature -- Execution

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			Precursor (req, res)
		end

note
	copyright: "2011-2013, Javier Velilla and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
		Eiffel Software
		5949 Hollister Ave., Goleta, CA 93117 USA
		Telephone 805-685-1006, Fax 805-685-6869
		Website http://www.eiffel.com
		Customer support http://support.eiffel.com
	]"

end
