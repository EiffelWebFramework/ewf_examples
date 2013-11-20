note
	description: "{JSON_PERSON_CONVERTER}."
	author: ""
	date: "$Date: 2013-07-10 18:11:34 -0300 (mié, 10 jul 2013) $"
	revision: "$Revision: 131 $"

class
	JSON_PERSON_CONVERTER
inherit
	JSON_CONVERTER
create
	make
feature -- Initialization
	make
		do
			create object
		end

feature	 -- Access
	 object : PERSON
	 value : detachable JSON_OBJECT

feature -- Conversion

	from_json (j: attached  like value): detachable like object
            -- Convert from JSON value. Returns Void if unable to convert
       local
            o: PERSON
            is_valid_from_json : BOOLEAN
        do
            is_valid_from_json := True
			create o
			if attached json.object (j.item (age_key), Void) as l_value then
				if attached {INTEGER_8} l_value as l_age then
					o.set_age(l_age)
				elseif attached {INTEGER_16} l_value as l_age then
					o.set_age (l_age)
				elseif attached {INTEGER_32} l_value as l_age then
					o.set_age (l_age)
				end
			end

			if attached json.object (j.item (salary_key), Void) as l_value then
				if attached {INTEGER_8} l_value as l_salary then
					o.set_salary(l_salary)
				elseif attached {INTEGER_16} l_value as l_salary then
								o.set_salary (l_salary)
				elseif attached {INTEGER_32} l_value as l_salary then
					o.set_salary (l_salary)
				end
			end

			if attached {READABLE_STRING_GENERAL} json.object (j.item (username_key), Void) as l_username then
				o.set_username (l_username)
			end
			Result := o
		end

    to_json (o: like object): like value
            -- Convert to JSON value
        do
        	create Result.make
        	Result.put (json.value (o.username), username_key)
     	    Result.put (json.value (o.age), age_key)
	        Result.put (json.value (o.salary),salary_key)
         end

 feature {NONE} -- Implementation

	username_key: JSON_STRING
        once
            create Result.make_json ("username")
        end



	age_key: JSON_STRING
        once
            create Result.make_json ("age")
        end


	salary_key: JSON_STRING
        once
            create Result.make_json ("salary")
        end
end
