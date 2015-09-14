note
	description: "Summary description for {PERSON_REST_SERVER}."
	date: "$Date: 2013-07-10 18:11:34 -0300 (mié, 10 jul 2013) $"
	revision: "$Revision: 131 $"

deferred class
	PERSON_REST_SERVER

inherit

	WSF_LAUNCHABLE_SERVICE

	SHARED_EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end

end
