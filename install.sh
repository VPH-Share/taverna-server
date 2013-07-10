#!/bin/bash

if [ "$EUID" -ne "0" ] ; then
  echo "Script must be run as root." >&2
  exit 1
fi

if [ -d /var/lib/tomcat6/webapps/taverna-server ]
then
  echo "You already have Taverna Server installed. You'll need to remove Taverna Server if you want to install"
  exit
fi

# Get taverna-server repository
wget https://github.com/susheel/taverna-server/archive/master.zip
unzip master.zip
cd taverna-server-master

./bootstrap.sh 2>&1 | tee ~/taverna-install.log
