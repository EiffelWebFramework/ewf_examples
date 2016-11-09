note
	description: "[
				application service
			]"
	date: "$Date$"
	revision: "$Revision$"

class
	EWF_YOU_TYPE_IT

inherit

	WSF_LAUNCHABLE_SERVICE
		redefine
			initialize
		end

	ARGUMENTS

create
	make_and_launch

feature {NONE} -- Initialization

	initialize
			-- Initialize current service.
		do
			Precursor
			set_service_option ("port", 8888)
			set_service_option ("verbose", True)
		end

feature {NONE} -- Launch operation

	launch (opts: detachable WSF_SERVICE_LAUNCHER_OPTIONS)
		local
			l_retry: BOOLEAN
			l_message: STRING
			launcher: APPLICATION_LAUNCHER [EWF_YOU_TYPE_IT_EXECUTION]
		do
			create launcher
			launcher.launch (opts)
		end

end

