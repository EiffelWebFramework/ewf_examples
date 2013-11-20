note
	description: "Summary description for {TASK}."
	author: ""
	date: "$Date: 2013-07-02 16:35:18 -0300 (mar 02 de jul de 2013) $"
	revision: "$Revision: 88 $"

class
	TASK

inherit

	ANY
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
		local
			l_date: DATE_TIME
		do
			set_description ("")
			create l_date.make_from_epoch (0)
			set_created_at (l_date)
			set_date_due (l_date)
		end

feature -- Access

	id: INTEGER_64
			-- Unique id
			--| can be used to represent an object in database.

	description: READABLE_STRING_GENERAL
			-- task description

	completed: BOOLEAN
			-- is the task completed?

	created_at: DATE_TIME
			-- when the task was created?
			-- YYYY-MM-DD HH:MM:SS

	date_due: DATE_TIME
			-- date due

feature -- Status report

	has_id: BOOLEAN
		do
			Result := id > 0
		end

	created_date_string: STRING
		do
			Result := created_at.formatted_out ((create {CONSTANTS}).date_format)
		end

	date_due_string: STRING
		do
			Result := date_due.formatted_out ((create {CONSTANTS}).date_format)
		end

feature -- Validation

	is_valid_date : BOOLEAN
		do
			Result := created_at.is_less_equal (date_due)
		end


feature -- Element change

	set_id (i: INTEGER_64)
			-- Set `id' to `i'
		require
			id_positive: i > 0
		do
			id := i
		ensure
			id_set: id = i
		end

	mark_completed
		do
			completed := True
		ensure
			task_completed: completed = True
		end

	set_description (new_description: STRING_32)
		do
			description := new_description
		ensure
			description_set: description.same_string (new_description)
		end

	set_created_at (a_date: like created_at)
		do
			created_at := a_date
		ensure
			created_at_set: created_at = a_date
		end

	set_date_due (a_date: like date_due)
		do
			date_due := a_date
		ensure
			date_due_set: date_due = a_date
		end

	set_created_from_string (a_date: STRING)
		do
			create created_at.make_from_string (a_date,(create {CONSTANTS}).date_format)

		end

	set_date_due_from_string (a_date: STRING)
		do
			create date_due.make_from_string (a_date,(create {CONSTANTS}).date_format)
		end

feature -- Output
	debug_output : STRING
		do
			create Result.make_empty
			Result.append ("[id]:")
			Result.append (id.out)
			Result.append ("%N")
			Result.append ("[description]:")
			Result.append (description.as_string_32)
			Result.append ("%N")
			Result.append ("[completed]:")
			Result.append (completed.out)
			Result.append ("%N")
			Result.append ("[created_at]:")
			Result.append (created_date_string)
			Result.append ("%N")
			Result.append ("[date_due]:")
			Result.append (date_due_string)
			Result.append ("%N")

		end
invariant
	valid_date: created_at.is_less_equal (date_due)

end
