note
	description: "Summary description for {PERSON_REST_SERVER}."
	author: ""
	date: "$Date: 2013-07-10 18:11:34 -0300 (mié, 10 jul 2013) $"
	revision: "$Revision: 131 $"

deferred class
	PERSON_REST_SERVER
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
			person_handler: PERSON_HANDLER
			l_options_filter: WSF_CORS_OPTIONS_FILTER
			l_methods: WSF_REQUEST_METHODS
			fhdl: WSF_FILE_SYSTEM_HANDLER
			doc: WSF_ROUTER_SELF_DOCUMENTATION_HANDLER

		do
			create l_options_filter.make (router)
			create person_handler.make

			l_options_filter.set_next (person_handler)


			create l_methods
			l_methods.enable_options
			l_methods.enable_get
			l_methods.enable_post
			router.handle_with_request_methods ("/persons", create {WSF_URI_TEMPLATE_AGENT_HANDLER}.make (agent l_options_filter.execute), l_methods)


			create l_methods
			l_methods.enable_options
			l_methods.enable_get
			l_methods.enable_delete
			l_methods.enable_put
			router.handle_with_request_methods ("/persons/{person_id}", create {WSF_URI_TEMPLATE_AGENT_HANDLER}.make (agent l_options_filter.execute), l_methods)

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

end
