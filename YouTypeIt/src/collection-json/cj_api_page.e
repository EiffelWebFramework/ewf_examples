note
	description: "Summary description for {CJ_API_PAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CJ_API_PAGE

inherit

	TEMPLATE_PAGE

	SHARED_TEMPLATE_CONTEXT

create
	make, make_with_error

feature {NONE} --Initialization

	make (a_host: READABLE_STRING_GENERAL; a_messages: LIST [MESSAGES])
			-- Initialize `Current'.
		local
			p: PATH
			l_item: STRING
			l_template: STRING
			l_message: MESSAGES
		do
			create p.make_current
			p := p.appended ("/www")
			set_template_folder (p)
			set_template_file_name ("collection_json.tpl")
			template.add_value (a_host, "host")
			template.add_value (a_messages, "items")
			template_context.enable_verbose
			template.analyze
			template.get_output
			if attached template.output as l_output then
				l_output.replace_substring_all ("<", "{")
				l_output.replace_substring_all (">", "}")
				l_output.replace_substring_all (workaround, "}]")
				from
					a_messages.start
					create l_template.make_empty
				until
					a_messages.after
				loop
					create l_item.make_from_string (workaround)
					l_item.replace_substring_all ("$host", a_host.as_string_8)
					l_item.replace_substring_all ("$id", a_messages.item_for_iteration.id.out)
					l_item.replace_substring_all ("$message", a_messages.item_for_iteration.message)
					l_item.replace_substring_all ("$date", a_messages.item_for_iteration.date.out)
					l_template.append (l_item)
					a_messages.forth
					if not a_messages.after then
						l_template.append (",")
					end
				end
				l_output.replace_substring_all ("$template", l_template)
				representation := l_output
				print ("%N===========%N" + l_output)
			end
		end

	make_with_error (a_host: READABLE_STRING_GENERAL; a_error: READABLE_STRING_GENERAL; a_code: INTEGER)
			-- Initialize `Current'.
		local
			p: PATH
			l_item: STRING
			l_template: STRING
			l_message: MESSAGES
		do
			create p.make_current
			p := p.appended ("/www")
			set_template_folder (p)
			set_template_file_name ("collection_json_error.tpl")
			template.add_value (a_host, "host")
			template.add_value (a_error, "error")
			template.add_value (a_code, "code")
			template_context.enable_verbose
			template.analyze
			template.get_output
			if attached template.output as l_output then
				l_output.replace_substring_all ("<", "{")
				l_output.replace_substring_all (">", "}")
				representation := l_output
				print ("%N===========%N" + l_output)
			end
		end

	workaround: STRING = "[
			 		{
				        "href": "$host/api/$id", 
				        "data": [
				          {"name": "text", "value": $message }, 
				          {"name": "date_posted", "value": "$date" }
				        ]
				    }
		]"

end
