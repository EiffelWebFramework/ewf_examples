note
	description : "Basic Service that build a generic front to demonstrate the use of Cookies"
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
			set_service_option ("verbose",True)
		end

feature -- Basic operations

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the incomming request
		local
			l_message: STRING
			l_header: HTTP_HEADER
			l_time: HTTP_DATE
			l_cookies: STRING
			l_answer: STRING
		do
				-- all the cookies
			create l_cookies.make_empty
			across req.cookies as ic loop
					l_cookies.append (ic.item.name)
					l_cookies.append("<br>")
			end

			if req.path_info.same_string ("/") then
				create l_header.make
				create l_answer.make_from_string (web_page)
				if l_cookies.is_empty then
						-- First access the the home page
					l_answer.replace_substring_all ("$header_title", "Hey, thanks for access our cool site, this is your first acess")
					l_answer.replace_substring_all ("$cookies", l_cookies)
					create l_time.make_now_utc
					l_time.date_time.day_add (40)
					l_header.put_cookie_with_expiration_date ("_EWF_Cookie", "EXAMPLE",l_time.date_time, "", Void, False, True)
				else
					   -- No a new access
					l_answer.replace_substring_all ("$header_title", "Welcome back, please check all the new things we have!!!")
					l_answer.replace_substring_all ("$cookies", l_cookies)
				end
				l_header.put_content_type_text_html
				l_header.put_content_length (l_answer.count)
				res.put_header_text (l_header.string)
				res.put_string (l_answer)

			elseif req.path_info.same_string ("/visitors")  then
				create l_header.make
				create l_answer.make_from_string (visit_page)
				if req.cookie ("_visits") = Void then
						-- First access the the home page
					l_answer.replace_substring_all ("$visit", "1")
					l_answer.replace_substring_all ("$cookies", l_cookies)
					create l_time.make_now_utc
					l_time.date_time.day_add (40)
					l_header.put_cookie_with_expiration_date ("_visits", "1",l_time.date_time, "/visitors", Void, False, True)

				else
					if attached {WSF_STRING} req.cookie ("_visits") as l_visit then
						create l_time.make_now_utc
						l_time.date_time.day_add (40)
						l_answer.replace_substring_all ("$visit", (l_visit.value.to_integer + 1).out )
						l_answer.replace_substring_all ("$cookies", l_cookies)
						l_header.put_cookie_with_expiration_date ("_visits", (l_visit.value.to_integer + 1).out,l_time.date_time, "/visitors", Void, False, True)
					end
				end
				l_header.put_content_type_text_html
				l_header.put_cookie ("_Framework", "EWF","360", "/", Void, False, True)
				l_header.put_content_length (l_answer.count)
				res.add_header_text (l_header.string)
				res.put_string (l_answer)
			end

		end



feature -- Home Page

	web_page: STRING = "[
	<!DOCTYPE html>
	<html>
		<head>
			<title>EWF Handling Cookies</title>
		</head>
		<body>
			<div class="right">
				<h2>$header_title</h2>	
			</div>
			
			<div class="right">
				<a href="/visitors">Visitors</a>
			</div>
			
			<div>
				<h3>Cookies for the home page</h3>
				$cookies 
			</div>
		</body>
	</html>
]"


visit_page: STRING = "[
	<!DOCTYPE html>
	<html>
		<head>
			<title>EWF Handling Visit Page</title>
		</head>
		<body>
			<div class="right">
				<h2>The number of visits is $visit</h2>
			</div>
			
			<div>
				<h3>Cookies for the Visit page</h3>
				$cookies 
			</div>
			</br>
			
			<div>
				Back to <a href="/"> Home </a> 
			</div>

			<div id="footer">
				<p>EWF Example Cookies</p>
			</div>
		</body>
	</html>
]"

end
