#!/bin/bash

cd "$(dirname "$0")"
cd ..
WORKSHOP_BASEDIR=$PWD

# Source the main setvars.sh script to get all the CFS environment variables
#cd ..
#source setvars.sh

# Install the prereqs
export DEBIAN_FRONTEND=noninteractive
sudo apt-get -y update
sudo apt-get -y install eclipse eclipse-cdt g++ g++-multilib git gitk openjdk-8-jdk cinnamon maven libc-bin libc-dev-bin libc6-dev rpm nodejs-legacy npm alien
sudo npm -g install bower gulp

# Install Oracle JDK 8
sudo apt-get install -y default-jre
sudo apt-get install -y default-jdk
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get -y update
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get install -y oracle-java8-installer
echo "export JAVA_HOME='/usr/lib/jvm/java-8-oracle'" >> ~/.bashrc
source ~/.bashrc


# Build YAMCS
cd ${WORKSHOP_BASEDIR}/yamcs
mvn -Dsurefire.useFile=false test
mvn install -DskipTests=true
./make-client-package.sh
./make-rpm.sh
sudo useradd -r yamcs
sudo alien -c ~/rpmbuild/RPMS/noarch/yamcs-*
sudo rm -Rf /opt/yamcs/cache /opt/yamcs/etc /opt/yamcs/log /opt/yamcs/mdb

# Build YAMCS Studio
#cd ${WORKSHOP_BASEDIR}/yamcs-studio
#ln -s ../yamcs yamcs
##mvn install -DskipTests -f yamcs/pom.xml
#sed "s#REPLACE_WITH_LOCAL_P2_REPO#"`pwd`/css/local_p2_repository"#" css/settings_template.xml >css/settings.xml
#mvn verify -f yamcs-studio-osgi/pom.xml -s css/settings.xml -Pcss-for-yamcs,travis
#mvn verify -f yamcs-studio-tycho/pom.xml -s css/settings.xml -Pcss-for-yamcs,travis

# Install YAMCS Studio
# sudo wget https://github.com/yamcs/yamcs-studio/releases/download/v1.0.0-beta.29/yamcs-studio-1.0.0-SNAPSHOT-linux.gtk.x86_64.tar.gz -O - | sudo tar -xz -C /opt
#sudo mv /opt/yamcs-studio-1.0.0-SNAPSHOT /opt/yamcs-studio

# Setup and build the softsim build
#${CFS_MISSION}/build/softsim/scripts/setup.sh
#${CFS_MISSION}/build/softsim/scripts/build.sh

