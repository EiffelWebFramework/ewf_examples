note
	description: "Summary description for {JSON_TASK_CONVERTER}."
	author: ""
	date: "$Date: 2013-07-03 14:09:33 -0300 (mié 03 de jul de 2013) $"
	revision: "$Revision: 91 $"

class
	JSON_TASK_CONVERTER

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
	 object : TASK
	 value : detachable JSON_OBJECT

feature -- Conversion

	from_json (j: attached  like value): detachable like object
            -- Convert from JSON value. Returns Void if unable to convert
       local
            o: TASK
            is_valid_from_json : BOOLEAN
        do
            is_valid_from_json := True
			create o
			if attached {STRING_32} json.object (j.item (id_key), Void) as l_id then
				o.set_id (l_id.to_integer_64)
			end
			if attached {STRING_32} json.object (j.item (description_key), Void) as l_description then
				o.set_description (l_description)
			end

			if attached json.object (j.item (completed_key), Void) as l_value then
				if attached {STRING_32} l_value as l_completed then
					if l_completed.is_boolean and then l_completed.to_boolean then
						o.mark_completed
					end
				elseif	attached {BOOLEAN} l_value as l_boolean then
					if l_boolean then
						o.mark_completed
					end
				end
			end

			if attached {STRING_32} json.object (j.item (date_due_key), Void) as l_date_due then
				o.set_date_due_from_string (l_date_due)
			end

			if attached {STRING_32} json.object (j.item (created_at_key), Void) as l_created_at then
				o.set_created_from_string (l_created_at)
			end

			Result := o
		end

    to_json (o: like object): like value
            -- Convert to JSON value
        do
        	create Result.make
     	    Result.put (json.value (o.id), id_key)
            Result.put (json.value (o.description),description_key)
            Result.put (json.value (o.completed.out), completed_key)
            Result.put (json.value (o.created_date_string), created_at_key)
            Result.put (json.value (o.date_due_string), date_due_key)
         end

 feature {NONE} -- Implementation
	id_key: JSON_STRING
        once
            create Result.make_json ("id")
        end


	description_key: JSON_STRING
        once
            create Result.make_json ("description")
        end


   completed_key: JSON_STRING
        once
            create Result.make_json ("completed")
        end

   created_at_key : JSON_STRING
	 	once
    		create Result.make_json ("created_at")
    	end


	date_due_key : JSON_STRING

    	once
    		create Result.make_json ("date_due")
    	end

end

