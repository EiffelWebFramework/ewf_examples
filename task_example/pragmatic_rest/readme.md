Pragmatic REST Implementation
===
This is an implementation of CRUD pattern for manipulate resources, this is the first step to use the HTTP protocol as an application protocol instead of a transport protocol. 

This protocol follows the level 2 of [Richardson Maturity Model](http://martinfowler.com/articles/richardsonMaturityModel.html).  Basically the API must use a uniform interface, in our case we are using HTTP, so, we need to use the uniform interface provided by HTTP.

This level indicates that your API should use the transport protocol properties in order to deal with scalability and failures. Don't use a single POST method for all, but make use of GET when you are requesting resources, and use the DELETE method when you want to delete a resources. Also, use the response codes of your tunneling protocol. Don't use 200 (OK) code when something went wrong for instance. By doing this for the HTTP transport protocol, or any other transport protocol you like to use, you have reached level 2. 
See more at: http://restcookbook.com/Miscellaneous/richardsonmaturitymodel/#sthash.tHyQyI21.dpuf


Task Protocol
---
| Verbs          |        Uri or Uri Template           | Use/ Description  |
|:------------- |:-------------|:-----|
| POST     | /tasks | Create a new task, and upon success, receive a Location header specifying the new task's URI. |
| GET      | /tasks      |   Request the current tasks |
| GET | tasks/{task_id}  |  Request the current state of the task specified by the URI|
| PUT | tasks/{task_id}      | Update an task at the given URI with new information, providing the full representation |
| DELETE | tasks/{task_id}     |    Logically remove the order identified by the given URI. |



CRUD Pattern: URIs design
--------------------------------

URIs should be opaque to consumers.  Only the implementor of the server know the URIs structure, how to interpret and map it to a resource. Here we are using URI templates to describe a protocol, but doing that we are increasing the coupling between consumers and server. So, keep in mind this example is not a real RESTful system(or Hypermedia API), that’s why it’s called pragmatic REST.  The goal is describe it with his pros and cons and see if it meet our needs.

Ideally, we should only use URIs templates for internal purposes, but describing a protocol (Contracts) using them introduce tight coupling.

Resource Representation
---
The previous table shows a contract, the URI or URI template, allows us to identify resources, now we will chose a representation, for this particular case we will use JSON.

*Note*: 
 1. A resource can have multiple URIs.
 2. A resource can have multiple Representations.

JSON Representation
```sh
    {
            "id": 4,
            "description": "Fix database",
            "completed": "False",
            "created_at": "2012-06-14 12:43:43",
            "date_due": "2012-07-14 12:43:43"
     }
 ```
