#!/bin/sh

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -

# FOR STABLE JENKINS VERSION RUN:
sudo apt-add-repository "deb https://pkg.jenkins.io/debian-stable binary/"
# FOR LATEST JENKINS VERSION RUN:
#sudo apt-add-repository "deb http://pkg.jenkins-ci.org/debian binary/"

sudo apt update -qq
sudo apt install -y -qq jenkins

echo "Initial Password for Jenkins"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# configuration: .etc.defaults/jenkins
#HTTP_PORT=8080
#JENKINS_HOME=/var/lib/$NAME
