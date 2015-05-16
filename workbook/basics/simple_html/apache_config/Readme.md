##Run simple_html with FCGI and Apache on Windows.


###Compile the project simple_html using the fcgi connector.

	ec ­config simple_html.ecf ­target simple_html_fcgi ­finalize ­c_compile ­project_path .

Check if you have _libfcgi.dll_ in your PATH.

Add to httpd.conf the content, you can get the configuration file [here](config.conf) 

```
LoadModule fcgid_module modules/mod_fcgid.so

<IfModule mod_fcgid.c>
  <Directory "C:/home/server/Apache24/fcgi-bin">
    SetHandler fcgid-script
    Options +ExecCGI +Includes +FollowSymLinks -Indexes
    AllowOverride All
    Require all granted
  </Directory>
  ScriptAlias /simple "C:/home/server/Apache24/fcgi-bin/simple_html.exe"
</IfModule>
```


