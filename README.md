| |     Issue     |  How to find  | Time to find | How to fix | Time to fix |
| :---: | -------------|-------------| ------------| ---------- | ----------- |
| 1|    Site is not available     |   Make **#curl -IL mntlab**. Get the answer, that site is running on Apache.Try to see status of Apache: **#service httpd status**. Check syntax by **#httpd -V**.  | 5 min .| Correct files httpd.conf (delete virtual host sections, define ServerName correctly). Correct virtual hosts file vhosts.conf. Restart Apache. | 15 min |
| 2 | Try to open site in a browser. Get an error page **"Site is broken"**. |Try to get access to the site in browser. Use **#curl -sL -w "%{http_code}" mntlab -o /dev/null** and get status code 500. Check tomcat status **#service tomcat status** and get status running.Check which port is occupied by which process by **#netstat -tulnap**. No java Pid were found. Check **#java -version**. Get an error. Try to check variable **#echo $JAVA_HOME**. Get an empty line. |  5 min|Try to change java open-jdk version by **#alternatives --config java** and choosing another variant.Check Java version again. Restart Tomcat. Get successful tomcat's status.  | 15 min |
| 3|    Try to open site in a browser. Get an error page **"Site is broken"**   |  Try to see used ports - **#netstat -tulnap**, no java Pid were found again.  | 10 min | Find tomcat home directory **#find / -name tomcat**.Find path tomcat's logs in server.xml file.Look through them.Check permissions and owner of logs directory. Change it from root to tomcat. Try to start Tomcat from /bin derectory.Restart Apache. | 30 min |
| 4 | Try to open site in a browser on port 80. As a result, get an error page “Site is broken".  |Try to open site in a browser on port 8080. As a result, get tomcat's start page So, there is no communication between Apache and Tomcat.| 7 min| Find the path of log mod.jk in apache vhosts.conf. Check it and correct worker-name in workers.properties file. Restart Apache.  | 40 min |
| 5|     Restart VM. Tomcat's start page become unavaliable after rebooting.   |  Restart VM. Output of the command **#service tomcat restart** says that tomcat running, but there is no tomcat process **#service tomcat status**   | 10 min | Check /etc/init.d/tomcat.Change "tomcat" username to "root". Save file and exit. Update runlevel information for system services with command **#chkconfig tomcat on**. Start Tomcat   | 30 min |
| 6 | No iptables rules for ports 80, 22 |Run iptables -L -n| 5 min|  Add to iptables permanent rules with chattr command | 30 min |


Answers to additional questions.

#### What java version is installed?
#sudo java -showversion 
java version "1.7.0_79"
Java(TM) SE Runtime Environment (build 1.7.0_79-b15)
Java HotSpot(TM) 64-Bit Server VM (build 24.79-b02, mixed mode)

#### How was it installed and configured?
This java package was installed and configured manually.

#### Where are log files of tomcat and httpd?
HTTPD logfiles situated at /var/log/httpd/
TOMCAT logfiles situated at /opt/apache/tomcat/7.0.62/logs

#### Where is JAVA_HOME and what is it?
JAVA_HOME is a environment variable, which point to where Java JRE is installed.

#### Where is tomcat installed?
/opt/apache/tomcat

#### What is CATALINA_HOME?
Tomcat consist of a number of components, and the main component is Catalina, which provides the implementation of the servlet specification. When starting the Tomcat server, it's Catalina that is actually starting. The variable 'catalina_home' stores the location of the Catalina files.
Configuration files, located in Tomcat's "$CATALINA_BASE/conf" directory:

    catalina.policy
    catalina.properties
    logging.properties
    content.xml
    server.xml
    tomcat-users.xml
    web.xml


#### What users run httpd and tomcat processes? How is it configured?
httpd runs user apache
tomcat runs user tomcat

#### What configuration files are used to make components work with each other?
If we want to make work together Tomcat ans Apache, we should use special connectors, mod.jk. It help us to configuered links between this two files.
Main config files: worker.properties and vhosts.conf in apache, server.xml - in tomcat.

#### What does it mean: “load average: 1.18, 0.95, 0.83”?
"Load average: 1.18, 0.95, 0.83" indicates CPU loads in top util. This line of CPU load is the length of the run queue, i.e. the length of the queue of processes waiting to be run. A high load value means the run queue is long. A low value means that it is short. So, if the one minute load average is 1.18, it means that on average during that minute, there was 1.18 processes waiting to run in the run queue. This metric is irrespective of how many cores/cpu's there are. For a 2-cored system, running 1 process that consumes a whole core ( leaving the other idle ) results in a load average of 1.0. In order to decided how loaded a system is, you'll need to know the number of cores and do the division yourself
