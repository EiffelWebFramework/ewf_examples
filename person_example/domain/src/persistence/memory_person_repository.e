note
	description: "Summary description for {MEMORY_PERSON_REPOSITORY}."
	author: ""
	date: "$Date: 2013-07-10 18:11:34 -0300 (mié, 10 jul 2013) $"
	revision: "$Revision: 131 $"

class
	MEMORY_PERSON_REPOSITORY
	inherit
		PERSON_REPOSITORY
create
	make
feature {NONE} -- Initialization
	make
		do
			create storage.make(10)
		end
feature -- Access		
	all_persons : LIST[PERSON]
		-- retrieve all persons from the storage
		do
			Result := storage.linear_representation
		end

	person_by_username (username : READABLE_STRING_GENERAL) : detachable PERSON
		-- retrieve a person by username `username'
		do
			Result := storage.at (username)
		end

	count : INTEGER
		-- Number of persons in the storage
		do
			Result := storage.count
		end


feature -- New Person
	new (a_person : PERSON)
			-- Create a new person `a_person'
		do
			storage.force (a_person,a_person.username)
		end

feature -- Update Person
	update (a_person : PERSON)
		do
			storage.force (a_person, a_person.username)
		end

feature -- Delete Person
	delete (a_person : PERSON)
		do
			storage.remove (a_person.username)
		end

feature {NONE}-- Implementation

	storage : HASH_TABLE[PERSON,READABLE_STRING_GENERAL]

end
