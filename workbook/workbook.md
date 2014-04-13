# EWF Core 

see http://eiffelwebframework.github.io/EWF/getting-started/
see http://eiffelwebframework.github.io/EWF/wiki/Documentation/
see https://github.com/EiffelWebFramework/ewf_examples/wiki/Application-Lifecycle

## EWF core big picture.


Client   <---->  EWF service <----->{Databases, Other services, etc}


1. Read the request sent by the client
   	
2. Generate the results
	This process may require talking to databases, other services , etc to build the response.

3. Send the response to the client

	

