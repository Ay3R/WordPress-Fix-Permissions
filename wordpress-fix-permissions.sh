#!/bin/bash
#
# This script configures WordPress file permissions based on recommendations
# from http://codex.wordpress.org/Hardening_WordPress#File_permissions
#
# Author: Michael Conigliaro with tweaks to make it faster and SE Linux by Jonathan Gittos
#
# check if this script has been called with a first parameter and use it as the wordpress root directory
[  -z "$1" ] && WP_ROOT=$PWD || WP_ROOT=$1
# check owner and group of wp-config and use later to give same to rest of WP DIR unless parameter 2 or 3 set
[  -z "$2" ] && WP_OWNER="$(ls -ld $WP_ROOT/wp-config.php | awk '{print $3}')" || WP_OWNER=$2
[  -z "$3" ] && WP_GROUP="$(ls -ld $WP_ROOT/wp-config.php | awk '{print $4}')" || WP_GROUP=$3

# Make sure we're in what looks like a WP directory to avoid big snafus

if [ ! -f $WP_ROOT/wp-config.php ]; then
    echo ""
    echo "--------------------------------------------"
    echo "This doesn't look like a Wordpress directory!"
    echo "Current or chosen directory is " $WP_ROOT
    echo "Maybe change directory, or specify a directory as a parameter to this script and try again?"
exit

fi

echo -e "\nAbout to reset permissions on:\n " $WP_ROOT
echo "Changing owner and group to:" $WP_OWNER $WP_GROUP

read -p "Does that look right? " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then

    echo -e "\nRestoring permissions on: " $WP_ROOT

# reset to safe defaults
chown -R ${WP_OWNER}:${WP_GROUP} $WP_ROOT;
chmod -R 644 $WP_ROOT;
chcon -R system_u:object_r:httpd_sys_content_t:s0 $WP_ROOT;
find ${WP_ROOT} -type d -exec chmod -R 755 {} \;

# allow wordpress to manage wp-config.php (but prevent world access)
chgrp ${WP_GROUP} ${WP_ROOT}/wp-config.php
chmod 660 ${WP_ROOT}/wp-config.php
chcon system_u:object_r:httpd_sys_rw_content_t:s0 ${WP_ROOT}/wp-config.php

# allow wordpress to manage .htaccess
touch ${WP_ROOT}/.htaccess
chgrp ${WP_GROUP} ${WP_ROOT}/.htaccess
chmod 664 ${WP_ROOT}/.htaccess
chcon system_u:object_r:httpd_sys_rw_content_t:s0 ${WP_ROOT}/.htaccess

# allow wordpress to manage wp-content
chmod -R 664 $WP_ROOT/wp-content;
chcon -R system_u:object_r:httpd_sys_rw_content_t:s0 $WP_ROOT/wp-content;
find ${WP_ROOT}/wp-content -type d -exec chmod -R 775 {} \;
echo -e "\nDoing it\n"

fi
