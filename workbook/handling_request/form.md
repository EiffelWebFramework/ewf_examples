
#Handling Requests: Form/Query Data


An HTML Form can handle GET and POST requests.
When we use a form with method GET, the data is attached at the end of the url for example:

>http://wwww.example.com?key1=value1&...keyn=valuen

If we use the method POST, the data is sent to the server in a different line.

Extracting form data from the server side is one of the most tedious parts. If you do it by hand, you will need 
to parse the input, you'll have to URL-decode the value.

Here we will show you how to read input submitted by a user using a Form.
 * How to handle missing values:
   * client side validattion, server side validations, set default if it's a valid option.
 * How to populate Eiffel objects from the request data.          

## Reading Form Data
EWF [WSF_REQUEST]() provides features to handling this form parsing automatically.

### Query Parameters

	WSF_REQUEST.query_parameters: ITERABLE [WSF_VALUE]
			-- All query parameters
	
	WSF_REQUEST.query_parameter (a_name: READABLE_STRING_GENERAL): detachable WSF_VALUE
			-- Query parameter for name `a_name'.

### Form Parameters

	WSF_REQUEST.form_parameters: ITERABLE [WSF_VALUE]
      -- All form parameters sent by a POST
      
	WSF_REQUEST.form_parameter (a_name: READABLE_STRING_GENERAL): detachable WSF_VALUE
			-- Field for name `a_name'.

### Reading Values
To read a request (form) parameter, we call the feature 
>WSF_REQUEST.form_parameter (a_name: READABLE_STRING_GENERAL): detachable WSF_VALUE, with the a_name as case sensitive argument.




		



