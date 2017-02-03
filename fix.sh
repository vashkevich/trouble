#!/bin/bash

	echo "Repair httpd.conf"
	/bin/cp /vagrant/httpd.conf /etc/httpd/conf/httpd.conf

	echo "Repair vhost.conf"
	/bin/cp /vagrant/vhost.conf /etc/httpd/conf.d/vhost.conf

	echo "Restart apache"
	service httpd restart

	echo "Repair worker.properties"
	/bin/cp /vagrant/workers.properties /etc/httpd/conf.d/workers.properties

	echo "Repair Java. Set correct alternatives version"
	alternatives --set java /opt/oracle/java/x64//jdk1.7.0_79/bin/java

	echo "Change owner tomcat's logs directory"
	chown -R tomcat:tomcat /opt/apache/tomcat/7.0.62/logs/

	echo "Try to start Tomcat"
	/opt/apache/tomcat/7.0.62/bin/./startup.sh
	
	echo "Add Tomcat to autostart after reboot"
        sed -i 's/su - tomcat/su root/g' /etc/init.d/tomcat
	service tomcat restart >/dev/null 2>&1
	chkconfig tomcat on

	echo "Restart Apache"
	service httpd restart

	echo "Set firewall rules"
	iptables -I INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT
	iptables -I INPUT -p tcp --dport 80 -m state --state NEW -j ACCEPT
	
	echo "Edit and save iptables rule"
	chattr -iu /etc/sysconfig/iptables
	service iptables save

	echo "Return to default state/etc /sysconfig/iptables"
	chattr -iu /etc/sysconfig/iptables
	
