note
	description: "Summary description for {EWF_PERSON_EXECUTION}."
	date: "$Date$"
	revision: "$Revision$"

class
	EWF_PERSON_EXECUTION

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
		do
			initialize_router
		end

	setup_router
		local
			person_handler: PERSON_HANDLER
			l_methods: WSF_REQUEST_METHODS
			fhdl: WSF_FILE_SYSTEM_HANDLER
			doc: WSF_ROUTER_SELF_DOCUMENTATION_HANDLER
		do
			create person_handler.make (storage)
			create l_methods
			l_methods.enable_options
			l_methods.enable_get
			l_methods.enable_post
			router.handle_with_request_methods ("/persons",person_handler, l_methods)
			create l_methods
			l_methods.enable_options
			l_methods.enable_get
			l_methods.enable_delete
			l_methods.enable_put
			router.handle_with_request_methods ("/persons/{person_id}",person_handler, l_methods)
			create doc.make_hidden (router)
			create fhdl.make_hidden ("www")
			fhdl.set_directory_index (<<"index.html">>)
			router.handle_with_request_methods ("/", fhdl, router.methods_GET)
			router.handle_with_request_methods ("/api/doc", doc, router.methods_GET)
		end


	storage: PERSON_EXPOSER_PERSISTENCE
		once ("PROCESS")
			create Result.make
		end
end

