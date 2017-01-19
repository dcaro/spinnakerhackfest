#!/bin/bash

sudo su - jenkins
cd ~
sudo apt-key adv --keyserver keys.gnupg.net --recv-keys 9E3E53F19C7DE460
apt-get update
apt-get install aptly
