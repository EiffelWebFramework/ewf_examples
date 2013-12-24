<!DOCTYPE html>
<html>
    <head>
        <title>Message</title>
        <!-- optional styling to this site -->
        {include file="optional_styling_css.tpl"/}   
    </head>
    <body>
      <div>
        <h2>Message</h2>
         <tr>
            <td>{$msg.id/}</td><br/>
            <td>{$msg.message/}</td><br/>
            <td>{$msg.date/}</td><br/>
        </tr>
        <p class="links">
            <a href="{$host/}">Home</a>
        </p>
      </div>
      
    </body>
    <!-- optional enhancement -->
    {include file="optional_enhancement_js.tpl"/}   
 </html>