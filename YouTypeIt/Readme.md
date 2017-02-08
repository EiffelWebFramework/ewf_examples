Example from RESTful Web APIs [http://restfulwebapis.org/ytiwpi.html]


EiffelWeb code for the examples in O'Reilly's "RESTful Web APIs".

You Type It, We Post It
-----------------------
<table>
    <tr>
        <td>/YouTypeIt/</td>
        <td>A microblogging website with a programmable
            Collection+JSON API.</td>
    </tr>
 </table>

Web Site, Programmable API
--------------------------

<table>
    <tr>
        <td>http/localhost:8888</td>
        <td>Microblogging web site</td>
    </tr>
    <tr>
        <td>http/localhost:8888/api</td>
        <td>Collection+JSON API</td>
    </tr>
</table>



Using the Collection+JSON API
-----------------------------
To test the programmable API you can use an HTTP client (curl for example) or Postman []
 
``` 
{
  "template" : {
    "data" : [
      {"name" : "text", "value" : "testing You Type It, We Post It"}
    ]
  }
}
```
