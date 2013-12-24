{foreach from="$items" item="item" name=foo}
		
		<
	        "href": "{$host/}}/api/{$item.id/}}", 
	        "data": [
	          <"name": "text", "value": "{$item.message/}">, 
	          <"name": "date_posted", "value": "{$item.date/}">
	        ]
	    >,
{/foreach}	      
