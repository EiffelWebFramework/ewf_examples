Run simple_html with FCGI and Apache on Windows.


Compile the project

	ec ­config simple_html.ecf ­target simple_html_fcgi ­finalize ­c_compile ­project_path .

Check if you have libfcgi.dll in your PATH.

Add to httpd.conf the content 

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


