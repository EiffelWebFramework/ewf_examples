<!DOCTYPE html>
<html>
    <head>
        <title>Home</title>
        <!-- optional styling to this site -->
        {include file="optional_styling_css.tpl"/}   
    </head>
    <body>
        <div>
          <h1>You type it, we post it!</h1>
          <p>Exciting! Amazing!</p>
          
          <p class="links">
            <a href="{$host/}/messages">Get started</a>
            <a href="{$host/}/about">About this site</a>
            <!--<a href="{@host}/login">Login via Example.net</a>-->
          </p>
        </div>
    </body>
    <!-- optional enhancement -->
    {include file="optional_enhancement_js.tpl"/}    
</html>