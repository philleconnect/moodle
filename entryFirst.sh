#!/bin/bash

echo 'waiting 30s to give the database-container a chance to be all up...'
sleep 30s

chown www-data:www-data -R /var/www/moodledata
chmod =755 -R /var/www/moodledata

echo 'setting up moodle'
sudo -u www-data /usr/bin/php /var/www/moodle/admin/cli/install.php \
    --lang=en \
    --wwwroot=$MOODLE_WEB_URL \
    --dataroot=/var/www/moodledata \
    --dbtype=mariadb \
    --dbhost=moodle_db \
    --dbname=moodle \
    --dbuser=moodle \
    --dbpass=$MYSQL_PASSWORD \
    --dbport=3306 \
    --fullname='PhilleConnect-Moodle' \
    --shortname='moodle' \
    --summary='PhilleConnectMoodle auf dem Schulserver' \
    --adminuser='admin' \
    --adminpass=$MOODLE_ADMIN_PASSWORD \
    --adminemail=$MOODLE_ADMIN_EMAIL \
    --non-interactive \
    --agree-license

#sed -i "/^\$CFG->directorypermissions.*/a \$CFG->dirroot   = '/var/www/moodle';" /var/www/moodle/config.php
echo 'configuring moodle for reverseproxy or ssl-proxy if configured'
if [ $MOODLE_REVERSEPROXY = true ]; then
    sed -i '/^\$CFG->directorypermissions.*/a \$CFG->reverseproxy = true;' /var/www/moodle/config.php
elif [ $MOODLE_SSLPROXY = true ]; then
    sed -i '/^\$CFG->directorypermissions.*/a \$CFG->sslproxy = true;' /var/www/moodle/config.php
fi

echo 'finished setting up moodle, starting'
