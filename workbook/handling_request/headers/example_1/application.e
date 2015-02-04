note
	description : "Basic Service that Read Request Headers"
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
			set_service_option ("verbose", true)
		end

feature -- Basic operations

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the incomming request
		local
			file: WSF_FILE_RESPONSE
			l_header_names: STRING
			l_answer: STRING
			idioms: LIST[STRING]
			l_raw_data: STRING
		do
			if req.is_get_request_method then
				if  req.path_info.same_string ("/") then
					create file.make_html ("example_1.html")
					res.send (file)
				end
			elseif req.is_post_request_method then

				if req.path_info.same_string ("/") then
					create l_header_names.make_empty
						-- reading the raw header.
					if attached req.raw_header_data as l_raw_header then
						l_header_names.append ("<h2> Raw header </h2><br/>")
						l_header_names.append (l_raw_header)
					end
					res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", l_header_names.count.out]>>)
					res.put_string (l_header_names)
				end
			else
			end

		end

end
