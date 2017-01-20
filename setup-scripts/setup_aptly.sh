#!/bin/bash
WORKDIR="/opt"

sudo sh -c "cd $WORKDIR && mkdir -p aptly && cd aptly && pwd;wget https://dl.bintray.com/smira/aptly/0.9.5/debian-squeeze-x64/aptly;"
sudo chown jenkins:jenkins $WORKDIR/aptly/aptly
sudo chmod +x $WORKDIR/aptly/aptly
