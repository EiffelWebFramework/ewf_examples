note
	description: "Summary description for {APPLICATION}."
	author: ""
	date: "$Date: 2013-06-28 12:44:39 -0300 (vie 28 de jun de 2013) $"
	revision: "$Revision: 79 $"

class
	APPLICATION

inherit
	HYPERMEDIA_REST_SERVICE
		redefine
			initialize
		end

create
	make_and_launch

feature {NONE} -- Initialization

	initialize
			-- Initialize current service.
		do
			Precursor
		end

feature {NONE} -- Launcher

	launch (a_service: WSF_SERVICE; opts: detachable WSF_SERVICE_LAUNCHER_OPTIONS)
		local
			launcher: WSF_SERVICE_LAUNCHER
		do
			create {WSF_DEFAULT_SERVICE_LAUNCHER} launcher.make_and_launch (a_service, opts)
		end

end
