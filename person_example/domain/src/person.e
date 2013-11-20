note
	description: "Summary description for {PERSON}."
	author: ""
	date: "$Date: 2013-07-10 18:11:34 -0300 (mié, 10 jul 2013) $"
	revision: "$Revision: 131 $"

class
	PERSON
inherit
	ANY
		redefine
			default_create
		end
feature {NONE}-- Initialization
	default_create
		do
			username := ""
		end

feature -- Access

	username : READABLE_STRING_GENERAL

	age: INTEGER

	salary: INTEGER

feature -- Commmand

	set_username ( new_username : READABLE_STRING_GENERAL)
		do
			username := new_username
		ensure
			username_set : new_username = username
		end

	set_age (an_age: INTEGER)
		do
			age := an_age
		ensure
			age_set: age = an_age
			valid_age : is_valid_age (age)
		end

	set_salary (a_salary: INTEGER)
		do
			salary := a_salary
		ensure
			salary_set: salary = a_salary
			valid_salary : is_valid_salary(salary)
		end

	pass_birthday
		do
			age := age + 1
		ensure
			age = old age + 1
		end

	raise (a: INTEGER)
		require
			valid_salary : is_valid_salary (a)
		do
			salary := salary + a
		ensure
			salary = old salary + a
		end

	is_valid_salary (a : INTEGER) : BOOLEAN
		do
			Result := a >= 0 and then a <= salary
		end

	is_valid_age (a : INTEGER): BOOLEAN
		do
			Result := age>= 0 and then age <= 120
		end

invariant
	age >= 0 -- We could use NATURAL of course
	age <= 120
	salary >= 0
	salary <= 10000

end
