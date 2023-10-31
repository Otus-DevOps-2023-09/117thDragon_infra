#!/bin/sh

echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
apt-get update
apt-get install -y ruby-full ruby-bundler build-essential
