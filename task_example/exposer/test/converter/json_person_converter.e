note
	description: "{JSON_PERSON_CONVERTER}."
	author: ""
	date: "$Date: 2013-07-02 12:40:01 -0300 (mar 02 de jul de 2013) $"
	revision: "$Revision: 87 $"

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
			if attached {INTEGER_32} json.object (j.item (age_key), Void) as l_age then
				o.set_age (l_age)
			end
			if attached {INTEGER_32} json.object (j.item (salary_key), Void) as l_salary then
				o.set_salary (l_salary)
			end
			Result := o
		end

    to_json (o: like object): like value
            -- Convert to JSON value
        do
        	create Result.make
     	    Result.put (json.value (o.age), age_key)
	        Result.put (json.value (o.salary),salary_key)
         end

 feature {NONE} -- Implementation
	age_key: JSON_STRING
        once
            create Result.make_json ("age")
        end


	salary_key: JSON_STRING
        once
            create Result.make_json ("salary")
        end
end
