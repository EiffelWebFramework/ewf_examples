note
	description : "Basic Service that Generate HTML using a Default Document Root"
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
			fr: WSF_FILE_RESPONSE
			e: EXECUTION_ENVIRONMENT
			p: PATH
		do
				-- Base Path
			if req.path_info.same_string ("/") then
				res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", web_page.count.out]>>)
				res.put_string (web_page)
			else
					-- Basic example to show how to serve files from our default document root.
				create e
				p := e.current_working_path.appended (req.request_uri)
				create fr.make_with_content_type_and_path ({HTTP_CONSTANTS}.image_jpg, p)
				res.send (fr)
			end
		end



	web_page: STRING = "[
	<!DOCTYPE html>
	<html>
		<head>
			<title>Example showing how to display images</title>
		</head>
		<body>
			<div id="header">
				<p id="name">Use a tool to see the request and header details, for example (Developers tools in Chrome or Firebugs in Firefox)</p>
			</div>
			<div class="left"></div>
			<div class="right">
				<h4>This page is an example </h4>
			
			<footer>
					<a href="https://github.com/EiffelWebFramework/EWF"><img src="./photo.jpg" width="200" height="200" alt="Powered by EWF" title="Powered by EWF"></a>
			</footer>	
		</body>
	</html>
]"


end
