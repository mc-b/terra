#!/bin/bash -x

export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true

apt install -y apache2 php libapache2-mod-php php-mysql adminer

a2enconf adminer
systemctl restart apache2

cat <<EOF >/var/www/html/index.php
<?php echo '<p>Hallo ich bin eine PHP Datei</p>'; ?>
EOF
     
