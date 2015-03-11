Nav: [Workbook](../workbook.md) | [Basic Concepts] (/workbook/basics/basics.md) | [Handling Requests: Header Fields](/workbook/handling_request/headers.md) 


#Handling Requests: Form/Query Data


##### Table of Contents  
- [Reading Form Data](#read).
  - [Query Parameters](#query).
  - [Form Parameters](#form).
  - [Uniform Read](#uniform)

An HTML Form can handle GET and POST requests.
When we use a form with method GET, the data is attached at the end of the url for example:

>http://wwww.example.com?key1=value1&...keyn=valuen

If we use the method POST, the data is sent to the server in a different line.

Extracting form data from the server side is one of the most tedious parts. If you do it by hand, you will need 
to parse the input, you'll have to URL-decode the value.

Here we will show you how to read input submitted by a user using a Form (GET and POST).
 * How to handle missing values:
   * client side validattion, server side validations, set default if it's a valid option.
 * How to populate Eiffel objects from the request data.          

<a name="read"/>
## Reading Form Data
EWF [WSF_REQUEST]() class, provides features to handling this form parsing automatically.

<a name="query"/>
### Query Parameters

	WSF_REQUEST.query_parameters: ITERABLE [WSF_VALUE]
			-- All query parameters
	
	WSF_REQUEST.query_parameter (a_name: READABLE_STRING_GENERAL): detachable WSF_VALUE
			-- Query parameter for name `a_name'.
<a name="form"/>
### Form Parameters

	WSF_REQUEST.form_parameters: ITERABLE [WSF_VALUE]
      			-- All form parameters sent by a POST
      
	WSF_REQUEST.form_parameter (a_name: READABLE_STRING_GENERAL): detachable WSF_VALUE
			-- Field for name `a_name'.

The values supplied to form_parameter and query_parameter are case sensitive.

<a name="uniform"/>
### Read Data
The previous features, let you read the data one way for GET request and a different way for POST request. WSF_REQUEST provide a feature to read all the data in a uniform way.

	WSF_REQUEST.item (a_name: READABLE_STRING_GENERAL): detachable WSF_VALUE
			-- Variable named `a_name' from any of the variables container
			-- and following a specific order: form_, query_ and path_ parameters

So, you use **WSF_REQUEST.item** feature exactly the same way for GET and POST request.

>Note: if a query parameter has the same name as a form paramenter req.item will retrieve the form paramenter. Remember the precedence: form > query > path 



### Reading Values

Suppose we have the following HTML5 form using Method POST.

```
<h1> EWF Handling Client Request: Form example </h1>  
<form action="/" method="POST">
 <fieldset> 
    <legend>Personal details</legend> 
    <div> 
        <label>First Name
	    <input id="given-name" name="given-name" type="text" placeholder="First name only" required autofocus> 
	</label>
   </div>
   <div> 
        <label>Last Name
	    <input id="family-name" name="family-name" type="text" placeholder="Last name only" required autofocus> 
	</label>
    </div>
    <div>
	 <label>Email 
	    <input id="email" name="email" type="email" placeholder="example@domain.com" required>
	</label> 
    </div> 
    <div>  
       <label>Languages 
	  <input type="checkbox" name="languages" value="Spanish"> Spanish
	  <input type="checkbox" name="languages" value="English"> English 
	</label> 
     </div> 
  </fieldset>
  <fieldset> 
  	<div> 
	    <button type=submit>Submit Form</button> 
	 </div> 
  </fieldset> 
</form>
```
To read all the parameters names we simple call WSF_REQUEST.form_parameters. 

```
 req: WSF_REQUEST
 across req.form_parameters as ic loop show_parameter_name (ic.item.key) end
```
To read a particular parameter, a single value, for example `given-name', we simple call WSF_REQUEST.form_parameter (a_name)
```
  req: WSF_REQUEST 
  if attached {WSF_STRING} req.form_paramenter ('given-name') as l_given_name then
  	-- Work with the given parameter, for example populate an USER object
  	-- the argument is case sensitive
  else
        -- Value missing, check the name against the HTML form 
  end
```

To read multiple values, for example in the case of `languages'

```
  req: WSF_REQUEST 
  idioms: LIST[STRING]
  	-- the argument is case sensitive
  if attached {WSF_MULTIPLE_STRING} req.form_paramenter ('languages') as l_languages then
  	-- Work with the given parameter, for example populate an USER object
  	-- Get all the associated values
  	create {ARRAYED_LIST[STRING]} idioms.make (2)
	across l_languages as ic loop idioms.force (ic.item.value) end
  elseif attached {WSF_STRING} req.form_paramenter ('languages') as l_language then
        -- Value missing, check the name against the HTML form 
        create {ARRAYED_LIST[STRING]} idioms.make (1)
	idioms.force (l_language.value)
  else
  	-- Value missing 
  end
```
In this case we are handling strings values, but in some cases you will need to do a conversion, betweend the strings that came from the request to map them to your domain model. We will see how to do that later.

### Reading Raw Data
You can also access the data in raw format, it means you will need to parse and url-decode it, and also you will not be able to use the previous features, by default, to enable that you need to call `req.set_raw_input_data_recorded (True)'. This feature (reading raw data) is useful if you are reading POST data with JSON or XML formats, but it's not convinient for HTML forms.

To read raw data you need to do this

```
   l_raw_data:STRING
   
   req.set_raw_input_data_recorded (True) --
   create l_raw_data.make_empty
   req.read_input_data_into (l_raw_data)
```

> given-name=testr&family-name=test&dob=1976-08-26&email=test%40gmail.com&url=http%3A%2F%2Fwww.eiffelroom.com&phone=455555555555&languages=Spanish&languages=English			



Nav: [Workbook](../workbook.md) | [Basic Concepts] (/workbook/basics/basics.md) | [Handling Requests: Header Fields](/workbook/handling_request/headers.md) 

