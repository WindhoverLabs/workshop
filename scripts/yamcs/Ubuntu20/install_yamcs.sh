#!/bin/sh

export YAMCS_VERSION=5.1.4

#Install YAMCS on Ubuntu

#Get dependencies
apt update
apt-get install -y openjdk-8-jdk
apt-get install -y default-jre
apt-get install -y maven


# Install YAMCS
cd ${WORKSPACE}
wget https://github.com/yamcs/yamcs/releases/download/yamcs-${YAMCS_VERSION}/yamcs-${YAMCS_VERSION}-1.x86_64.rpm
useradd -r yamcs
alien --scripts -i yamcs-${YAMCS_VERSION}-1.x86_64.rpm

# Run  YAMCS Server


#
#sudo chown -R root:root /opt/yamcs
#sudo rm -Rf /opt/yamcs/cache
#sudo rm -Rf /opt/yamcs/etc/*
#sudo cp yamcs/* /opt/yamcs/etc/
#sudo rm -Rf /opt/yamcs/log
#sudo rm -Rf /opt/yamcs/mdb
#rm yamcs-${YAMCS_VERSION}-1.x86_64.rpm
