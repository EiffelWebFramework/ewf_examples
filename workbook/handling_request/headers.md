
#Handling Requests: Headers

[Back to Workbook] (../workbook.md) 		

[Handling Requests: Form/Query parameters] (/workbook/handling_request/form.md)


##### Introduction
HTTP request headers are distinct from the form (query) data [Form Data](./form.md).
Form data results directly from user input and is sent as part of the URL for [GET requests and on a separate line for POST/PUT requests.](https://httpwg.github.io/specs/rfc7230.html#http.message).[Request headers](https://httpwg.github.io/specs/rfc7231.html#request.header.fields), on the other hand, are indirectly set by the browser and are sent immediately following the initial GET or POST request line. 

A generic request includes the headers [Accept, Accept-Encoding, Connection, Cookie, Host, Referer, and User-Agent](https://httpwg.github.io/specs/rfc7231.html#request.header)   fields, all of which might be important to the operation of the server, but to use then the server need to explicitly read the request headers to make use of this information.

##### Table of Contents  
- [Reading HTTP Headers](#read_header).
- [Reading HTTP Request line](#read_line).
- [Understanding HTTP headers](#understand).
	- [Accept](#accept)
	- [Accept-Charset](#accept_charset)
	- [Accept-Encoding](#accept_encoding)
	- [Accept-Language](#accept_language)
- [Example](#example).


Here we will show how to read HTTP information that is sent from the browser to the server in the form of request headers.
We will show the most important HTTP request headers, to learn more check [HTTP 1.1 specification](https://httpwg.github.io/specs/).

<a name="read_header"/>
## Reading HTTP Headers
EWF [WSF_REQUEST]() class, provides features to read HTTP headers, first of all EWF uses the traditional Common Gateway Interface (CGI) programming interface.

Reading headers is straightforward just call the correspoding ```http_xyz``` feature or call the ```meta_string_variable``` feature of [WSF_REQUEST]() with the name of the header with the prefix "HTTP_", be sure to write it in uppercase. This call returns a STRING if the specified header was supplied in the current request, Void otherwise. 

Always check that the result of req.meta_string_variable("HTTP_XYZ") is non-void before using it, where XYZ is the http header name.


* Cookies:
	- To retrieve all cookies from the header you can call the feature 
	```eiffel cookies: ITERABLE [WSF_VALUE]```

	- To retrieve an specific field you can use
	```eiffel cookie (a_name: READABLE_STRING_GENERAL): detachable WSF_VALUE
			-- Field for name `a_name'.```

* Authorization
	- To read the Authorization header use ```eiffel auth_type: detachable READABLE_STRING_8 ```
	- http_authorization: detachable READABLE_STRING_8
			-- Contents of the Authorization: header from the current wgi_request, if there is one.

* Content_length
	- Retrieve the content length as an string value if present
	  ```eiffel content_length: detachable READABLE_STRING_8```
	- If you want the value you can use ```eiffel content_length_value: NATURAL_64``` 

* Content_type
	- To retrieve the content type as an string value if is present
		```content_type: detachable HTTP_CONTENT_TYPE```


There is no way to only get all headers names from the request header.
There is a way to retrieve the header data using the raw_header feature, it returns an STRING if the header data is available or Void in other case, this is convenient
for development purposes, but is not recomended to read the data, because in other case you will need to parse it by hand.

<a name="read_line"/>
####Retrieve information from the Request Line

For example, assume we have the following request line

	GET http://eiffel.org/search?q=EiffelBase  HTTP/1.1

Overview of the features

* HTTP method 
	- The feature ```eiffel request_method: READABLE_STRING_8 ``` allows us access the HTTP request  method, which is usually GET or POST in conventional Web Applications,
		but with the new REST APIs other methods are also used like HEAD, PUT, DELETE, OPTIONS, or TRACE. 
	You can also use the following feature queries to verify the current HTTP method
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
 	- The query string for our request line should return ```q=EiffelBase```
 	- ```query_string: READABLE_STRING_8```

 * Protocol 
 	- The feature return the third part of the request line,
		which is generally HTTP/1.0 or HTTP/1.1.
	- ```server_protocol: READABLE_STRING_8```
    In our example the request method is ```HTTP/1.1```		


<a name="understand"/>
#### Understanding HTTP 1.1 Request Headers
Access to the request headers permits our Web Applications or APIs to perform a number of optimizations and to provide a number of features not otherwise possible. This section summarizes the headers most often used; for additional details on these and other headers, see the [HTTP 1.1 specification](https://httpwg.github.io/specs/), note that [RFC 2616 is dead](https://www.mnot.net/blog/2014/06/07/rfc2616_is_dead).

The "Accept" header field can be used by user agents to specify response media types that are acceptable. Accept header fields can be used to indicate that the request is specifically limited to a small set of desired types, as in the case of a request for an in-line image.

<a name="accept"/>
 * [Accept](https://httpwg.github.io/specs/rfc7231.html#header.accept)
 	- The "Accept" header field can be used by user agents (browser or other clients) to specify response media types that are acceptable. Accept header fields can be used to indicate that the request is specifically limited to a small set of desired types, as in the case of a request for an in-line image.
 	For example, assume we have an APIs Learn4Kids than can offer XML or JSON, JSON format have some advantages over XML, readability, parsing etc but supose taht not all our clients support JSON. If we have representations in both formats, check for application/json , and if it finds a match, use resource.json or in other case check for application/xml and if match, it would just use resource.xml, in other case we send an not acceptable response. Related [Content-Negotiation]()

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




[Back to Workbook] (../workbook.md) 		

[Handling Requests: Form/Query parameters] (/workbook/handling_request/form.md)



