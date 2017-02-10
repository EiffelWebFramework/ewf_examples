Eiffel Web Example 
==================
This example shows how to integrate a basic front end made-with Javascript + HTML with a backend developed with EWF.  


App Example
---

The app example has the following features. 
 - two labels.
 - two input fields
 - one button

> One of the labels is updated every second with the current time.
> One of the labels responds to a mouse hover by displaying a (constantly changing) string it requests from the server.
> The two input fields return their data to the server with each keystroke.
> If and only if the two fields are integers does the server send a message to have  the button activated.

Project Structure
---
At the moment EWF does not use [convention over configuration](http://en.wikipedia.org/wiki/Convention_over_configuration), so every project will have his own structure, here is the breakdown for the app example

 - **app**
    - **root**  -- root cluster, launch the app.
    	- **any**   --  root application able to launch the app with either cgi, libfcgi, or nino connector.  
    	- **default** --  launch the application using nino connection.
    - **src**  -- Supporting source code to build EWF services, Web APIs (REST API), CRUDs, or conventional web applications.   
    - **tests**   -- Unit and integration testing 
    - **www**  -- document root containing html pages, js and css files needed by the application
    - **app.ecf** -- Eiffel configuration file

Application Architecture
--
Before to see the custom implementation for our example, it's recomended to see the basic application architecture and the common lifecyle that every ewf application will have. So first read the wiki page [application lifecycle] (https://github.com/EiffelWebFramework/ewf_examples/wiki/Application-Lifecycle)


![Application Architecture](/app/doc/APP_SERVICE_NEW.png "Application arhitecture")

The _APPLICATION_ class is the root of our example, it will launch the application, using the corresponding connector, which connector? it will depend how do you want to run it _cgi_, _fcgi_ or _Standalone_. For development is recommended to use `Standalone`, a standalone web server build on Eiffel. For production fcgi or cgi using Apache or another popular web server.

Our _APPLICATION_ class inherit from *APP_SERVICE* class, which also inherit from others, let’s describe them in a few words, before continuing with *APP_SERVICE*.

*WS_LAUNCHABLE_SERVICE* inherit from *WS_SERVICE* class, which is the low level entry point in EWF to implement the main entry of your web service. 

*WSF_DEFAULT_SERVICE_LAUNCHER* is the default launcher for a *WSF_SERVICE* based on *WSF_STANDALONE_SERVICE_LAUNCHER*. 
EiffelWeb allow us to launch our application using different kind of connectors. Below a [BON diagram] (http://www.bon-method.com/index_normal.htm) showing the different kind of connectors.

![Launcher Hierarchy](/app/doc/WSF_SERVICE_LAUNCHER.png "Launcher")


*WSF_EXECUTION* is th low level request execution and from which one we have access to the query and form parameters, input data, headers, etc ( everything from an HTTP request ). Note that per incoming request we will have an instance of WSF_EXECUTION to handle the execute concurrently.

*WSF_ROUTED_EXECUTION*  class,  enable our service to dispatch http requests  to the underlying code responsible to handle the execution.  In particular the request dispatcher is handled by *WS_ROUTER*.  Basically we map URI and URI templates with Eiffel code and this is the responsibility of a dispatcher.

The classes *WSF_URI_HELPER_FOR_ROUTED_SERVICE*, *WSF_URI_TEMPLATE_HELPER_FOR_ROUTED_SERVICE*,  are helpers to map uri and uri templates to Eiffel code.
 

In the classs *APP_SERVICE_EXECUTION*, we define how we map uris and uri templates and will allow us to route HTTP request to the corresponding piece of code to handle the incoming requests. We setup our mapping in the feature *setup_router*.

```Eiffel
setup_router
    		-- Setup router
		require -- from WSF_ROUTED_SERVICE
			router_created: router /= Void
		local
			fhdl: WSF_FILE_SYSTEM_HANDLER
			doc: WSF_ROUTER_SELF_DOCUMENTATION_HANDLER
		do
			create doc.make (router)
			router.handle_with_request_methods ("/api/doc", doc, router.Methods_get)
			map_uri_template_agent_with_request_methods ("/api/message/time/now", agent handle_time_now_utc, router.Methods_get)
			map_uri_template_agent_with_request_methods ("/api/message/hover/{name}", agent handle_hover_message, router.Methods_get)
			map_uri_template_agent_with_request_methods ("/api/session/{session}/item/{name}", agent handle_interface_id_set_value, router.Methods_post)
			map_uri_template_agent ("/api/{operation}", agent handle_api)
			create fhdl.make_hidden ("www")
			fhdl.set_directory_index (<< "index.html" >>)
			router.handle_with_request_methods ("", fhdl, router.Methods_get)
		end
```

As we said before we need to associate URIs and URI templates with Eiffel code to handle their execution, in this particular example we have Eiffel agents to do that. Let see an example

From our setup_router we have

```Eiffel
map_uri_template_agent_with_request_methods ("/api/message/hover/{name}", agent handle_hover_message, router.methods_GET)
```

Eiffel code handling the HTTP request to _/api/message/hover/{name}_

```Eiffel
handle_hover_message (req: WSF_REQUEST; res: WSF_RESPONSE)
    	local
			hdate: HTTP_DATE
			n: READABLE_STRING_8
			s: STRING_8
		do
			if attached {WSF_STRING} req.path_parameter ("name") as p_name then
				n := p_name.url_encoded_value
			else
				n := "?"
			end
			create hdate.make_from_date_time (create {DATE_TIME}.make_now_utc)
			s := n + " hovered at " + hdate.rfc1123_string.as_string_8
			res.set_status_code ({HTTP_STATUS_CODE}.ok)
			res.put_header_line ("Content-Type: text/plain")
			res.put_header_line ("Content-Length: " + s.count.out)
			res.put_string (s)
		end
```

Executing the example
----
The following video shows the application running.
[![ScreenShot](/app/doc/app_example_screen_cast.png)](http://screencast-o-matic.com/watch/cIXtFFVSIZ)

Execute the app from EiffelStudio
----
The following video shows how to launch the application from EiffelStudio

[![ScreenShot](/app/doc/app_launch_screen_cast.png)](http://screencast-o-matic.com/watch/cIXu2OVSrJ)


Debug the app from EiffelStudio using Nino Web Server
---
The following video shows how to debug the application from EiffelStudio using the development server Nino.

[![ScreenShot](/app/doc/app_debug_screen_cast.png)](http://screencast-o-matic.com/watch/cIXu2GVSrN)
