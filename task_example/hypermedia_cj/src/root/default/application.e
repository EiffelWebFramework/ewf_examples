note
	description: "Summary description for {APPLICATION}."
	author: ""
	date: "$Date: 2013-06-28 12:44:39 -0300 (vie 28 de jun de 2013) $"
	revision: "$Revision: 79 $"

class
	APPLICATION

inherit
	HYPERMEDIA_REST_SERVER
		redefine
			initialize
		end

create
	make_and_launch

feature {NONE} -- Initialization

	initialize
			-- Initialize current service.
		do
			create {WSF_SERVICE_LAUNCHER_OPTIONS_FROM_INI} service_options.make_from_file ("server.ini")
		end


end
