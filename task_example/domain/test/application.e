note
	description : "test application root class"
	date        : "$Date: 2013-06-17 13:33:32 -0300 (lun 17 de jun de 2013) $"
	revision    : "$Revision: 49 $"

class
	APPLICATION

inherit
	ARGUMENTS
	SHARED_DATABASE_API
create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_task : TASK
		do

			create l_task
			task_mgr.new_task (l_task)
			if attached task_mgr.retrieve_by_id (2) as ll_task then
				print (ll_task.debug_output)
			end

			if attached task_mgr.retrieve_all as l_list then
				across l_list as elem
				loop
					print (elem.item.debug_output)
				end
			end

			task_mgr.delete_by_id (9)
			if attached task_mgr.retrieve_by_id (14) as ll_task then
				print (ll_task.debug_output)
				ll_task.mark_completed
				ll_task.set_description ("A new description")
				ll_task.set_date_due_from_string ("2013-06-25 09:33:13")
				task_mgr.update (ll_task)
			end
		end

end
