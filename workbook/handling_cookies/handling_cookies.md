Nav: [Workbook](../workbook.md) | [Generating Responses](/workbook/generating_response/generating_response.md)

# Handling Cookies

- [Cookie](#cookie)
	- [Cookie Porperties](#properties)
- [Write and Read Cookies](#set_get)
	- [How to set a cookie](#set_cookie)
	- [How to read a cookie](#read_cookie)
- [Examples](#examples)		

<a name="cookie"/>
## [Cookie](http://httpwg.github.io/specs/rfc6265.html)
A cookie is a piece of data that can be stored in a browser's cache. If you visit a web site and then revisit it, the cookie data can be used to identify you as a return visitor. Cookies enable state information, such as an online shopping cart, to be remembered. A cookie can be short term, holding data for a single web session, that is, until you close the browser, or a cookie can be longer term, holding data for a week or a year.

Cookies are used a lot in web client-server communication.

- HTTP State Management With Cookies
	 
- Personalized response to the client based on their preference, for example we can set background color as cookie in client browser and then use it to customize response background color, image etc.

<a name="properties"/>
### Cookie properties

 - Comment: describe the purpose of the cookie. Note that server doesn’t receive this information when client sends cookie in request header. 
 - Domain: domain name for the cookie.
 - Expiration/MaxAge: Expiration time of the cookie, we could also set it in seconds.  
 - Name: name of the cookie.
 - Path: path on the server to which the browser returns this cookie. Path instruct the browser to send cookie to a particular resource.
 - Secure: True, if the browser is sending cookies only over a secure protocol, False in other case.
 - Value: Value of th cookie as string.
 - HttpOnly: Checks whether this Cookie has been marked as HttpOnly. 

<a name="set_get"/>
## Write and Read Cookies.

To send a cookie to the client we should use the [HTTP_HEADER] class, and call ```h.put_cookie``` feature or 
```h.put_cookie_with_expiration_date``` feature, see [How to set Cookies]() to learn the details, and the set it to response object [WSF_RESPONSE] as we saw previously. 

We will show an example.

To Read incomming cookies we can read all the cookies with 

```
cookies: ITERABLE [WSF_VALUE]
			-- All cookies.
``` 
which return an interable of WSF_VALUE objects corresponding to the cookies the browser has associated with the web site.
We can also check if a particular cookie by name using 

```
WSF_REQUEST.cookie (a_name: READABLE_STRING_GENERAL): detachable WSF_VALUE
			-- Field for name `a_name'.
``` 
feature.


<a name="set_cookie"/>
### How to set Cookies
Here we have the feature definitions to set cookies

```eiffel
deferred class interface
	HTTP_HEADER_MODIFIER

feature -- Cookie

	put_cookie (key, value: READABLE_STRING_8; expiration, path, domain: detachable READABLE_STRING_8; secure, http_only: BOOLEAN)
			-- Set a cookie on the client's machine
			-- with key 'key' and value 'value'.
			-- Note: you should avoid using "localhost" as `domain' for local cookies
			--       since they are not always handled by browser (for instance Chrome)
		require
			make_sense: (key /= Void and value /= Void) and then (not key.is_empty and not value.is_empty)
			domain_without_port_info: domain /= Void implies domain.index_of (':', 1) = 0

	put_cookie_with_expiration_date (key, value: READABLE_STRING_8; expiration: DATE_TIME; path, domain: detachable READABLE_STRING_8; secure, http_only: BOOLEAN)
			-- Set a cookie on the client's machine
			-- with key 'key' and value 'value'.
		require
			make_sense: (key /= Void and value /= Void) and then (not key.is_empty and not value.is_empty)
```

Example of use:

```eiffel
   response_with_cookies (res: WSF_RESPONSE)
		local
			l_message: STRING
			l_header: HTTP_HEADER
			l_time: HTTP_DATE
		do
				create l_header.make
				create l_time.make_now_utc
				l_time.date_time.day_add (40)
				l_header.put_content_type_text_html
				l_header.put_cookie_with_expiration_date ("EWFCookie", "EXAMPLE",l_time.date_time, "/", Void, False, True)
				res.put_header_text (l_header.string)
				res.put_string (web_page)
		end		
```
<a name="read_cookie"/>
### How to read Cookies

Reading a particular cookie
```eiffel
		if req.cookie ("EWFCookie") = Void then
			do_something
		end
````		

Reading all the cookies

```Eiffel
	across req.cookies as ic loop
		print (ic.item.name)
	end
```




Nav: [Workbook](../workbook.md) | [Generating Responses](/workbook/generating_response/generating_response.md)
