# restfuld<br>
A lite powerful restful daemon service developed by Perl. <br>
<br>
# SYSTEM<br>
tested by centos 6.4, Ubuntu 12 and 14<br>
<br><br>
# INSTALLATION<br>
1. cd ~/
2. git clone https://github.com/joechiu/restfuld.git
3. cd /srv/
4. ln -s ~/restfuld restful
5. cd restful
6. copy ./conf/restful.conf to /etc/init<br>
7. run the following commands<br>
$ stop restful; start restful<br>
-- restful stop/waiting<br>
-- restful start/running, process 5866<br>
8. check if restful daemon is running by a browser or GET, wget is fine<br>
http://localhost:34780/?act=test&hello=world&foo=bar<br>
{"hello":"world","foo":"bar"}<br>
9. check if a log restful-ddddmmyy.log generated in /tmp/<br>
eg.<br>
[03:54:28 28849]        pid is same as fork<br>
[03:54:28 13464]        -------- web@xxx.xxx.xx.xxx --------<br>
[03:54:28 13464]        Type: application/json, Action: test, Method: GET<br>
[03:54:28 13464]        Content: {"hello":"world","foo":"bar"}<br>
[03:54:28 13464]        Redo process: test.pl<br>
[03:54:28 13464]        Results: {"hello":"world","foo":"bar","realtime":9e-06}<br>

<br><br>

# API INSTALLATION
Implement the following methods to build your own API as plugin.<br>
1. create a new folder under the plugins diretory<br>
2. commit the programs and packages under the folder<br>
3. add an action into default-settings.pl under the plugins directory (optional)<br>
4. method todo will instantiate the plugin or capture the value returned from your program<br>
5. see the sample plugin for example<br>
<br><br>

# KNOWN ISSUES<br>
Update the Perl SSL modules to the most recent versions if meet SSL connection issues for self signed certificate<br>

# TODO<br>
Currently Perl restful daemon supports text and JSON format requests and responses well though it also supports simple XML action. The following improvements would be expected to be done if time permitted. <br>

1. webservice functions for SOAP requests<br>

# AUTHOR
Joe Chiu

