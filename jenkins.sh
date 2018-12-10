#!/bin/sh

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -

# FOR STABLE JENKINS VERSION RUN:
sudo apt-add-repository "deb https://pkg.jenkins.io/debian-stable binary/"
# FOR LATEST JENKINS VERSION RUN:
#sudo apt-add-repository "deb http://pkg.jenkins-ci.org/debian binary/"

sudo apt-get install jenkins

echo "Initial Password for Jenkins"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
