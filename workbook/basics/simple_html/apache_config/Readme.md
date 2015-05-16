##Run simple_html with FCGI and Apache on Windows.



Prerequisites

* This tutorial was written for people working under Windows environment, and using Apache Server with FCCI server. 
* Compile the ewf application from command line.
* Assuming you have installed Apache Server under C:/home/server/Apache24.
* Assuming you have placed your current project under C:/home/server/Apache24/fcgi-bin.
* Assuming you have setted the Listen to 8888, the defautl value is 80 .


###Compile the project simple_html using the fcgi connector.

	ec ­config simple_html.ecf ­target simple_html_fcgi ­finalize ­c_compile ­project_path .

Copy the genereted exe to C:/home/server/Apache24/fcgi-bin folder.	

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

Test if your httpd.cong is ok
	httpd -t

Luanch the server
	httpd

Check the application
    http://localhost:8888/simple