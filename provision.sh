#!/bin/bash

echo -e "\n\n#### 0. Update System Packages\n\n"
apt-get update
apt-get -y install unzip


echo -e "\n\n#### 1. Install Java (OpenJDK-7)\n\n"
apt-get -y install openjdk-7-jre-headless
FIND_JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
echo "export JAVA_HOME=${FIND_JAVA_HOME%/}" > /etc/profile.d/java_path.sh
source /etc/profile.d/java_path.sh


echo -e "\n\n#### 2. Install Java Cryptography Extensions\n\n"
COOKIES="oraclelicense=accept-securebackup-cookie;gpw_e24=http://edelivery.oracle.com"
JCE_DOWNLOAD_URL="http://download.oracle.com/otn-pub/java/jce/7/UnlimitedJCEPolicyJDK7.zip"
wget --no-check-certificate --header="Cookie: ${COOKIES}" -c http://www.oracle.com/technetwork/java/javase/downloads/index.html -O /dev/null
wget --no-check-certificate --header="Cookie: ${COOKIES}" -c "${JCE_DOWNLOAD_URL}" -O UnlimitedJCEPolicyJDK7.zip
unzip UnlimitedJCEPolicyJDK7.zip
cp -f UnlimitedJCEPolicy/*.jar $JAVA_HOME/lib/security/
rm -rf UnlimitedJCEPolicy UnlimitedJCEPolicyJDK7.zip


echo -e "\n\n#### 3. Install Tomcat 6\n\n"
apt-get -y install tomcat6 tomcat6-admin
chown -R tomcat6:tomcat6 /etc/tomcat6


echo -e "\n\n#### 4. Install Taverna Server (2.4.1)\n\n"
wget -O /var/lib/tomcat6/webapps/taverna-server.war https://launchpad.net/taverna-server/2.x/2.4.1/+download/TavernaServer.2.4.1.war
cp -fR config/var/lib/tomcat6/conf/Catalina/localhost/* /var/lib/tomcat6/conf/Catalina/localhost/
service tomcat6 restart
echo "Waiting for Tomcat to unpack WAR files..."
while [ ! -d /var/lib/tomcat6/webapps/taverna-server/taverna-server ]
do
    echo "Waiting for Tomcat to unpack WAR files (10 secs)..."
    sleep 10
    service tomcat6 restart
done
service tomcat6 stop
cp -fR config/var/lib/tomcat6/webapps/taverna-server/WEB-INF/* /var/lib/tomcat6/webapps/taverna-server/WEB-INF/
chown -R tomcat6:tomcat6 /var/lib/tomcat6


echo -e "\n\n#### 5. Starting Tomcat Containers (AtomHopper & Taverna)\n\n"
service tomcat6 restart

echo -e "\n\n#### 6. Cleaning up\n\n"
apt-get -y remove unzip
apt-get -y autoremove && apt-get -y autoclean
apt-get -y clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*
