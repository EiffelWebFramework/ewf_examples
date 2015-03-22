note
	description : "Basic Service that Generate HTML using www as a document root"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	WSF_DEFAULT_SERVICE
		redefine
			initialize
		end

create
	make_and_launch

feature {NONE} -- Initialization

	initialize
			-- Initialize current service.
		do
--			set_service_option ("port", 9090)
			create {WSF_SERVICE_LAUNCHER_OPTIONS_FROM_INI} service_options.make_from_file ("server.ini")
			if
				attached service_options as l_service_options and then
				attached {STRING} l_service_options.option ("document_root") as l_doc_root
			then
				document_root := l_doc_root
			else
				document_root := "www"
			end
		end

feature -- Basic operations

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the incomming request
		do
			file_handler.execute ("", req,res)
		end

	file_handler: WSF_FILE_SYSTEM_HANDLER
		once
			create Result.make_hidden (document_root)
			Result.set_directory_index (<<"index.html">>)
		end


	document_root: STRING
			-- Server's document root

end
