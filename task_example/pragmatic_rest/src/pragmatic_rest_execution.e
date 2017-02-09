note
	description: "Summary description for {PRAGMATIC_REST_EXECUTION}."
	date: "$Date$"
	revision: "$Revision$"

class
	PRAGMATIC_REST_EXECUTION

inherit

	WSF_FILTERED_ROUTED_EXECUTION
		redefine
			initialize
		end

	SHARED_EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end

create
	make

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
			router.handle ("/tasks", create {WSF_URI_TEMPLATE_AGENT_HANDLER}.make (agent l_options_filter.execute), l_methods)


			create l_methods
			l_methods.enable_options
			l_methods.enable_get
			l_methods.enable_delete
			l_methods.enable_put
			router.handle ("/tasks/{task_id}", create {WSF_URI_TEMPLATE_AGENT_HANDLER}.make (agent l_options_filter.execute), l_methods)

			create doc.make_hidden (router)

			create fhdl.make_hidden ("www")
			fhdl.set_directory_index (<<"index.html">>)
			router.handle ("/", fhdl, router.methods_GET)

			router.handle ("/api/doc", doc, router.methods_GET)
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
