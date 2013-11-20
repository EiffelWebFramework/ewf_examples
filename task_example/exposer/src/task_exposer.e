note
	description: "Summary description for {TASK_EXPOSER}."
	author: ""
	date: "$Date: 2013-07-11 16:14:55 -0300 (jue, 11 jul 2013) $"
	revision: "$Revision: 134 $"

class
	TASK_EXPOSER

inherit

	EXPOSER [TASK]
		redefine
			default_create
		end


create
	from_domain

feature  {NONE} -- Initialization

	default_create
		do
			Precursor
			initialize_fields
		end

	initialize_fields
		do
			create fields.make (2)
		end

feature -- Access

	id : INTEGER_64
		do
			if attached {INTEGER_64} fields.at (id_key) as l_id then
				Result := l_id
			end
		end

	description : STRING
		do
			Result := ""
			if attached {STRING_32} fields.at (description_key ) as l_description then
				Result := l_description
			end
		end


	created_at : STRING
		local
			l_date : DATE_TIME
		do
			create l_date.make_from_epoch (0)
			Result :=l_date.formatted_out ((create {CONSTANTS}).date_format)
			if attached {STRING} fields.at (created_at_key) as l_created then
				Result := l_created
			end
		end

	date_due : STRING
		local
			l_date : DATE_TIME
		do
			create l_date.make_from_epoch (0)
			Result :=l_date.formatted_out ((create {CONSTANTS}).date_format)
			if attached {STRING} fields.at (date_due_key) as l_created then
				Result := l_created
			end
		end

	is_completed : BOOLEAN
		do
			if attached {BOOLEAN} fields.at (completed_key) as l_completed then
				Result := l_completed
			end

		end
feature -- Validations

	is_valid_id (a_id : INTEGER_64) : BOOLEAN
		do
			Result := id > 0
		end

	is_valid : BOOLEAN
			-- are the fiels in a valid state
		do
			Result := to_domain.is_valid_date
		end

feature -- Exposure to Domain

	to_domain: TASK
			-- Object built from `fields'.
		do
			create Result
			if is_valid_id (id) then
				Result.set_id (id)
			end
			Result.set_date_due_from_string (date_due)
			Result.set_created_from_string (created_at)
			Result.set_description (description)
			if is_completed then
				Result.mark_completed
			end
		end

feature -- From Domain

	from_domain (obj: TASK)
			-- Set `fields' from `obj'.
		do
			initialize_fields
			add_key (id_key, obj.id)
			add_key (description_key, obj.description)
			add_key (created_at_key, obj.created_date_string)
			add_key (date_due_key, obj.date_due_string)
			add_key (completed_key, obj.completed)
		end

feature -- Set fields
	set_id (a : INTEGER_64)
		do
			add_key (id_key, a)
		end

	set_description (d : STRING)
		do
			add_key (description_key,d)
		end

	set_created_at (d : STRING)
		do
			add_key (created_at_key,d)
		end

	set_date_due (d : STRING)
		do
			add_key (date_due_key,d)
		end

feature {NONE} -- Implementation

	id_key: STRING = "id"

	description_key: STRING = "description"

	completed_key: STRING = "completed"

	created_at_key :STRING = "created_at"

	date_due_key : STRING = "date_due"

feature -- Etag Calculation
	representation : STRING
			-- task exposer representation
		do
			Result:= id.out + "_" + created_at + "_" +date_due + "_" + description

		end
end
