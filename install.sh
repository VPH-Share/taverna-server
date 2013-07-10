#!/bin/bash

REPO_URL="https://github.com/VPH-Share/taverna-server"
REPO_URL=${REPO_URL%/}                    # Remove trailing slash, if any
REPO_NAME=${REPO_URL##*/}
REPO_USER=${REPO_URL%/*}

if [ "$EUID" -ne "0" ] ; then
  echo "Script must be run as root." >&2
  exit 1
fi

# Check whether a command exists - returns 0 if it does, 1 if it does not
exists() {
  if command -v $1 &>/dev/null
  then
    return 0
  else
    return 1
  fi
}

if [ -d /var/lib/tomcat6/webapps/taverna-server ]
then
  echo "You already have Taverna Server installed. You'll need to remove Taverna Server if you want to install"
  exit
fi

# Get Repository
if exists wget; then
  wget $REPO_URL/archive/master.zip
  unzip master.zip
  LOCAL_REPO="$REPO_NAME-master"
elif exists git; then
  git clone $REPO_URL $REPO_NAME
  LOCAL_REPO=$REPO_NAME
else
  echo "Script requires:"
  echo " - wget and unzip; or"
  echo " - git"
  exit 1
fi

cd $LOCAL_REPO
./bootstrap.sh 2>&1 | tee ~/taverna-install.log
