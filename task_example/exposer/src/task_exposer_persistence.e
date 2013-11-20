note
	description: "Persistence exposer for tasks {TASK_EXPOSER_PERSISTENCE}."
	author: ""
	date: "$Date: 2013-07-09 16:57:59 -0300 (mar, 09 jul 2013) $"
	revision: "$Revision: 117 $"

class
	TASK_EXPOSER_PERSISTENCE

create
	make

feature {NONE} -- Initialization
	make
		do
			initiliaze_manager
		end

feature  -- Initialization
	initiliaze_manager
		local
			l_db_api : SHARED_DATABASE_API
		do
			create l_db_api
			manager := l_db_api.task_mgr
		end


feature -- Queries

	retrieve_by_id (id : like {TASK_EXPOSER}.id ) : detachable TASK_EXPOSER
		do
			if attached manager.retrieve_by_id (id) as l_task then
				create Result.from_domain (l_task)
			end
		end

	retrieve_all : LIST [TASK_EXPOSER]
		local
			l_exposer : TASK_EXPOSER
		do
			create {ARRAYED_LIST [TASK_EXPOSER]} Result.make (0)
			across manager.retrieve_all as elem loop
				create l_exposer.from_domain (elem.item)
				Result.force (l_exposer)
			end
		end

	retrieve_close : LIST [TASK_EXPOSER]
		local
			l_exposer : TASK_EXPOSER
		do
			create {ARRAYED_LIST [TASK_EXPOSER]} Result.make (0)
			across manager.retrieve_close as elem loop
				create l_exposer.from_domain (elem.item)
				Result.force (l_exposer)
			end
		end


	retrieve_open : LIST [TASK_EXPOSER]
		local
			l_exposer : TASK_EXPOSER
		do
			create {ARRAYED_LIST [TASK_EXPOSER]} Result.make (0)
			across manager.retrieve_open as elem loop
				create l_exposer.from_domain (elem.item)
				Result.force (l_exposer)
			end
		end


feature -- Update
	update ( a_task : TASK_EXPOSER)
		require
			is_valid : a_task.is_valid
		do
			manager.update (a_task.to_domain)
		end

feature -- Delete

	delete (a_task : TASK_EXPOSER)
		require
			is_valid : a_task.is_valid
		do
			manager.delete_by_id (a_task.id)
		end


	delete_by_id (a_task_id : like {TASK_EXPOSER}.id)
		require
			is_valid : a_task_id > 0
		do
			manager.delete_by_id (a_task_id)
		end

feature -- New

	new_task (a_task : TASK_EXPOSER)
		require
			is_valid : a_task.is_valid
		local
			l_task :TASK
		do
			l_task := a_task.to_domain
			manager.new_task (l_task)
			a_task.set_id (l_task.id)
		end

feature {NONE} -- Implementation


	manager : TASK_MANAGER

end
