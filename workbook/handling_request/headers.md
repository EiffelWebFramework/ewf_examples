
#Handling Requests: Headers

[Back to Workbook] (../workbook.md) 		

[Handling Requests: Form/Query parameters] (/workbook/handling_request/form.md)


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
- For instance "X-Server" will be known as "HTTP_X_SERVER".

<a name="read_header"/>
## Reading HTTP Header fields
EWF [WSF_REQUEST]() class provides features to access HTTP headers.

Reading most headers is straightforward by calling:
- the corresponding ```http_*``` functions such as ```http_accept``` for header "Accept".
- or indirectly using the ```meta_string_variable (a_name)``` function by passing the associated CGI field name.
In both case, if the related header field is supplied by the request, the result is the string value, otherwise it is Void. 

Note: always check if the result of those functions is non-void before using it.

* Cookies:
	- To iterate on all cookies value, use 
```eiffel 
cookies: ITERABLE [WSF_VALUE]
```

	- To retrieve an specific cookie value,  use
```eiffel
cookie (a_name: READABLE_STRING_GENERAL): detachable WSF_VALUE
	-- Field for name `a_name'.
```

* Authorization
	- To read the Authorization header, first check its type with:
```eiffel
auth_type: detachable READABLE_STRING_8 
```
	- And its value via 
```eiffel
http_authorization: detachable READABLE_STRING_8
	-- Contents of the Authorization: header from the current wgi_request, if there is one.
```

* Content_length
	- If supplied, get the content length as an string value
```eiffel 
content_length: detachable READABLE_STRING_8
```
	- or directly as a natural value with 
```eiffel
content_length_value: NATURAL_64
``` 

* Content_type
	- If supplied, get the content type as an string value with
```eiffel
content_type: detachable HTTP_CONTENT_TYPE
```

Due to CGI compliance, the original header names are not available, however the function ```raw_header_data``` returns it the http header data as a string value (warning: this may not be available, depending on the underlying connector). Apart from very specific cases (proxy, debugging, ...), it should not be useful.

<a name="read_line"/>
####Retrieve information from the Request Line

For convenience, the following sections refer to a request starting with line:
```
GET http://eiffel.org/search?q=EiffelBase  HTTP/1.1
```

Overview of the features

* HTTP method 
	- The function ```request_method: READABLE_STRING_8 ``` gives access to the HTTP request method, (usually GET or POST in conventional Web Applications), but with the raise of REST APIs other methods are also frequently used such as HEAD, PUT, DELETE, OPTIONS, or TRACE. 
	A few functions helps determining quickly the nature of the request method:
	- 	```is_get_request_method: BOOLEAN
			-- Is Current a GET request method?```
	- 	```is_put_request_method: BOOLEAN
			-- Is Current a PUT request method?```
	-	```is_post_request_method: BOOLEAN
			-- Is Current a POST request method?```
	-	```is_delete_request_method: BOOLEAN
			-- Is Current a DELETE request method?```

	In our example the request method is ```GET```		
	
 * Query String
 	- The query string for the example is ```q=EiffelBase```
 	- ```query_string: READABLE_STRING_8```

 * Protocol 
 	- The feature return the third part of the request line, which is generally HTTP/1.0 or HTTP/1.1.
	- ```server_protocol: READABLE_STRING_8```
    In the example the request method is ```HTTP/1.1```


<a name="understand"/>
#### Understanding HTTP 1.1 Request Headers
Access to the request headers permits the web server applications or APIs to perform optimizations and provide behavior that would not be possible without them for instance such as adapting the response according to the browser preferences.
This section summarizes the headers most often used; for more information, see the [HTTP 1.1 specification](https://httpwg.github.io/specs/), note that [RFC 2616 is dead](https://www.mnot.net/blog/2014/06/07/rfc2616_is_dead).

The "Accept" header field can be used by user agents to specify response media types that are acceptable. Accept header fields can be used to indicate that the request is specifically limited to a small set of desired types, as in the case of a request for an in-line image.

<a name="accept"/>
 * [Accept](https://httpwg.github.io/specs/rfc7231.html#header.accept)
 	- The "Accept" header field can be used by user agents (browser or other clients) to specify response media types that are acceptable. Accept header fields can be used to indicate that the request is specifically limited to a small set of desired types, as in the case of a request for an in-line image.
 	For example, assume an APIs Learn4Kids can respond with XML or JSON data (JSON format have some advantages over XML, readability, parsing etc...), a client can precise its preference using "Accept: application/json" to request data in JSON format, or "Accept: application/xml" to get XML format. In other case the server send a not acceptable response. Note that the client can precise an ordered list of accepted content types, including "*", it will get the response and know the content type via the response header field "Content-Type". Related [Content-Negotiation]()

<a name="accept_charset"/>
 * [Accept-Charset](https://httpwg.github.io/specs/rfc7231.html#header.accept-charset)
	- The "Accept-Charset" header field can be sent by a user agent (browser or other clients) to indicate what charsets are acceptable in textual response content(e.g., ISO-8859-1).

<a name="accept_encoding"/>
 * [Accept-Encoding](https://httpwg.github.io/specs/rfc7231.html#header.accept-encoding)
	- The "Accept-Encoding" header field can be used by user agents (browser or other clients) to indicate what response content-codings (```gzip```, ```compress```) are acceptable in the response. An "identity" token is used as a synonym for "no encoding" in order to communicate when no encoding is preferred. If the server receives this header, it is free to encode the page by using one of the content-encodings specified (usually to reduce transmission time), sending the ```Content-Encoding``` response header to indicate that it has done so.

<a name="accept_language"/>
 * [Accept-Language](https://httpwg.github.io/specs/rfc7231.html#header.accept-language)
 	- The "Accept-Language" header field can be used by user agents (browser or other client) to indicate the set of natural languages that are preferred in the response in case  the server can produce representation in more than one language.The value of the header should be one of the standard language codes such as en, en-us, da, etc. See RFC 1766 for details (start at http://www.rfc-editor.org/ to get a current list of the RFC archive sites).


<a name="example"/>
#### Building a Table of All Request Headers




[Back to Workbook](../workbook.md) 		

[Handling Requests: Form/Query parameters](/workbook/handling_request/form.md)



