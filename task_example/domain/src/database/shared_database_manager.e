note
	description: "Summary description for {SHARED_DATABASE_MANAGER}."
	author: ""
	date: "$Date: 2013-07-09 11:09:46 -0300 (mar 09 de jul de 2013) $"
	revision: "$Revision: 109 $"


class
	SHARED_DATABASE_MANAGER

inherit

	SQLITE_SHARED_API

feature -- db Manager

	db: SQLITE_DATABASE
			-- a shared db instance of sqlite, create the db if it does not exist.
		local
			l_modify: SQLITE_MODIFY_STATEMENT
			l_query: SQLITE_QUERY_STATEMENT
			has_tasks_table :BOOLEAN
		once
--			io.error.put_string ("%NOpening Database...%N")

				-- Open/create a Database.
			create Result.make_create_read_write ("tasks.sqlite")
			create l_query.make ("SELECT name FROM sqlite_master ORDER BY name;", Result)
			across
				l_query.execute_new as c
			loop
				if c.item.count >= 1 and then attached c.item.string_value (1) as l_table_name then
--					io.error.put_string (" - table: " + l_table_name + "%N")
					if l_table_name.is_case_insensitive_equal ("task") then
						has_tasks_table := True
					end
				end
			end

				-- Create a new table tasks
			if not has_tasks_table then
				create l_modify.make ("CREATE TABLE IF NOT EXISTS TASKS (  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,  description varchar NOT NULL DEFAULT '', created_at datetime DEFAULT NULL, date_due datetime DEFAULT NULL, completed INTEGER DEFAULT '0');", Result)
				l_modify.execute
				if l_modify.changes_count > 0 then
--					io.error.put_string ("TASKS Table created.%N")
				end
			end

		end

	clean_db
			--db clean
		local
			l_query: SQLITE_QUERY_STATEMENT
			l_delete: SQLITE_MODIFY_STATEMENT
			l_db : SQLITE_DATABASE
		do


				-- Open/create a Database.
			create l_db.make_create_read_write ("tasks.sqlite")
			create l_query.make ("SELECT name FROM sqlite_master ORDER BY name;", l_db)
			across
				l_query.execute_new as c
			loop
				if c.item.count >= 1 and then attached c.item.string_value (1) as l_table_name then
--					io.error.put_string (" Deleting- table: " + l_table_name + "%N")
					create l_delete.make ("DELETE FROM " + l_table_name + ";", db)
						check
							l_delete_is_compiled: l_delete.is_compiled
						end

							-- Commit handling
						l_delete.execute

				end
			end

		end

end
