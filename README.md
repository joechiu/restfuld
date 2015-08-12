# restfuld<br>
A lite restfuld service developed by Perl. <br>
<br>
# SYSTEM<br>
tested by centos 6.4, Ubuntu 12 and 14<br>
<br><br>
# INSTALLATION<br>
1. copy ./conf/restful.conf to /etc/init<br>
2. run the following commands<br>
$ stop restful; start restful<br>
restful stop/waiting<br>
restful start/running, process 5866<br>
3. check if restful daemon is running by a browser<br>
http://localhost:34780/?act=test&hello=world&foo=bar<br>
{"hello":"world","foo":"bar"}<br>
4. check if a log restful-ddddmmyy.log generated in /tmp/<br>
<br><br>
# TODO<br>
Currently Perl restful daemon supports text and JSON format request and response though it also supports simple XML action. The following improvements are expected to be done if time permitting. <br>
1. webservice libs for resolving wsdl and xsd<br>
2. more complicate XML response<br>
