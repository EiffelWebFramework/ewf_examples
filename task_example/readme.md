Task Management Application
==

We will show how to implement a simple task management application using an `Hypermedia API` (Richardon Maturity Model Level 3)using `Collection+ JSON` and also we will show Pragmatic REST Implementation using JSON (Richardon Maturity Model Level 2)


Data Model
----------

```
class 
	TASK

feature  -- Access

	id: INTEGER_64
			-- Unique id

	description: READABLE_STRING_GENERAL
			-- task description

	completed: BOOLEAN
			-- is the task completed?

	created_at: DATE_TIME
			-- when the task was created?
			-- YYYY-MM-DD HH:MM:SS

	date_due: DATE_TIME
			-- date due
	
	
invariant
	valid_date: created_at.is_less_equal (date_due)

end -- class TASK
```


Identifying the State Transitions
----

# The collection of tasks
# A single task in the list
# A list of possible queries that can be executed against the tasks list
# A template or blueprint for adding or editing tasks
# Details of an error, if exists.


