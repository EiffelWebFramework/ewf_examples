note
	description: "Summary description for {PERSON_EXPOSER_PERSISTENCE}."
	author: ""
	date: "$Date: 2013-07-10 18:11:34 -0300 (mié, 10 jul 2013) $"
	revision: "$Revision: 131 $"

class
	PERSON_EXPOSER_PERSISTENCE

create
	make

feature {NONE} -- Initialization

	make
		do
			create {MEMORY_PERSON_REPOSITORY} person_repository.make
		end

feature -- Access

	all_persons: LIST [PERSON_EXPOSER]
			-- retrieve all persons from the storage
		local
			l_ep : PERSON_EXPOSER
		do
			create {ARRAYED_LIST[PERSON_EXPOSER]}Result.make (0)
			across person_repository.all_persons as elem loop
				create l_ep.from_domain (elem.item)
				Result.force (l_ep)
			end
		end

	person_by_username (username: READABLE_STRING_GENERAL): detachable PERSON_EXPOSER
			-- retrieve a person by username `username'
		do
		 	if attached person_repository.person_by_username (username) as l_person then
		 		create Result.from_domain (l_person)
		 	end
		end

	count: INTEGER
			-- Number of persons in the storage
		do
			Result := person_repository.count
		end

	exist_person (a_person: PERSON_EXPOSER): BOOLEAN
			-- exist Person?
		do
			Result := attached person_by_username (a_person.username)
		end

feature -- New Person

	new (a_person: PERSON_EXPOSER)
			-- Create a new person `a_person'
		require
			not_exist: not exist_person (a_person)
		do
			person_repository.new (a_person.to_domain)
		ensure
			exist: exist_person (a_person)
		end

feature -- Update Person

	update (a_person: PERSON_EXPOSER)
		require
			exist: exist_person (a_person)
		do
			person_repository.update (a_person.to_domain)
		end

feature -- Delete Person

	delete (a_person: PERSON_EXPOSER)
		require
			exist: exist_person (a_person)
		do
			person_repository.delete (a_person.to_domain)
		ensure
			not_exist: not exist_person (a_person)
		end

feature {NONE} -- Implementation

	person_repository: PERSON_REPOSITORY

end
