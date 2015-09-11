note
	description : "simple application root class"
	date        : "$Date: 2013-06-19 13:31:07 -0300 (mié 19 de jun de 2013) $"
	revision    : "$Revision: 62 $"

deferred class
	APP_SERVICE

inherit
	WSF_LAUNCHABLE_SERVICE
		redefine
			initialize
		end

	SHARED_EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end

--create
--	make_and_launch

feature {NONE} -- Initialization

	initialize
			-- Initialize current service.
		do
			Precursor
			create {APP_FS_DATABASE} database.make (execution_environment.current_working_path.extended (".db"))
		end


feature -- Access

	database: APP_DATABASE


end
