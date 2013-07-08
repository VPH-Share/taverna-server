#!/bin/bash

echo -e "\n\n#### 0. Update System Packages\n\n"
sudo apt-get update
sudo apt-get -y install unzip


echo -e "\n\n#### 1. Install Java (OpenJDK-7)\n\n"
sudo apt-get -y install openjdk-7-jre-headless
FIND_JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
sudo echo "export JAVA_HOME=${FIND_JAVA_HOME%/}" >> ~/.bashrc
source ~/.bashrc


echo -e "\n\n#### 2. Install Java Cryptography Extensions\n\n"
COOKIES="oraclelicense=accept-securebackup-cookie;gpw_e24=http://edelivery.oracle.com"
JCE_DOWNLOAD_URL="http://download.oracle.com/otn-pub/java/jce/7/UnlimitedJCEPolicyJDK7.zip"
wget --no-check-certificate --header="Cookie: ${COOKIES}" -c "${JCE_DOWNLOAD_URL}" -O UnlimitedJCEPolicyJDK7.zip
unzip UnlimitedJCEPolicyJDK7.zip
sudo cp -f UnlimitedJCEPolicy/*.jar $JAVA_HOME/lib/security/
rm -rf UnlimitedJCEPolicy UnlimitedJCEPolicyJDK7.zip


echo -e "\n\n#### 3. Install Tomcat 6\n\n"
sudo apt-get -y install tomcat6
sudo cp -f config/etc/tomcat6/* /etc/tomcat6/
sudo chown -R tomcat6:tomcat6 /etc/tomcat6


echo -e "\n\n#### 4. Install AtomHopper (Interaction Service)\n\n"
sudo wget -O /var/lib/tomcat6/webapps/ah.war http://maven.research.rackspacecloud.com/content/repositories/releases/org/atomhopper/atomhopper/1.2.9/atomhopper-1.2.9.war
sudo mkdir -p /etc/atomhopper /opt/atomhopper
sudo cp -fR config/etc/atomhopper/* /etc/atomhopper/
sudo chown -R tomcat6:tomcat6 /etc/atomhopper/ /opt/atomhopper
sudo service tomcat6 restart


echo -e "\n\n#### 5. Install Taverna Server (2.4.1)\n\n"
sudo wget -O /var/lib/tomcat6/webapps/taverna-server.war https://launchpad.net/taverna-server/2.x/2.4.1/+download/TavernaServer.2.4.1.war
sudo service tomcat6 start
while [ ! -d /var/lib/tomcat6/webapps/taverna-server/WEB-INF ]
do
    echo "Waiting for Tomcat to unpack WAR files (5 secs)..."
    sleep 5
done
sudo service tomcat6 stop
sudo cp -fR config/var/lib/tomcat6/webapps/taverna-server/WEB-INF/* /var/lib/tomcat6/webapps/taverna-server/WEB-INF/
sudo cp -fR config/var/lib/tomcat6/conf/Catalina/localhost/* /var/lib/tomcat6/conf/Catalina/localhost/
sudo chown -R tomcat6:tomcat6 /var/lib/tomcat6


echo -e "\n\n#### 6. Starting Tomcat Containers (AtomHopper & Taverna)\n\n"
sudo service tomcat6 restart
