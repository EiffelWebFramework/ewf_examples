note
	description: "Summary description for {COLLECTION_JSON_HELPER}."
	author: ""
	date: "$Date: 2013-06-18 15:31:35 -0300 (mar 18 de jun de 2013) $"
	revision: "$Revision: 59 $"

class
	COLLECTION_JSON_HELPER

inherit

	SHARED_EJSON
	HYPERMEDIA_REST_URI_TEMPLATES

feature -- Collection + JSON

	new_error (a_title: STRING; a_code: STRING; a_message: STRING): CJ_ERROR
		do
			create Result.make (a_title, a_code, a_message)
		end


	new_data (name: STRING_32; value: detachable STRING_32; prompt: STRING_32): CJ_DATA
		do
			create Result.make
			Result.set_name (name)
			if attached value as l_val then
				Result.set_value (l_val)
			else
				Result.set_value ("")
			end
			Result.set_prompt (prompt)
		end

	new_link (href: STRING_32; rel: STRING_32; prompt: detachable STRING_32; name: detachable STRING_32; render: detachable STRING_32): CJ_LINK
		do
			create Result.make (href, rel)
			if attached name as l_name then
				Result.set_name (l_name)
			end
			if attached render as l_render then
				Result.set_render (l_render)
			end
			if attached prompt as l_prompt then
				Result.set_prompt (l_prompt)
			end
		end

	new_query (href: STRING_32; rel: STRING_32; prompt: detachable STRING_32; name: detachable STRING_32; data: detachable CJ_DATA): CJ_QUERY
		do
			create Result.make (href, rel)
			if attached prompt as l_prompt then
				Result.set_prompt (l_prompt)
			end
			if attached name as l_name then
				Result.set_name (l_name)
			end
			if attached data as l_data then
				Result.add_data (l_data)
			end
		end

	json_to_cj (post: STRING): detachable CJ_COLLECTION
		local
			parser: JSON_PARSER
		do
			initialize_converters (json)
			create parser.make_parser (post)
			if attached parser.parse_object as cj and parser.is_parsed then
				if attached {CJ_COLLECTION} json.object (cj, "CJ_COLLECTION") as l_col then
					Result := l_col
				end
			end
		end

	json_to_cj_template (post: STRING): detachable CJ_TEMPLATE
		local
			parser: JSON_PARSER
		do
			initialize_converters (json)
			create parser.make_parser (post)
			if attached parser.parse_object as cj and parser.is_parsed then
				if attached {CJ_TEMPLATE} json.object (cj.item ("template"), "CJ_TEMPLATE") as l_col then
					Result := l_col
				end
			end
		end

	initialize_converters (j: like json)
			-- Initialize json converters

		do
			j.add_converter (create {CJ_COLLECTION_JSON_CONVERTER}.make)
			json.add_converter (create {CJ_DATA_JSON_CONVERTER}.make)
			j.add_converter (create {CJ_ERROR_JSON_CONVERTER}.make)
			j.add_converter (create {CJ_ITEM_JSON_CONVERTER}.make)
			j.add_converter (create {CJ_QUERY_JSON_CONVERTER}.make)
			j.add_converter (create {CJ_TEMPLATE_JSON_CONVERTER}.make)
			j.add_converter (create {CJ_LINK_JSON_CONVERTER}.make)
			if j.converter_for (create {ARRAYED_LIST [detachable ANY]}.make (0)) = Void then
				j.add_converter (create {CJ_ARRAYED_LIST_JSON_CONVERTER}.make)
			end
		end

feature -- Collection JSON Generic Builders

	collection_json_minimal_builder (req: WSF_REQUEST): CJ_COLLECTION
		do
			create Result.make_with_href_and_version (req.absolute_script_url (req.request_uri), "1.0")
		end

	collection_json_root_builder (req: WSF_REQUEST): CJ_COLLECTION
		do
			Result := collection_json_minimal_builder (req)
			-- add links
			Result.add_link (new_link ("mailto:javierv@eiffel.com", "author", "Author",Void,Void))
			Result.add_link (new_link (req.absolute_script_url ("/profile/tasks"), "profile", "Profile",Void,Void))

			-- add queries
			Result.add_query (new_query (req.absolute_script_url(query_all), "search", "All Tasks", Void, Void))
			Result.add_query (new_query (req.absolute_script_url(query_open), "search", "Open Tasks", Void, Void))
			Result.add_query (new_query (req.absolute_script_url(query_closed), "search", "Closed Tasks", Void, Void))

			-- template data
			Result.set_template (new_task_template (Void))
		end

feature -- CJ user template

	new_task_template (t: detachable TASK): CJ_TEMPLATE
		local
			d: CJ_DATA
		do
				-- Template
			create Result.make
			create D.make_with_name ("description");
			d.set_prompt ("Description")
			if t /= Void then
				d.set_value (t.description.as_string_32)
			end
			Result.add_data (d)
			create d.make_with_name ("dateDue");
			d.set_prompt ("Date Due (yyyy-mm-dd hh:mm:ss)")
			if t /= Void then
				d.set_value (t.date_due_string)
			end
			Result.add_data (d)

			create d.make_with_name ("completed");
			d.set_prompt ("Completed (true/false)?")
			if t /= Void then
				d.set_value (t.completed.out)
			end
			Result.add_data (d)
		end

feature -- Collection JSON Task builder


	build_task_item (req: WSF_REQUEST; a_task: TASK; cj: CJ_COLLECTION)
		local
			cj_item: CJ_ITEM

		do
			create cj_item.make (req.absolute_script_url (task_id_uri (a_task.id)))
			cj_item.add_data (new_data ("description", a_task.description.as_string_32, "Description"))
			cj_item.add_data (new_data ("completed", a_task.completed.out, "Completed"))
			cj_item.add_data (new_data ("dateDue", a_task.date_due_string, "Date Due"))
			cj.add_item (cj_item)
		end





end
