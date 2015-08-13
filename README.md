# restfuld<br>
A lite restful daemon service developed by Perl. <br>
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
<br><br>

# KNOWN ISSUES<br>
SSL connection is disabled due to an unknown certificate repository issue<br>
Please refer to the comments in restful.conf for more details<br>

# TODO<br>
Currently Perl restful daemon supports text and JSON format requests and responses though it also supports simple XML action. The following improvements are expected to be done if time permitted. <br>

1. webservice functions for SOAP requests<br>

# AUTHOR
Joe Chiu

