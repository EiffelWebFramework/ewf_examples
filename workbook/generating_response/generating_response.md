
Nav: [Workbook](../workbook.md) | [Handling Requests: Form/Query Parameter](/workbook/handling_request/form.md)


## EWF Generating Response

##### Table of Contents  
- [Format of the HTTP response](#format)  
- [How to set status code](#status_set)  
- [How to redirect to a particular location.](#redirect)  
- [HTTP Status codes](#status)
- [Example Staus Codes](#example_1)
- [Generic Search Engine](#example_2)
- [Response Header Fields](#header_fields)


<a name="format"/>
## Format of the HTTP response

As we saw in the previous documents, a request from a user-agent (browser or other client) consists of an HTTP command (usually GET or POST), zero or more request headers (one or
more in HTTP 1.1, since Host is required), a blank line, and only in the case of POST/PUT requests, payload data. A typical request looks like the following.

```
	GET /url[query_string] HTTP/1.1
	Host: ...
	Header2: ...
	...
	HeaderN:
	(Blank Line)
```

When a Web server responds to a request, the response typically consists of a status line, some response headers, a blank line, and the document. A typical response
looks like this:

```
	HTTP/1.1 200 OK
	Content-Type: text/html
	Header2: ...
	...
	HeaderN: ...
	(Blank Line)
	<!DOCTYPE ...>
	<HTML>
		<HEAD>...</HEAD>
		<BODY>
		...
		</BODY>
	</HTML>
```

The status line consists of the HTTP version (HTTP/1.1 in the preceding example), a status code (an integer 200 in the example), and a very short message corresponding to the status code (OK in the example). In most cases, the headers are optional except for Content-Type, which specifies the MIME type of the document that follows. Although most responses contain a document, some don’t. For example, responses to HEAD requests should never include a document, and various status codes essentially indicate failure or redirection (and thus either don’t include a document or include only a short error-message document).

<a name="status_set"/>
## How to set the status code

If you need to set an arbitrary status code, you can use the ```WSF_RESPONSE.put_header``` feature  or the ```WSF_RESPONSE.set_status_code``` feature. An status code of 200 is a default value.  See below examples using the mentioned features.

### Using the WSF_RESPONSE.put_header feature.
In this case you provide the status code with a collection of headers. 

```eiffel
	put_header (a_status_code: INTEGER_32; a_headers: detachable ARRAY [TUPLE [name: READABLE_STRING_8; value: READABLE_STRING_8]])
			-- Put headers with status `a_status', and headers from `a_headers'
		require
			a_status_code_valid: a_status_code > 0
			status_not_committed: not status_committed
			header_not_committed: not header_committed
		ensure
			status_code_set: status_code = a_status_code
			status_set: status_is_set
			message_writable: message_writable

Example			
	res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", output_size]>>) 
	res.put_string (web_page)
```

### Using the WSF_RESPONSE.set_status code

```eiffel
	custom_response (req: WSF_REQUEST; res: WSF_RESPONSE; output: STRING)
		local
			h: HTTP_HEADER
			l_msg: STRING
		do
			create h.make
			create l_msg.make_from_string (output)
			h.put_content_type_text_html
			h.put_content_length (l_msg.count)
			h.put_current_date
			res.set_status_code ({HTTP_STATUS_CODE}.ok)
			res.put_header_text (h.string)
			res.put_string (l_msg)
		end
```
Both features takes an INTEGER (the status code) as an formal argument, you can use 200, 300, 500 etc directly, but instead of using explicit numbers, it's recommended to use the constants defined in the class [HTTP_STATUS_CODE](). The name of each constant is based from the standard [HTTP 1.1]().

<a name="redirect"/>
## How to redirect to a particular location.
To redirect the response to a new location, we need to send a 302 status code, to do that we use ```{HTTP_STATUS_CODE}.found```

> The 302 (Found) status code indicates that the target resource resides temporarily under a different URI. Since the redirection might be altered on occasion, the client ought to continue to use the effective request URI for future requests.

Another way to do redirection is with 303 status code

> The 303 (See Other) status code indicates that the server is redirecting the user agent to a different resource, as indicated by a URI in the Location header field, which is intended to provide an indirect response to the original request. 

The next code show a custom feature to write a redirection, you can use found or see_other based on your particular requirements.

```eiffel
	send_redirect (req: WSF_REQUEST; res: WSF_RESPONSE; a_location: READABLE_STRING_32)
			-- Redirect to `a_location'
		local
			h: HTTP_HEADER
		do
			create h.make
			h.put_content_type_text_html
			h.put_current_date
			h.put_location (a_location)
			res.set_status_code ({HTTP_STATUS_CODE}.found)
			res.put_header_text (h.string)
		end
```

The class [WSF_RESPONSE]() provide features to work with redirection 

```eiffel
	redirect_now (a_url: READABLE_STRING_8)
			-- Redirect to the given url `a_url'
		require
			header_not_committed: not header_committed

	redirect_now_custom (a_url: READABLE_STRING_8; a_status_code: INTEGER_32; a_header: detachable HTTP_HEADER; a_content: detachable TUPLE [body: READABLE_STRING_8; type: READABLE_STRING_8])
			-- Redirect to the given url `a_url' and precise custom `a_status_code', custom header and content
			-- Please see http://www.faqs.org/rfcs/rfc2616 to use proper status code.
			-- if `a_status_code' is 0, use the default {HTTP_STATUS_CODE}.temp_redirect
		require
			header_not_committed: not header_committed

	redirect_now_with_content (a_url: READABLE_STRING_8; a_content: READABLE_STRING_8; a_content_type: READABLE_STRING_8)
			-- Redirect to the given url `a_url'
```

The ```WSF_RESPONSE.redirect_now``` feature use the status code ```{HTTP_STATUS_CODE}.found```,the other redirect features enable customize the status code and content based on your requirements.


Using a similar approach we can build features to answer a bad request (400), internal server error (500), etc. We will build a simple example showing the most common HTTP status codes.

<a name="status"/>
## [HTTP 1.1 Status Codes](https://httpwg.github.io/specs/rfc7231.html#status.codes)
The status-code element is a three-digit integer code giving the result of the attempt to understand and satisfy the request. The first digit of the status-code defines the class of response. 

General categories:
* [1xx](https://httpwg.github.io/specs/rfc7231.html#status.1xx) Informational: The 1xx series of response codes are used only in negotiations with the HTTP server.
* [2xx](https://httpwg.github.io/specs/rfc7231.html#status.2xx) Sucessful: The 2xx error codes indicate that an operation was successful.
* [3xx](https://httpwg.github.io/specs/rfc7231.html#status.3xx) Redirection: The 3xx status codes indicate that the client needs to do some extra work to get what it wants.
* [4xx](https://httpwg.github.io/specs/rfc7231.html#status.4xx) Client Error: These status codes indicate that something is wrong on the client side. 
* [5xx](https://httpwg.github.io/specs/rfc7231.html#status.5xx) Server Error: These status codes indicate that something is wrong on the server side. 

Note: use ```res.set_status_code({HTTP_STATUS_CODE}.bad_request)``` rather than ```res.set_status_code(400)```.


<a name="example_1"/>
Basic Service that builds a
 simple web page to show the most common status codes
```eiffel
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
			l_message: STRING
		do
				-- To send a response we need to setup, the status code and
				-- the response headers.
			if req.is_get_request_method then
				if req.path_info.same_string ("/") then
					res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", web_page.count.out]>>)
					res.put_string (web_page)
				elseif req.path_info.same_string ("/redirect") then
					send_redirect (req, res, "https://httpwg.github.io/")
					-- res.redirect_now (l_engine_url)
				elseif req.path_info.same_string ("/bad_request") then
					 	-- Here you can do some logic for example log, send emails to register the error, before to send the response.
					create l_message.make_from_string (message_template)
					l_message.replace_substring_all ("$title", "Bad Request")
					l_message.replace_substring_all ("$status", "Bad Request 400")
					res.put_header ({HTTP_STATUS_CODE}.bad_request, <<["Content-Type", "text/html"], ["Content-Length", l_message.count.out]>>)
					res.put_string (l_message)
				elseif req.path_info.same_string ("/internal_error") then
						 	-- Here you can do some logic for example log, send emails to register the error, before to send the response.
			   		create l_message.make_from_string (message_template)
					l_message.replace_substring_all ("$title", "Internal Server Error")
					l_message.replace_substring_all ("$status", "Internal Server Error 500")
					res.put_header ({HTTP_STATUS_CODE}.internal_server_error, <<["Content-Type", "text/html"], ["Content-Length", l_message.count.out]>>)
					res.put_string (l_message)
			   	else
			   		create l_message.make_from_string (message_template)
					l_message.replace_substring_all ("$title", "Resource not found")
					l_message.replace_substring_all ("$status", "Resource not found 400")
					res.put_header ({HTTP_STATUS_CODE}.not_found, <<["Content-Type", "text/html"], ["Content-Length", l_message.count.out]>>)
					res.put_string (l_message)
			   	end
			else
				create l_message.make_from_string (message_template)
				l_message.replace_substring_all ("$title", "Method Not Allowed")
				l_message.replace_substring_all ("$status", "Method Not Allowed 405")
					-- Method not allowed
				res.put_header ({HTTP_STATUS_CODE}.method_not_allowed, <<["Content-Type", "text/html"], ["Content-Length", l_message.count.out]>>)
				res.put_string (l_message)
			end
		end


feature -- Home Page

	send_redirect (req: WSF_REQUEST; res: WSF_RESPONSE; a_location: READABLE_STRING_32)
			-- Redirect to `a_location'
		local
			h: HTTP_HEADER
		do
			create h.make
			h.put_content_type_text_html
			h.put_current_date
			h.put_location (a_location)
			res.set_status_code ({HTTP_STATUS_CODE}.see_other)
			res.put_header_text (h.string)
		end

	web_page: STRING = "[
	<!DOCTYPE html>
	<html>
		<head>
			<title>Example showing common status codes</title>
		</head>
		<body>
			<div id="header">
				<p id="name">Use a tool to see the request and header details, for example (Developers tools in Chrome or Firebugs in Firefox)</p>
			</div>
			<div class="left"></div>
			<div class="right">
				<h4>This page is an example of Status Code 200</h4>

				<h4> Redirect Example </h4>
				<p> Click on the following link will redirect you to the HTTP Specifcation, we can do the redirect from the HTML directly but
				here we want to show you an exmaple, where you can do something before to send a redirect <a href="/redirect">Redirect</a></p>

				<h4> Bad Request </h4>
				<p> Click on the following link, the server will answer with a 400 error, check the status code <a href="/bad_request">Bad Request</a></p>

				<h4> Internal Server Error </h4>
				<p> Click on the following link, the server will answer with a 500 error, check the status code <a href="/internal_error">Internal Error</a></p>
				
				<h4> Resource not found </h4>
				<p> Click on the following link or add to the end of the url something like /1030303 the server will answer with a 404 error, check the status code <a href="/not_foundd">Not found</a></p>

			</div>
			<div id="footer">
				<p>Useful links for status codes <a href="httpstat.us">httpstat.us</a> and <a href="httpbing.org">httpbin.org</a></p>
			</div>
		</body>
	</html>
]"

feature -- Generic Message

	message_template: STRING="[
	<!DOCTYPE html>
	<html>
		<head>
			<title>$title</title>
		</head>
		<body>
			<div id="header">
				<p id="name">Use a tool to see the request and header details, for example (Developers tools in Chrome or Firebugs in Firefox)</p>
			</div>
			<div class="left"></div>
			<div class="right">
				<h4>This page is an example of $status</h4>
			
			<div id="footer">
				<p><a href="/">Back Home</a></p>
			</div>
		</body>
	</html>
]"
end

```



<a name="example_2"/>
The following example shows a basic EWF service that builds a generic front end for the most used search engines. This example shows how
redirection works, and we will use a tools to play with the API to show differents responses.

```eiffel
note
	description : "Basic Service that build a generic front end for the most used search engines."
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
			l_message: STRING
		do
				-- To send a response we need to setup, the status code and
				-- the response headers.
			if req.is_get_request_method then
				if req.path_info.same_string ("/") then
					res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", web_page.count.out]>>)
					res.put_string (web_page)
				else
			   		send_resouce_not_found (req, res)
			   	end
			elseif req.is_post_request_method then
				if req.path_info.same_string ("/search") then
					if attached {WSF_STRING} req.form_parameter ("query") as l_query then
						if	attached {WSF_STRING} req.form_parameter ("engine") as l_engine then
						    if attached {STRING} map.at (l_engine.value) as l_engine_url then
						    	l_engine_url.append (l_query.value)
						   		send_redirect (req, res, l_engine_url)
						   	else
						   	  	send_bad_request (req, res, " <strong>search engine: " + l_engine.value + "</strong> not supported,<br> try with Google or Bing")
						   	end
						else
							send_bad_request (req, res, " <strong>search engine</strong> not selected")
						end
					else
						send_bad_request (req, res, " form_parameter <strong>query</strong> is not present")
				   	end
				else
					send_resouce_not_found (req, res)
				end
			else
				create l_message.make_from_string (message_template)
				l_message.replace_substring_all ("$title", "Method Not Allowed")
				l_message.replace_substring_all ("$status", "Method Not Allowed 405")
					-- Method not allowed
				res.put_header ({HTTP_STATUS_CODE}.method_not_allowed, <<["Content-Type", "text/html"], ["Content-Length", l_message.count.out]>>)
				res.put_string (l_message)
			end
		end


feature -- Engine Map

	map : STRING_TABLE[STRING]
		do
			create Result.make (2)
			Result.put ("http://www.google.com/search?q=", "Google")
			Result.put ("http://www.bing.com/search?q=", "Bing")
		end

feature -- Redirect

	send_redirect (req: WSF_REQUEST; res: WSF_RESPONSE; a_location: READABLE_STRING_32)
			-- Redirect to `a_location'
		local
			h: HTTP_HEADER
		do
			create h.make
			h.put_content_type_text_html
			h.put_current_date
			h.put_location (a_location)
			res.set_status_code ({HTTP_STATUS_CODE}.see_other)
			res.put_header_text (h.string)
		end

feature -- Bad Request

	send_bad_request (req: WSF_REQUEST; res: WSF_RESPONSE; description: STRING)
		local
			l_message: STRING
		do
			create l_message.make_from_string (message_template)
			l_message.replace_substring_all ("$title", "Bad Request")
			l_message.replace_substring_all ("$status", "Bad Request" + description)
			res.put_header ({HTTP_STATUS_CODE}.bad_request, <<["Content-Type", "text/html"], ["Content-Length", l_message.count.out]>>)
			res.put_string (l_message)
		end

feature -- Resource not found

	send_resouce_not_found (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			l_message: STRING
		do
			create l_message.make_from_string (message_template)
			l_message.replace_substring_all ("$title", "Resource not found")
			l_message.replace_substring_all ("$status", "Resource" + req.request_uri + "not found 404")
			res.put_header ({HTTP_STATUS_CODE}.not_found, <<["Content-Type", "text/html"], ["Content-Length", l_message.count.out]>>)
			res.put_string (l_message)
		end

feature -- Home Page

	web_page: STRING = "[
	<!DOCTYPE html>
	<html>
		<head>
			<title>Generic Search Engine</title>
		</head>
		<body>
			<div class="right">
				<h2>Generic Search Engine</h2>	
				<form method="POST" action="/search" target="_blank">
				   <fieldset>	
				 	 Search: <input type="search" name="query" placeholder="EWF framework"><br>
				   	<div>
					   	<input type="radio" name="engine" value="Google" checked><img src="http://ebizmba.ebizmbainc.netdna-cdn.com/images/logos/google.gif" height="24" width="42"> 
                    </div>
				
				   	<div>
				   			<input type="radio" name="engine" value="Bing"><img src="http://ebizmba.ebizmbainc.netdna-cdn.com/images/logos/bing.gif" height="24" width="42">
				   	</div><br>		
				   </fieldset>
				   <input type="submit">
				</form>


			</div>
			<div id="footer">
				<p><a href="http://www.ebizmba.com/articles/search-engines">Top 15 Most Popular Search Engines | March 2015</a></p>
			</div>
		</body>
	</html>
]"

feature -- Generic Message

	message_template: STRING="[
	<!DOCTYPE html>
	<html>
		<head>
			<title>$title</title>
		</head>
		<body>
			<div id="header">
				<p id="name">Use a tool to see the request and header details, for example (Developers tools in Chrome or Firebugs in Firefox)</p>
			</div>
			<div class="left"></div>
			<div class="right">
				<h4>This page is an example of $status</h4>
			
			<div id="footer">
				<p><a href="/">Back Home</a></p>
			</div>
		</body>
	</html>
]"

end

```

Using cURL to test the application

In the first call we use the ```res.redirect_now (l_engine_url)``` feature
```
#>curl -i -H -v -X POST -d "query=Eiffel&engine=Google" http://localhost:9090/search
HTTP/1.1 302 Found
Location: http://www.google.com/search?q=Eiffel
Content-Length: 0
Connection: close
```

Here we use our custom send_redirect feature call.

```
#>curl -i -H -v -X POST -d "query=Eiffel&engine=Google" http://localhost:9090/search
HTTP/1.1 303 See Other
Content-Type: text/html
Date: Fri, 06 Mar 2015 14:37:33 GMT
Location: http://www.google.com/search?q=Eiffel
Connection: close
```

#### Engine Ask Not supported

```
#>curl -i -H -v -X POST -d "query=Eiffel&engine=Ask" http://localhost:9090/search
HTTP/1.1 400 Bad Request
Content-Type: text/html
Content-Length: 503
Connection: close

<!DOCTYPE html>
<html>
        <head>
                <title>Bad Request</title>
        </head>
        <body>
                <div id="header">
                        <p id="name">Use a tool to see the request and header details, for example (Developers tools in Chrome or Firebugs in Firefox)</p>
                </div>
                <div class="left"></div>
                <div class="right">
                        <h4>This page is an example of Bad Request <strong>search engine: Ask</strong> not supported,<br> try with Google or Bing</h4>

                <div id="footer">
                        <p><a href="/">Back Home</a></p>
                </div>
        </body>
</html>
```


#### Missing query form parameter

```
#>curl -i -H -v -X POST -d "engine=Google" http://localhost:9090/search
HTTP/1.1 400 Bad Request
Content-Type: text/html
Content-Length: 477
Connection: close

<!DOCTYPE html>
<html>
        <head>
                <title>Bad Request</title>
        </head>
        <body>
                <div id="header">
                        <p id="name">Use a tool to see the request and header details, for example (Developers tools in Chrome or Firebugs in Firefox)</p>
                </div>
                <div class="left"></div>
                <div class="right">
                        <h4>This page is an example of Bad Request form_parameter <strong>query</strong> is not present</h4>

                <div id="footer">
                        <p><a href="/">Back Home</a></p>
                </div>
        </body>
</html>
```

#### Resource searchs not found

```
#>curl -i -H -v -X POST -d "query=Eiffel&engine=Google" http://localhost:9090/searchs
HTTP/1.1 404 Not Found
Content-Type: text/html
Content-Length: 449
Connection: close

<!DOCTYPE html>
<html>
        <head>
                <title>Resource not found</title>
        </head>
        <body>
                <div id="header">
                        <p id="name">Use a tool to see the request and header details, for example (Developers tools in Chrome or Firebugs in Firefox)</p>
                </div>
                <div class="left"></div>
                <div class="right">
                        <h4>This page is an example of Resource /searchs not found 404</h4>

                <div id="footer">
                        <p><a href="/">Back Home</a></p>
                </div>
        </body>
</html>
```

<a name="header_fields"/>
## [Response Header Fields](https://httpwg.github.io/specs/rfc7231.html#response.header.fields)

The response header fields allow the server to pass additional information about the response beyond what is placed in the status-line. These header fields give information about the server, about further access to the target resource, or about related resources. We can specify cookies, page modification date (for caching), reload a page after a designated period of time, size of the document.



### How to set response headers.

