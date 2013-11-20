note
	description: "Summary description for {PERSON_REPOSITORY}."
	author: ""
	date: "$Date: 2013-07-10 18:11:34 -0300 (mié, 10 jul 2013) $"
	revision: "$Revision: 131 $"

deferred class
	PERSON_REPOSITORY

feature -- Access
	all_persons : LIST[PERSON]
		-- retrieve all persons from the storage
		deferred
		end

	person_by_username (username : READABLE_STRING_GENERAL) : detachable PERSON
		-- retrieve a person by username `username'
		deferred
		end

	count : INTEGER
		-- Number of persons in the storage
		deferred
		end

	exist_person (a_person : PERSON) : BOOLEAN
			-- exist Person?
		do
			Result := attached person_by_username (a_person.username)
		end

feature -- New Person
	new (a_person : PERSON)
			-- Create a new person `a_person'
		require
			not_exist : not exist_person (a_person)
		deferred
		ensure
			exist : exist_person (a_person)
		end

feature -- Update Person
	update (a_person : PERSON)
		require
			exist : exist_person (a_person)
		deferred
		end

feature -- Delete Person
	delete (a_person : PERSON)
		require
			exist : exist_person (a_person)
		deferred
		ensure not_exist : not exist_person (a_person)
		end
end
