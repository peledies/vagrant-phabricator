#!/bin/bash

build_log=/home/ubuntu/build.log

echo -e "\n===========================\n=== Provisioning PHP 7.1 ===\n===========================\n"

echo -e "\n--- Adding ondrej Apt Repository ---\n"
  add-apt-repository ppa:ondrej/php -y >> $build_log 2>&1

echo -e "\n--- Updating packages list ---\n"
  apt-get -qq update

echo -e "\n--- Removing PHP 7.0 ---\n"
  apt-get remove php7.0 --purge -y >> $build_log 2>&1

echo -e "\n--- Installing Common PHP Server Dependencies ---\n"
  apt install libapache2-mod-php php7.1 php-curl php-mysql php-mcrypt php-gd php-mbstring php-zip php7.1-simplexml -y >> $build_log 2>&1
