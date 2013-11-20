note
	description: "Pragmatic Server"
	date: "$Date: 2013-07-09 11:11:17 -0300 (mar 09 de jul de 2013) $"
	revision: "$Revision: 110 $"
	EIS: "name=Rest Introduction", "src=http://www.infoq.com/articles/rest-introduction", "protocol=url"
	EIS: "name=Pragmatic Rest", "src=http://www.slideshare.net/apigee/rest-design-webinar", "protocol=url"
	EIS: "name=Some Thoughts on REST", "src=http://www.blueprintforge.com/blog/2011/12/13/some-thoughts-on-rest/", "protocol=url"

deferred class
	PRAGMATIC_REST_SERVER

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

feature {NONE} -- Initialization

	initialize
		do
			initialize_router
			initialize_filter
		end

	setup_router
		local
			task_handler: TASK_HANDLER
			doc: WSF_ROUTER_SELF_DOCUMENTATION_HANDLER
			l_options_filter: WSF_CORS_OPTIONS_FILTER
			l_methods: WSF_REQUEST_METHODS
			fhdl: WSF_FILE_SYSTEM_HANDLER

		do
			create l_options_filter.make (router)
			create task_handler.make

			l_options_filter.set_next (task_handler)


			create l_methods
			l_methods.enable_options
			l_methods.enable_get
			l_methods.enable_post
			router.handle_with_request_methods ("/tasks", create {WSF_URI_TEMPLATE_AGENT_HANDLER}.make (agent l_options_filter.execute), l_methods)


			create l_methods
			l_methods.enable_options
			l_methods.enable_get
			l_methods.enable_delete
			l_methods.enable_put
			router.handle_with_request_methods ("/tasks/{task_id}", create {WSF_URI_TEMPLATE_AGENT_HANDLER}.make (agent l_options_filter.execute), l_methods)

			create doc.make_hidden (router)

			create fhdl.make_hidden ("www")
			fhdl.set_directory_index (<<"index.html">>)
			router.handle_with_request_methods ("/", fhdl, router.methods_GET)

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
