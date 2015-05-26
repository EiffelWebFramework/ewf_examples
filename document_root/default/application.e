note
	description : "[
		Basic Service that generates HTML using a Default Document Root
		]"
	synopsis: "[
		The {WSF_DEFAULT_SERVICE} is used and initialized without the need of an "ewi.ini"
		configuration file. Instead, the service has its options set by a direct call(s) on
		`set_service_option'—here, setting the listening "port" to 9090. There are other
		`service_options' "settings" one can make. See _______ for more information on those
		settings, valid options, and valid values.
		
		The way {WSF_DEFAULT_SERVICE} is being used, means we will be using the Nino HTTPD
		Web Server to catch client browser requests and to send responses back. Therefore,
		the compiled (Finalized) EXE will have its "root" directory or folder located at
		whatever directory it is executed in or where a Windows shortcut links is pointed
		at using the "Start-in" setting.
		]"
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
		note
			synopsis: "[
				The call to `set_service_option' (below) is in place of using an `ewf.ini'
				(or other *.ini) file.
				]"
		do
			set_service_option ("port", 9090)
		end

feature -- Basic operations

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the incoming request.
		note
			synopsis: "[
				If one examines the `web_page' feature first, one will note that the web page contains an image.
				The cycle-of-action here is:
				
				(1) The client browser makes a request for the `web_page'.
				(2) Our Eiffel web server responds by sending the page.
				(3) The client browser parses the response and notices the resource—that is—the JPG file.
					The browser makes a subsequent request for the resource.
				(4) Our Eiffel web service see this request (i.e. the "else" condition) and responds by
					sending the JPG file back to the client in a final response, so the client can
					render our image file into the `web_page'.
				
				First—We look to the incoming request to determine what router path the request is targeted at. If
				the request is about the base or root path of the service location (e.g. "/"), then we construct
				a response (e.g. {WSF_FILE_RESPONSE} baed on it.
				
				Elsewise, we use an {EXECUTION_ENVIRONMENT} to construct a path (`p') from the `current_working_path'
				and whatever subordinate pathing is held in the incoming `req' (request). From here, we create the
				`fr' file response, giving it the type of the file (e.g. JPG) and the path, where the file is located.
				This response is then sent through the `res' response object.
				]"
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
