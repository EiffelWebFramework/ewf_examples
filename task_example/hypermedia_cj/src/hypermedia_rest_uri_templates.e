note
	description: "Summary description for {HYPERMEDIA_REST_URI_TEMPLATES}."
	author: ""
	date: "$Date: 2013-08-20 17:51:39 -0300 (mar, 20 ago 2013) $"
	revision: "$Revision: 205 $"

class
	HYPERMEDIA_REST_URI_TEMPLATES

feature -- Access: collection	

	root_uri: STRING = "/"

	api_uri: STRING = "/collection"

	task_uri : STRING = "/collection/tasks"

feature -- Access : query

	query_uri : STRING = "/query;"

	query_all : STRING = "/query;all"

	query_open : STRING = "/query;open"

	query_closed : STRING = "/query;closed"

feature -- Access: query

	query_uri_template: URI_TEMPLATE
		once
			create Result.make (query_uri + "{option}")
		end

	query_path (option : STRING): STRING_8
		local
			ht: HASH_TABLE [detachable ANY, STRING_8]
		do
			create ht.make (1)
			ht.force (option, "option")
			Result := query_uri_template.expanded_string (ht)
		end

feature -- Access: tasks	

	task_id_uri_template: URI_TEMPLATE
		once
			create Result.make (task_uri + "/{task_id}")
		end

	task_id_uri (a_id: like {TASK}.id): STRING_8
		local
			ht: HASH_TABLE [detachable ANY, STRING_8]
		do
			create ht.make (1)
			ht.force (a_id, "task_id")
			Result := task_id_uri_template.expanded_string (ht)
		end

end
