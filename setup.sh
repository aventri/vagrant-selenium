#!/bin/sh

timedatectl set-timezone America/New_York

# ubuntu/xenial64 box username is ubuntu and password is a random string, so at least set the password to something logical
# See https://bugs.launchpad.net/cloud-images/+bug/1569237
echo "ubuntu:ubuntu" | chpasswd

echo "Installing packages..."
/vagrant/setup-packages.sh > /vagrant/install_log 2>&1

echo "Installing applications..."
/vagrant/setup-apps.sh >> /vagrant/install_log 2>&1

echo "Done"
