Nav: [Workbook](../workbook.md) | [Handling Requests: Form/Query Parameter](/workbook/handling_request/form.md)


## EWF basic service

##### Table of Contents  
[Basic Structure](#structure)  
[Service to Generate Plain Text](#text)  
[Service to Generate HTML](#html)  


<a name="structure"/>
## EWF service structure

The following code describe the basic structure of an EWF basic service that handle HTTP requests.

```eiffel
class
	SERVICE_TEMPLATE

inherit
	WSF_DEFAULT_SERVICE  -- Todo explain this, and the concept of launchers and connectors ()

create
	make_and_launch

feature -- Basic operations

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			-- To read incoming HTTP request, we need to use `req'

			-- May require talking to databases or other services.	
 
			-- To send a response we need to setup, the status code and
			-- the response headers and the content we want to send out our client
		end
end
```

By default the service run on port 80, but generally this port is already busy, so it is recommended to use another port.
So to achieve that it is needed to redefine the feature `initialize' and set up a new port number using the service options.

```eiffel
class
	SERVICE_TEMPLATE
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
			-- on port 9090
		do
			set_service_option ("port", 9090)
		end

feature -- Basic operations

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the incoming request.
		do
			-- To read incoming HTTP requires, we need to use `req'

			-- May require talking to databases or other services.	
 
			-- To send a response we need to setup, the status code and
			-- the response headers and the content we want to send out client
		end
end
```

So a basic EWF service inherit from **WSF_DEFAULT_SERVICE** (there are other options see [?]).
And then you just need to implement the *execute feature*, get data from the request *req* and write the response in *res*

The **WSF_REQUEST** lets obtain at all of the incoming data; the class has features by which it is possible look for information such as request method, form data, query parameters, HTTP request headers, and the client’s hostname. 
The **WSF_RESPONSE** lets specify response information such as HTTP status codes (10x,20x, 30x, 40x, and 50x) and response headers (Content-Type,Content-Length, etc.).


<a name="text"/>
## A simple Service to Generate Plain Text.

Before to continue, it's recommended review the getting started guided.

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
		do
				-- To send a response we need to setup, the status code and
				-- the response headers.
			res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/plain"], ["Content-Length", "11"]>>)
			res.put_string ("Hello World")
		end

end
```

##### Source code
The source code is available on Github. You can get it by running the command:

>git clone https://github.com/EiffelWebFramework/ewf_examples.git

The Simple Service to Generate Plain Text example is located in the directory $PATH/ewf_examples/workbook/basics/simple, where $PATH is where you run ```git clone``` . Just double click on the simple.ecf file and select the simple_nino target or if you prefer the command line, run the command:

>estudio -config simple.ecf -target simple_nino

<a name="html"/>
## A Service to Generate HTML.
To generate HTML, it's needed

1. Change the Content-Type : "text/html"
2. Build an HTML page

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
		do
				-- To send a response we need to setup, the status code and
				-- the response headers.
			res.put_header ({HTTP_STATUS_CODE}.ok, <<["Content-Type", "text/html"], ["Content-Length", web_page.count.out]>>)
			res.put_string (web_page)
		end


	web_page: STRING = "[ 	
	<!DOCTYPE html>
	<html>
		<head>
			<title>Resume</title>
		</head>
		<body>
			Hello World
		</body>
	</html>
]"

end
```
Nav: [Workbook](../workbook.md) |  [Handling Requests: Form/Query Parameter](/workbook/handling_request/form.md)

