note
	description: "[
				application service
			]"
	date: "$Date: 2013-07-10 18:11:34 -0300 (mié, 10 jul 2013) $"
	revision: "$Revision: 131 $"

class
	EWF_PERSON

inherit

	PERSON_REST_SERVER
		redefine
			initialize
		end


create
	make_and_launch

feature {NONE} -- Initialization

	initialize
			-- Initialize current service.
		do
			set_service_option ("port", 9090)
			Precursor
		end

feature {NONE} -- Launch operation

	launch (opts: detachable WSF_SERVICE_LAUNCHER_OPTIONS)
		local
			launcher: APPLICATION_LAUNCHER [EWF_PERSON_EXECUTION]
		do
			create launcher
			launcher.launch (opts)
		end



end

