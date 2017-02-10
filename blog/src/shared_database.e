note
	description: "Summary description for {SHARED_DATABASE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_DATABASE

feature -- Database Access

	database: DATABASE
		note
            option: stable
        attribute
        	Result := initialize_database
        end

	initialize_database:  DATABASE
			-- Initialize database
		once 
			create Result.make
		end
end
