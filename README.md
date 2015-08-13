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
SSL connection is disabled which caused by the certificate issue<br>
Note: <br>
Actually the certificate repository issue had been fixed in a Centos 6 box to setup 
the restful daemon unfortunately I do neither remember which lib/module used to cause 
the issue nor have a chance to see the issue in Centos 6.4 anymore though I ran the 
daemon in Ubuntu to try to reproduce it but failed.<br>
<br>
you may run this command to enable the SSL connection if you have fixed the above issue
exec /srv/restful/restfuld -s -v 2>> /dev/null<br>
<br>
Fire the command to make a request<br>
$ time PERL_LWP_SSL_VERIFY_HOSTNAME=0 GET https://hostname:34743/?act=test\&foo=bar\&hello=world<br>
<br>
# TODO<br>
Currently Perl restful daemon supports text and JSON format requests and responses though it also supports simple XML action. The following improvements are expected to be done if time permitted. <br>

1. webservice functions for SOAP requests<br>

# AUTHOR
Joe Chiu

