note
	description: "Summary description for {APPLICATION_EXECUTION}."
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION_EXECUTION

inherit
	WSF_EXECUTION

create
	make

feature {NONE} -- Initialization


feature -- Basic operations

	execute
			-- Execute the incomming request
		do
			file_handler.execute ("", request, response)
		end

	file_handler: WSF_FILE_SYSTEM_HANDLER
		once
			create Result.make_hidden (document_root)
			Result.set_directory_index (<<"index.html">>)
		end


	document_root: STRING
			-- Server's document root
		local
			l_service_options: WSF_SERVICE_LAUNCHER_OPTIONS
		once ("PROCESS")
			create {WSF_SERVICE_LAUNCHER_OPTIONS_FROM_INI} l_service_options.make_from_file ("server.ini")
			if
				attached {STRING} l_service_options.option ("document_root") as l_doc_root
			then
				Result := l_doc_root
			else
				Result := "www"
			end
		end

end
