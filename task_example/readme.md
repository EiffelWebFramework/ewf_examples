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


Identifying the State Transitions

The collection of tasks
A single task in the list
A list of possible queries that can be executed against the tasks list
A template or blueprint for adding or editing tasks
Details of an error, if exists.



Pragmatic REST Implementation using JSON (Richardon Maturity Model Level 2)
============================================================================
JSON format
{
    "id": id
    "description": description
    "completed": true/flase
    "created_at": datetime
    "date_due": datetime
}

Task Protocol

Verb	 URI or template	Use
POST	/tasks				Create a new task, and upon success, receive a Location header specifying the new tasks's URI.
GET		/tasks				Create a new task, and upon success, receive a Location header specifying the new tasks's URI.
GET		/tasks/{task_id}	Request the current state of the task specified by the URI.
PUT		/tasks/{task_id}	Update a task at the given URI with new information, providing the full representation.
DELETE	/tasks/{task_id}	Logically remove the task identified by the given URI.


How to Create an task
======================
Request
POST /tasks HTTP/1.1
Host: 127.0.0.1:9090
Connection: keep-alive
Content-Length: 143
Accept: application/json
Cache-Control: no-cache
Origin: chrome-extension://fdmmgilgnpjigdojojpjoooidkmcomcm
User-Agent: Mozilla/5.0 (Windows NT 6.0; WOW64) AppleWebKit/537.36 (KHTML, like
Gecko) Chrome/27.0.1453.110 Safari/537.36
Content-Type: application/json
Accept-Encoding: gzip,deflate,sdch
Accept-Language: en-US,en;q=0.8,es-419;q=0.6,es;q=0.4

{
    "description": "Fix database",
    "completed": "false",
    "created_at": "2012-06-14 12:43:43",
    "date_due": "2012-07-14 12:43:43"
}


Response
HTTP/1.1 201 Created
Status  201 Created
Access-Control-Allow-Origin *
Content-Type    application/json
Content-Length  125
Date Mon, 17 Jun 2013 19:34:02 GMT
Location http://127.0.0.1:9090/tasks/4

{
    "id": 4,
    "description": "Fix database",
    "completed": "False",
    "created_at": "2012-06-14 12:43:43",
    "date_due": "2012-07-14 12:43:43"
}

