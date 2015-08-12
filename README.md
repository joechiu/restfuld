# restfuld
A lite restfuld service developed by Perl. 

SYSTEM
tested by centos 6.4, Ubuntu 12 and 14

INSTALLATION
1. copy ./conf/restful.conf to /etc/init
2. run the following commands
# stop restful; start restful
restful stop/waiting
restful start/running, process 5866
3. check if restful daemon is running by a browser
http://localhost:34780/?act=test&hello=world&foo=bar
{"hello":"world","foo":"bar"}
4. check if a log restful-ddddmmyy.log generated in /tmp/

TODO
Currently Perl restful daemon supports text and JSON format request and response though it also supports simple XML action. The following improvements are expected to be done if time permitting. 
1. webservice libs for resolving wsdl and xsd
2. more complicate XML response
