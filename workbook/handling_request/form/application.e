note
	description : "Basic Service that Generates Plain Text"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	WSF_DEFAULT_SERVICE
		redefine
			initialize
		end

create
	make_and_launch

feature {NONE} -- Initialization

	initialize
			-- Initialize current service.
		do
			set_service_option ("port", 9090)
		end

feature -- Basic operations

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the incomming request
		local
			file: WSF_FILE_RESPONSE
			l_parameter_names: STRING
			l_answer: STRING
		do
			if req.is_get_request_method then
				create file.make_html ("form.html")
				res.send (file)
			elseif req.is_post_request_method then
					-- Read the params
				create l_parameter_names.make_from_string ("<h2>Parameters Names</h2>")
				l_parameter_names.append ("<br>")
				create l_answer.make_from_string ("<h2>Parameter Names and Values</h2>")
				l_answer.append ("<br>")
				across req.form_parameters as ic loop
					 l_parameter_names.append (ic.item.key)
					 l_parameter_names.append ("<br>")

					 l_answer.append (ic.item.key)
					 l_answer.append_character ('=')
					 if attached {WSF_STRING} req.form_parameter (ic.item.key) as l_value then
					 	l_answer.append_string (l_value.value)
					 end
					 l_answer.append ("<br>")
				end
				l_parameter_names.append ("<br>")
				l_parameter_names.append_string (l_answer)
				res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", l_parameter_names.count.out]>>)
				res.put_string (l_parameter_names)
			else
				-- Here we should handle unexpected errors.
			end
		end

end
