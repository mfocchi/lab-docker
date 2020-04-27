#!/bin/bash

sudo apt-get install libxenomai1
sudo apt-get install libxenomai-dev
sudo apt-get install xenomai-runtime

sudo addgroup xenomai
sudo usermod -a -G xenomai dlsuser
sudo chown -R root:xenomai /usr/xenomai
