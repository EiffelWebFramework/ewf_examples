note
	description: "Summary description for {APPLICATION_EXECUTION}."
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION_EXECUTION

inherit
	WSF_EXECUTION

create
	make

feature {NONE} -- Initialization

feature -- Basic operations

	execute
			-- Execute the incomming request
		local
			fr: WSF_FILE_RESPONSE
			e: EXECUTION_ENVIRONMENT
			p: PATH
		do
				-- Base Path
			if request.path_info.same_string ("/") then
				response.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", web_page.count.out]>>)
				response.put_string (web_page)
			else
					-- Basic example to show how to serve files from our default document root.
				create e
				p := e.current_working_path.appended (request.request_uri)
				create fr.make_with_content_type_and_path ({HTTP_CONSTANTS}.image_jpg, p)
				response.send (fr)
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

