note
	description: "Summary description for {TASK_MANAGER}."
	author: ""
	date: "$Date: 2013-06-18 15:31:35 -0300 (mar 18 de jun de 2013) $"
	revision: "$Revision: 59 $"

class
	TASK_MANAGER

inherit

	SHARED_DATABASE_MANAGER



feature -- Query

	retrieve_by_id (an_id: INTEGER_64): detachable TASK
			-- retrive user by id from db
		local
			l_query: SQLITE_QUERY_STATEMENT
		do
				-- clean all the previous results
			last_retrieve_by_id_result := Void

				-- Query the contents of the Example table

			create l_query.make ("SELECT id,description, created_at, date_due, completed FROM TASKS where id = :TASK_ID;", db)
			check
				l_query_is_compiled: l_query.is_compiled
			end
			l_query.execute_with_arguments (agent  (ia_row: SQLITE_RESULT_ROW): BOOLEAN
				local
					l_task: TASK
				do
					create l_task
					if not ia_row.is_null (1) then
						l_task.set_id (ia_row.integer_64_value (1))
					end
					if not ia_row.is_null (2) then
						l_task.set_description (ia_row.string_value (2))
					end
					if not ia_row.is_null (4) then
						l_task.set_date_due_from_string (ia_row.string_value (4))
					end
					if not ia_row.is_null (3) then
						l_task.set_created_from_string (ia_row.string_value (3))
					end
					if not ia_row.is_null (5) and then ia_row.integer_value (5) = 1 then
						l_task.mark_completed
					end
					if l_task.has_id then
						last_retrieve_by_id_result := l_task
					end

				end, [create {SQLITE_INTEGER_ARG}.make (":TASK_ID", an_id)])
			Result := last_retrieve_by_id_result
		end

	retrieve_all: LIST [TASK]
			-- retrive all tasks from db_mgr
		local
			l_query: SQLITE_QUERY_STATEMENT
		do
				-- clean all the previous results
			create {ARRAYED_LIST [TASK]} last_retrieve_all_result.make (0)
			create {ARRAYED_LIST [TASK]} Result.make (0)
				-- Query the contents of the Example table
			create l_query.make ("SELECT id,description,created_at,date_due,completed FROM TASKS;", db)
			check
				l_query_is_compiled: l_query.is_compiled
			end
			l_query.execute (agent  (ia_row: SQLITE_RESULT_ROW): BOOLEAN
				local
					l_task: TASK
				do
					create l_task
					if not ia_row.is_null (1) then
						l_task.set_id (ia_row.integer_64_value (1))
					end
					if not ia_row.is_null (2) then
						l_task.set_description (ia_row.string_value (2))
					end
					if not ia_row.is_null (4) then
						l_task.set_date_due_from_string (ia_row.string_value (4))
					end
					if not ia_row.is_null (3) then
						l_task.set_created_from_string (ia_row.string_value (3))
					end
					if not ia_row.is_null (5) and then ia_row.integer_value (5) = 1 then
						l_task.mark_completed
					end
					if attached last_retrieve_all_result as lrq then
						lrq.force (l_task)
					end
				end)
				if attached last_retrieve_all_result as lrq then
					Result := lrq
				end
		end

	retrieve_close: LIST [TASK]
			-- retrive all tasks from db_mgr with status open
		local
			l_query: SQLITE_QUERY_STATEMENT
		do
				-- clean all the previous results
			create {ARRAYED_LIST [TASK]} last_retrieve_all_result.make (0)
			create {ARRAYED_LIST [TASK]} Result.make (0)
				-- Query the contents of the Example table
			create l_query.make ("SELECT id,description,created_at,date_due,completed FROM TASKS where completed = 1;", db)
			check
				l_query_is_compiled: l_query.is_compiled
			end
			l_query.execute (agent  (ia_row: SQLITE_RESULT_ROW): BOOLEAN
				local
					l_task: TASK
				do
					create l_task
					if not ia_row.is_null (1) then
						l_task.set_id (ia_row.integer_64_value (1))
					end
					if not ia_row.is_null (2) then
						l_task.set_description (ia_row.string_value (2))
					end
					if not ia_row.is_null (4) then
						l_task.set_date_due_from_string (ia_row.string_value (4))
					end
					if not ia_row.is_null (3) then
						l_task.set_created_from_string (ia_row.string_value (3))
					end
					if not ia_row.is_null (5) and then ia_row.integer_value (5) = 1 then
						l_task.mark_completed
					end
					if attached last_retrieve_all_result as lrq then
						lrq.force (l_task)
					end
				end)
				if attached last_retrieve_all_result as lrq then
					Result := lrq
				end
		end


	retrieve_open: LIST [TASK]
			-- retrive all tasks from db_mgr with status open
		local
			l_query: SQLITE_QUERY_STATEMENT
		do
				-- clean all the previous results
			create {ARRAYED_LIST [TASK]} last_retrieve_all_result.make (0)
			create {ARRAYED_LIST [TASK]} Result.make (0)
				-- Query the contents of the Example table
			create l_query.make ("SELECT id,description,created_at,date_due,completed FROM TASKS where completed = 0;", db)
			check
				l_query_is_compiled: l_query.is_compiled
			end
			l_query.execute (agent  (ia_row: SQLITE_RESULT_ROW): BOOLEAN
				local
					l_task: TASK
				do
					create l_task
					if not ia_row.is_null (1) then
						l_task.set_id (ia_row.integer_64_value (1))
					end
					if not ia_row.is_null (2) then
						l_task.set_description (ia_row.string_value (2))
					end
					if not ia_row.is_null (4) then
						l_task.set_date_due_from_string (ia_row.string_value (4))
					end
					if not ia_row.is_null (3) then
						l_task.set_created_from_string (ia_row.string_value (3))
					end
					if not ia_row.is_null (5) and then ia_row.integer_value (5) = 1 then
						l_task.mark_completed
					end
					if attached last_retrieve_all_result as lrq then
						lrq.force (l_task)
					end
				end)
				if attached last_retrieve_all_result as lrq then
					Result := lrq
				end
		end


	retrieve_pages  (index : INTEGER; offset : INTEGER): LIST [TASK]
			-- retrive pages  based on index and offset
		local
			l_query: SQLITE_QUERY_STATEMENT
		do
				-- clean all the previous results
			create {ARRAYED_LIST [TASK]} last_retrieve_all_result.make (0)
			create {ARRAYED_LIST [TASK]} Result.make (0)
				-- Query the contents of the Example table
			create l_query.make ("SELECT id,description,created_at,date_due,completed FROM TASKS LIMIT :INDEX  OFFSET :OFFSET;", db)
			check
				l_query_is_compiled: l_query.is_compiled
			end
			l_query.execute_with_arguments (agent  (ia_row: SQLITE_RESULT_ROW): BOOLEAN
				local
					l_task: TASK
				do
					create l_task
					if not ia_row.is_null (1) then
						l_task.set_id (ia_row.integer_64_value (1))
					end
					if not ia_row.is_null (2) then
						l_task.set_description (ia_row.string_value (2))
					end
					if not ia_row.is_null (3) then
						l_task.set_created_from_string (ia_row.string_value (3))
					end
					if not ia_row.is_null (4) then
						l_task.set_date_due_from_string (ia_row.string_value (4))
					end
					if not ia_row.is_null (5) and then ia_row.integer_value (5) = 1 then
						l_task.mark_completed
					end
					if attached last_retrieve_all_result as lrq then
						lrq.force (l_task)
					end
				end,[create {SQLITE_INTEGER_ARG}.make (":INDEX", index), create {SQLITE_INTEGER_ARG}.make (":OFFSET", offset)])
				if attached last_retrieve_all_result as lrq then
					Result := lrq
				end
		end



feature -- Update

	update (a_task: TASK)
			-- update a task with `a_task'
		local
			l_update: SQLITE_MODIFY_STATEMENT
			l_completed : SQLITE_INTEGER_ARG
		do
				-- Create an update statement with variables

			create l_update.make ("UPDATE TASKS SET description = :DESCRIPTION,  date_due = :DATE_DUE , completed = :COMPLETED where id = :TASK_ID;", db)
			check
				l_update_is_compiled: l_update.is_compiled
			end
				-- Commit handling
			if a_task.completed then
				create l_completed.make (":COMPLETED", 1)
			else
				create l_completed.make (":COMPLETED", 0)
			end
			db.begin_transaction (False)
			l_update.execute_with_arguments ([create {SQLITE_STRING_ARG}.make (":DESCRIPTION", a_task.description.as_string_32),
											create {SQLITE_STRING_ARG}.make (":DATE_DUE",	a_task.date_due_string),
											l_completed, create {SQLITE_INTEGER_ARG}.make (":TASK_ID", a_task.id)])
				-- Commit changes
			db.commit
		end

feature -- Insert

	new_task (a_task: TASK)
			-- insert a new task `a_task'
		local
			l_insert: SQLITE_INSERT_STATEMENT
			l_completed : SQLITE_INTEGER_ARG
		do
				-- Create a insert statement with variables
			create l_insert.make ("INSERT INTO TASKS (description,created_at,date_due,completed) VALUES (:DESCRIPTION, :CREATED_AT, :DATE_DUE, :COMPLETED);", db)
			check
				l_insert_is_compiled: l_insert.is_compiled
			end
			if a_task.completed then
				create l_completed.make (":COMPLETED", 1)
			else
				create l_completed.make (":COMPLETED", 0)
			end


				-- Commit handling
			db.begin_transaction (False)
			l_insert.execute_with_arguments ([create {SQLITE_STRING_ARG}.make (":DESCRIPTION", a_task.description.as_string_32),
											create {SQLITE_STRING_ARG}.make (":CREATED_AT",	a_task.created_date_string),
											create {SQLITE_STRING_ARG}.make (":DATE_DUE",	a_task.date_due_string),
											l_completed])

				-- Commit changes
			last_row_id := l_insert.last_row_id
			a_task.set_id (last_row_id)
			db.commit
		end

feature -- Delete

	delete_by_id (task_id: INTEGER_64)
			-- delete a row with ID `an_id' from db
		local
			l_delete: SQLITE_MODIFY_STATEMENT
		do
				-- Create a DELETE statement with variables

			create l_delete.make ("DELETE FROM TASKS WHERE id = :TASK_ID;", db)
			check
				l_delete_is_compiled: l_delete.is_compiled
			end

				-- Commit handling
			db.begin_transaction (False)
			l_delete.execute_with_arguments ([create {SQLITE_INTEGER_ARG}.make (":TASK_ID", task_id)])
				-- Commit changes
			db.commit
		end


feature {NONE} -- Implementation

	last_retrieve_all_result: detachable LIST [TASK]
	last_retrieve_by_id_result: detachable TASK
	last_row_id : INTEGER_64

end
