note
	description: "Summary description for {SHARED_DATABASE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_DATABASE

feature -- Database

	database: DATABASE
		once ("PROCESS")
			create Result.make
		end

end
