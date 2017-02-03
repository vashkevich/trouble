| |     Issue     |  How to find  | Time to find | How to fix | Time to fix |
| :---: | -------------|-------------| ------------| ---------- | ----------- |
| 1|    Site is not available     |   Make **#curl -IL mntlab**. Get the answer, that site is running on Apache.Try to see status of Apache: **#service httpd status**. Check syntax by **#httpd -V**.  | 5 min .| Correct files httpd.conf (delete virtual host sections, define ServerName correctly). Correct virtual hosts file vhosts.conf. Restart Apache. | 15 min |
| 2 | Try to open site in a browser. Get an error page **"Site is broken"**. |Try to get access to the site in browser. Use **#curl -sL -w "%{http_code}" mntlab -o /dev/null** and get status code 500. Check tomcat status **#service tomcat status** and get status running.Check which port is occupied by which process by **#netstat -tulnap**. No java Pid were found. Check **#java -version**. Get an error. Try to check variable **#echo $JAVA_HOME**. Get an empty line. |  5 min|Try to change java open-jdk version by **#alternatives --config java** and choosing another variant.Check Java version again. Restart Tomcat. Get successful tomcat's status.  | 15 min |
| 3|    Try to open site in a browser. Get an error page **"Site is broken"**   |  Try to see used ports - **#netstat -tulnap**, no java Pid were found again.  | 10 min | Find tomcat home directory **#find / -name tomcat**.Find path tomcat's logs in server.xml file.Look through them.Check permissions and owner of logs directory. Change it from root to tomcat. Try to start Tomcat from /bin derectory.Restart Apache. | 30 min |
| 4 | Try to open site in a browser on port 80. As a result, get an error page “Site is broken".  |Try to open site in a browser on port 8080. As a result, get tomcat's start page So, there is no communication between Apache and Tomcat.| 7 min| Find the path of log mod.jk in apache vhosts.conf. Check it and correct worker-name in workers.properties file. Restart Apache.  | 40 min |
| 5|     Restart VM. Tomcat's start page become unavaliable after rebooting.   |  Restart VM. Output of the command **#service tomcat restart** says that tomcat running, but there is no tomcat process **#service tomcat status**   | 10 min | Check /etc/init.d/tomcat.Change "tomcat" username to "root". Save file and exit. Update runlevel information for system services with command **#chkconfig tomcat on**. Start Tomcat   | 30 min |
| 6 | No iptables rules for ports 80, 22 |Run iptables -L -n| 5 min|  Add to iptables permanent rules with chattr command | ----------- |
