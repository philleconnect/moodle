#!/bin/bash

echo 'waiting 30s to give the database-container a chance to be all up...'
sleep 30s

chown www-data:www-data -R /var/www/moodledata
chmod =700 -R /var/www/moodledata

echo 'setting up moodle'
sudo -u www-data /usr/bin/php /var/www/moodle/admin/cli/install.php \
    --lang=de \
    --wwwroot='http://localhost:90' \
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
