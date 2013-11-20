note
	description: "Summary description for {SHARED_DATABASE_API}."
	author: ""
	date: "$Date: 2013-06-17 13:33:32 -0300 (lun 17 de jun de 2013) $"
	revision: "$Revision: 49 $"

class
	SHARED_DATABASE_API

feature -- API

	task_mgr: TASK_MANAGER
		once
			create Result
		end


	clean
		do
			(create {SHARED_DATABASE_MANAGER}).clean_db
		end
end
