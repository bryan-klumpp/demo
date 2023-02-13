cd /usr/share/tomcat9
sd ln -s /var/lib/tomcat9/conf conf
mkdir log
sd ln -s /var/lib/tomcat9/policy/catalina.policy conf/catalina.policy
sd chmod -R a+rwx conf
#/etc/init.d/tomcat9 stop 
