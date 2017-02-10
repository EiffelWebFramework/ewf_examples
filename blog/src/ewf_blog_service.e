note
	description: "[
				application service
			]"
	date: "$Date$"
	revision: "$Revision$"

class
	EWF_BLOG_SERVICE

inherit

	WSF_LAUNCHABLE_SERVICE
		redefine
			initialize
		end
	SHARED_DATABASE

	ARGUMENTS

create
	make_and_launch

feature {NONE} -- Initialization

	initialize
			-- Initialize current service.
		do
			Precursor
			set_service_option ("port", 9090)
			if attached initialize_database then
			end
		end

feature {NONE} -- Launch operation

	launch (opts: detachable WSF_SERVICE_LAUNCHER_OPTIONS)
		local
			launcher: APPLICATION_LAUNCHER [EWF_BLOG_EXECUTION]
		do
			create launcher
			launcher.launch (opts)
		end

end

