#!/bin/bash

cd "$(dirname "$0")"

# Source the main setvars.sh script to get all the CFS environment variables
cd ..
source setvars.sh

# Install the prereqs
sudo apt-get -y update
sudo apt-get -y install eclipse eclipse-cdt g++ g++-multilib git gitk openjdk-7-jdk

# Install YAMCS
sudo git clone --recursive ssh://git@bitbucket.windhoverlabs.com/scm/wor/yamcs.git /opt/yamcs

# Install YAMCS Studio
sudo wget https://github.com/yamcs/yamcs-studio/releases/download/v1.0.0-beta.29/yamcs-studio-1.0.0-SNAPSHOT-linux.gtk.x86_64.tar.gz -O - | sudo tar -xz -C /opt
sudo mv /opt/yamcs-studio-1.0.0-SNAPSHOT /opt/yamcs-studio

