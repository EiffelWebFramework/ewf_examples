<!DOCTYPE html>
<html>
    <head>
        <title>Messages</title>
        <!-- optional styling to this site -->
        {include file="optional_styling_css.tpl"/}   
    </head>
    <body>
      <div>
        <h2>Messages</h2>
        
        <p>
          Enter your message below:
        </p>
        
        <form action="{$host/}/messages" method="post">
            <input type="text" name="message" value="" required="true"/>
            <input type="submit" />
        </form>

        <div>
          <p>
            Here are some other messages, too:
          </p>
          {foreach from="$messages" item="item"}
              <a href="{$host/}/messages/{$item.id/}">{$item.message/}</a><br/>
          {/foreach}
        </div>

        <p class="links">
          <a href="{$host/}/">Home</a>
        </p>
        
      </div>
    </body>
    <!-- optional enhancement -->
   {include file="optional_enhancement_js.tpl"/}   
</html>