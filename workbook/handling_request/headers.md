Nav: [Workbook](../workbook.md) | [Handling Requests: Form/Query parameters] (/workbook/handling_request/form.md)

#Handling Requests: Headers

##### Introduction
- The [HTTP request header fields (also known as "headers")](https://httpwg.github.io/specs/rfc7231.html#request.header.fields) are set by the browser and sent in the header of the http request text (see http protocol), as opposed to form or query parameters [Form Data]().
- Query parameters are encoded in the URL [GET requests](https://httpwg.github.io/specs/rfc7230.html#http.message).
- Form parameters are encoded in the request message  for [POST/PUT requests.](https://httpwg.github.io/specs/rfc7230.html#http.message).

A request usually include the header [Accept, Accept-Encoding, Connection, Cookie, Host, Referer, and User-Agent](https://httpwg.github.io/specs/rfc7231.html#request.header) fields, defining important information about how the server should process the request. But then, the server needs to read the request header fields to use this information.

##### Table of Contents  
- [Reading HTTP Header fields](#read_header).
- [Reading HTTP Request line](#read_line).
- [Understanding HTTP header fields](#understand).
	- [Accept](#accept)
	- [Accept-Charset](#accept_charset)
	- [Accept-Encoding](#accept_encoding)
	- [Accept-Language](#accept_language)
- [Example](#example).


That section explains how to read HTTP information sent by the browser via the request header fields. Mostly by defining the most important HTTP request header fields, for more information, read [HTTP 1.1 specification](https://httpwg.github.io/specs/).

## Prerequisite
The Eiffel Web Framework is using the traditional Common Gateway Interface (CGI) programming interface to access the header fields, query and form parameters.
Among other, this means the header field are exposed with associated CGI field names:
- the header field name are uppercased, and any dash "-" replaced by underscore "_".
- and also prefixed by "HTTP_" except for CONTENT_TYPE and CONTENT_LENGTH. 
- For instance `X-Server` will be known as `HTTP_X_SERVER`.

<a name="read_header"/>
## Reading HTTP Header fields
EWF [WSF_REQUEST]() class provides features to access HTTP headers.

Reading most headers is straightforward by calling:
- the corresponding `http_*` functions such as `http_accept` for header "Accept".
- or indirectly using the `meta_string_variable (a_name)` function by passing the associated CGI field name.
In both case, if the related header field is supplied by the request, the result is the string value, otherwise it is Void. 

Note: always check if the result of those functions is non-void before using it.

* Cookies:
	- To iterate on all cookies value, use `cookies: ITERABLE [WSF_VALUE]`
	- To retrieve an specific cookie value,  use `cookie (a_name: READABLE_STRING_GENERAL): detachable WSF_VALUE`

* Authorization
	- To read the Authorization header, first check its type with: `auth_type: detachable READABLE_STRING_8`
	- And its value via `http_authorization: detachable READABLE_STRING_8 --Contents of the Authorization: header from the current wgi_request, if there is one.`

* Content_length
	- If supplied, get the content length as an string value: `content_length: detachable READABLE_STRING_8`
	- or directly as a natural value with `content_length_value: NATURAL_64` 

* Content_type
	- If supplied, get the content type as an string value with `content_type: detachable HTTP_CONTENT_TYPE`

Due to CGI compliance, the original header names are not available, however the function `raw_header_data` returns it the http header data as a string value (warning: this may not be available, depending on the underlying connector). Apart from very specific cases (proxy, debugging, ...), it should not be useful.
Note: CGI variables are information about the current request. Some are based on the HTTP request line and headers (e.g., form parameters, query parameters), others are derived
from the socket itself (e.g., the name and IP address of the requesting host), and still others are taken from server installation parameters (e.g., the mapping of URLs to
actual paths). 

<a name="read_line"/>
####Retrieve information from the Request Line

For convenience, the following sections refer to a request starting with line:
```
GET http://eiffel.org/search?q=EiffelBase  HTTP/1.1
```

Overview of the features

* HTTP method 
	- The function `request_method: READABLE_STRING_8` gives access to the HTTP request method, (usually GET or POST in conventional Web Applications), but with the raise of REST APIs other methods are also frequently used such as HEAD, PUT, DELETE, OPTIONS, or TRACE. 
	A few functions helps determining quickly the nature of the request method:
	- `is_get_request_method: BOOLEAN -- Is Current a GET request method?`
	- `is_put_request_method: BOOLEAN -- Is Current a PUT request method?`
	- `is_post_request_method: BOOLEAN -- Is Current a POST request method?`
	- `is_delete_request_method: BOOLEAN -- Is Current a DELETE request method?`

	In our example the request method is `GET`
	
 * Query String
 	- The query string for the example is `q=EiffelBase`
 	- `query_string: READABLE_STRING_8`

 * Protocol 
 	- The feature return the third part of the request line, which is generally HTTP/1.0 or HTTP/1.1.
	- `server_protocol: READABLE_STRING_8`
    In the example the request method is `HTTP/1.1`


<a name="understand"/>
#### Understanding HTTP 1.1 Request Headers
Access to the request headers permits the web server applications or APIs to perform optimizations and provide behavior that would not be possible without them for instance such as adapting the response according to the browser preferences.
This section summarizes the headers most often used; for more information, see the [HTTP 1.1 specification](https://httpwg.github.io/specs/), note that [RFC 2616 is dead](https://www.mnot.net/blog/2014/06/07/rfc2616_is_dead).

<a name="accept"/>
 * [Accept](https://httpwg.github.io/specs/rfc7231.html#header.accept)
 	- The "Accept" header field can be used by user agents (browser or other clients) to specify response media types that are acceptable. Accept header fields can be used to indicate that the request is specifically limited to a small set of desired types, as in the case of a request for an in-line image.
 	For example, assume an APIs Learn4Kids can respond with XML or JSON data (JSON format have some advantages over XML, readability, parsing etc...), a client can precise its preference using "Accept: application/json" to request data in JSON format, or "Accept: application/xml" to get XML format. In other case the server send a not acceptable response. Note that the client can precise an ordered list of accepted content types, including "*", it will get the response and know the content type via the response header field "Content-Type". Related [Content-Negotiation]()

<a name="accept_charset"/>
 * [Accept-Charset](https://httpwg.github.io/specs/rfc7231.html#header.accept-charset)
	- The "Accept-Charset" header field can be sent by a user agent (browser or other clients) to indicate what charsets are acceptable in textual response content(e.g., ISO-8859-1).

<a name="accept_encoding"/>
 * [Accept-Encoding](https://httpwg.github.io/specs/rfc7231.html#header.accept-encoding)
	- The "Accept-Encoding" header field can be used by user agents (browser or other clients) to indicate what response content-codings (`gzip`, `compress`) are acceptable in the response. An "identity" token is used as a synonym for "no encoding" in order to communicate when no encoding is preferred. If the server receives this header, it is free to encode the page by using one of the content-encodings specified (usually to reduce transmission time), sending the `Content-Encoding` response header to indicate that it has done so.

<a name="accept_language"/>
 * [Accept-Language](https://httpwg.github.io/specs/rfc7231.html#header.accept-language)
 	- The "Accept-Language" header field can be used by user agents (browser or other client) to indicate the set of natural languages that are preferred in the response in case  the server can produce representation in more than one language.The value of the header should be one of the standard language codes such as en, en-us, da, etc. See RFC 1766 for details (start at http://www.rfc-editor.org/ to get a current list of the RFC archive sites).


<a name="example"/>

#### Building a Table of All Request Headers

The following [EWF service]() code simply uses an ```html_template``` to fill a table (names and values) with all the headers fields it receives.
The service accomplishes this task by calling ```req.meta_variables``` feature to get an ```ITERABLE[WSF_STRING]```, an structure that can be iterated over using ```across...loop...end```, then it checkS if the name has the prefix ```HTTP_``` and if its true, put the header name and value in a row. (the name in the left cell, the value in the right cell).

The service also write three components of the main request line (method, URI, and protocol), and also the raw header. 


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
			set_service_option ("verbose", true)
		end

feature -- Basic operations

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the incomming request
		local
			l_raw_data: STRING
			l_page_response: STRING
			l_rows: STRING
		do
			create l_page_response.make_from_string (html_template)
			if  req.path_info.same_string ("/") then

					-- HTTP method
				l_page_response.replace_substring_all ("$http_method", req.request_method)
					-- URI
				l_page_response.replace_substring_all ("$uri", req.path_info)
					-- Protocol
				l_page_response.replace_substring_all ("$protocol", req.server_protocol)

					-- Fill the table rows with HTTP Headers
				create l_rows.make_empty
				across req.meta_variables as ic loop
					if ic.item.name.starts_with ("HTTP_") then
						l_rows.append ("<tr>")
						l_rows.append ("<td>")
						l_rows.append (ic.item.name)
						l_rows.append ("</td>")
						l_rows.append ("<td>")
						l_rows.append (ic.item.value)
						l_rows.append ("</td>")
						l_rows.append ("</tr>")
					end
				end

				l_page_response.replace_substring_all ("$rows", l_rows)

					-- Reading the raw header
				if attached req.raw_header_data as l_raw_header then
					l_page_response.replace_substring_all ("$raw_header", l_raw_header)
				end
				res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", l_page_response.count.out]>>)
				res.put_string (l_page_response)
			end
		end

	html_template: STRING = "[
				<!DOCTYPE html>
				<html>
				<head>
					<style>
						thead {color:green;}
						tbody {color:blue;}
						table, th, td {
						    border: 1px solid black;
						}
					</style>
				</head>
				
				<body>
				    <h1>EWF service example: Showing Request Headers</h1>
				   
				    <strong>HTTP METHOD:</strong>$http_method<br>
				    <strong>URI:</strong>$uri<br>
				    <strong>PROTOCOL:</strong>$protocol<br>
				    <strong>REQUEST TIME:</strong>$time<br>
				     
				    <br> 
					<table>
					   <thead>
					   <tr>
					        <th>Header Name</th>
						    <th>Header Value</th>
					   </tr>
					   </thead>
					   <tbody>
					   $rows
					   </tbody>
					</table>
					
					
					<h2>Raw header</h2>
					
					$raw_header
				</body>
				</html>
			]"
end

```


Nav: [Workbook](../workbook.md) | [Handling Requests: Form/Query parameters] (/workbook/handling_request/form.md)


