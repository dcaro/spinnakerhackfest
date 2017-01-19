#!/bin/bash

sudo sh -c "cd /opt && mkdir -p aptly && cd aptly && pwd;wget https://dl.bintray.com/smira/aptly/0.9.5/debian-squeeze-x64/aptly;"
sudo chown jenkins:jenkins aptly
sudo chmod +x aptly
