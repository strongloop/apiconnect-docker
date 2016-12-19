#!/bin/bash -xe

if [ ! -f /keys/portal ] ; then
  ssh-keygen -f /keys/portal -t rsa -C 'apim_advanced_portal_ssh_key' -N ''
fi

if [ ! -f /keys/microgw ] ; then
  ssh-keygen -f /keys/microgw -t rsa -b 4096 -N ''
  openssl rsa -in /keys/microgw -pubout  > /keys/microgw.pub 
fi

chown 1000:1000 -R /keys
