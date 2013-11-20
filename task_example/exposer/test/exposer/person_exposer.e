note
	description: "Summary description for {PERSON_EXPOSER}."
	author: ""
	date: "$Date: 2013-07-02 16:37:33 -0300 (mar 02 de jul de 2013) $"
	revision: "$Revision: 89 $"

class
	PERSON_EXPOSER

inherit

	EXPOSER [PERSON]

create
	from_domain

feature  {NONE} -- Initialization

	initialize_fields
		do
			create fields.make (2)
		end


feature -- Access

	salary: INTEGER
		do
			if attached {INTEGER} fields.at (salary_key) as l_salary then
				Result := l_salary
			end
		end

	age : INTEGER
		do
			if attached {INTEGER} fields.at (age_key) as l_age then
				Result := l_age
			end
		end

feature -- Validations

	is_valid_salary (s: INTEGER): BOOLEAN
			-- is a valid salary?
		do
			Result := to_domain.is_valid_salary (s)
		end


	is_valid_age (a : INTEGER) : BOOLEAN
			-- is a valid age?
		do
			Result := to_domain.is_valid_age (a)
		end


	is_valid : BOOLEAN
			-- are the fiels in a valid state
		do
			if attached {INTEGER_32} fields.at (age_key) as l_age and then
				 attached {INTEGER_32} fields.at (salary_key) as l_salary  then
				Result := is_valid_age (l_age) and then is_valid_salary (l_salary)
			end
		end

feature -- Exposure to Domain

	to_domain: PERSON
			-- Object built from `fields'.
		do
			create Result
			if attached {INTEGER_32} fields.at (age_key) as l_age then
				Result.set_age (l_age)
			end
			if attached {INTEGER_32} fields.at (salary_key) as l_salary then
				Result.set_salary (l_salary)
			end
		end

feature -- From Domain

	from_domain (obj: PERSON)
			-- Set `fields' from `obj'.
		do
			initialize_fields
			add_key (age_key, obj.age)
			add_key (salary_key, obj.salary)
		end


feature -- Set fields
	set_age (a : INTEGER)
		require
			valid : is_valid_age (a)
		do
			add_key (age_key, a)
		end

	set_salary (a : INTEGER)
		require
			valid : is_valid_salary (a)
		do
			add_key (salary_key, a)
		end

feature {NONE} -- Implementation

	age_key: STRING
		do
			create Result.make_from_string ("age")
		end

	salary_key: STRING
		do
			create Result.make_from_string ("salary")
		end

end

