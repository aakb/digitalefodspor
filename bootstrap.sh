#!/usr/bin/env bash

# Set timezone.
echo "Setting up timezone..."
echo "Europe/Copenhagen" > /etc/timezone
/usr/sbin/dpkg-reconfigure --frontend noninteractive tzdata > /dev/null 2>&1

# Set locale
echo "Setting up locale..."
echo en_GB.UTF-8 UTF-8 > /etc/locale.gen
echo en_DK.UTF-8 UTF-8 >> /etc/locale.gen
echo da_DK.UTF-8 UTF-8 >> /etc/locale.gen
/usr/sbin/locale-gen > /dev/null 2>&1
export LANGUAGE=en_DK.UTF-8 > /dev/null 2>&1
export LC_ALL=en_DK.UTF-8 > /dev/null 2>&1
/usr/sbin/dpkg-reconfigure --frontend noninteractive locales > /dev/null 2>&1

# Add dotdeb
cat > /etc/apt/sources.list.d/dotdeb.list <<DELIM
deb http://packages.dotdeb.org wheezy all
deb-src http://packages.dotdeb.org wheezy all

deb http://packages.dotdeb.org wheezy-php55 all
deb-src http://packages.dotdeb.org wheezy-php55 all
DELIM
wget http://www.dotdeb.org/dotdeb.gpg > /dev/null 2>&1
apt-key add dotdeb.gpg  > /dev/null 2>&1
rm dotdeb.gpg
apt-get update > /dev/null 2>&1

# APT
echo "Updating system (apt)..."
apt-get update > /dev/null 2>&1
apt-get upgrade > /dev/null 2>&1

# Apache config
echo "Configuring Apache..."
apt-get -y install git php5-mysql libapache2-mod-php5 php5-gd php-db apache2 php5-curl php5-dev php5-xdebug > /dev/null 2>&1
rm -rf /var/www
ln -s /vagrant/htdocs/output_dev /var/www
sed -i '/AllowOverride None/c AllowOverride All' /etc/apache2/sites-available/default
sed -i '/export APACHE_RUN_USER=www-data/c export APACHE_RUN_USER=vagrant' /etc/apache2/envvars
sed -i '/export APACHE_RUN_GROUP=www-data/c export APACHE_RUN_GROUP=vagrant' /etc/apache2/envvars
sed -i '/memory_limit = 128M/c memory_limit = 512M' /etc/php5/apache2/php.ini
chown vagrant:vagrant /var/lock/apache2
a2enmod rewrite > /dev/null 2>&1
a2enmod php5 > /dev/null 2>&1
a2enmod expires > /dev/null 2>&1

# PHP5
echo "Installing php"
apt-get install -y php5-fpm php5-cli php5-xdebug php5-mysql php5-curl php5-gd git > /dev/null 2>&1

# Configure PHP
sed -i '/;listen.owner = www-data/c listen.owner = vagrant' /etc/php5/fpm/pool.d/www.conf
sed -i '/;listen.group = www-data/c listen.group = vagrant' /etc/php5/fpm/pool.d/www.conf
sed -i '/;listen.mode = 0660/c listen.mode = 0660' /etc/php5/fpm/pool.d/www.conf
sed -i '/memory_limit = 128M/c memory_limit = 256M' /etc/php5/fpm/php.ini

cat << DELIM >> /etc/php5/mods-available/xdebug.ini
xdebug.remote_enable=1
xdebug.remote_handler=dbgp
xdebug.remote_host=192.168.50.1
xdebug.remote_port=9000
xdebug.remote_autostart=0
xdebug.max_nesting_level=500
DELIM

pecl install uploadprogress > /dev/null 2>&1

# Mysql
echo "Installing MySQL..."
debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password vagrant' > /dev/null 2>&1
debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password vagrant' > /dev/null 2>&1
apt-get install -y mysql-server > /dev/null 2>&1

# Configure MySQL
echo "Configuring MySQL..."
cat > /etc/mysql/conf.d/innodb.cnf <<DELIM
[mysqld]
innodb_buffer_pool_size=256M
innodb_flush_method=O_DIRECT
innodb_additional_mem_pool_size=10M
innodb_flush_log_at_trx_commit=0
innodb_thread_concurrency=6
DELIM

# NodeJS
echo "Installing nodejs"
apt-get install -y python-software-properties python redis-server > /dev/null 2>&1
add-apt-repository ppa:chris-lea/node.js -y > /dev/null 2>&1
sed -i 's/wheezy/lucid/g' /etc/apt/sources.list.d/chris-lea-node_js-wheezy.list
apt-get update > /dev/null 2>&1
apt-get install -y nodejs > /dev/null 2>&1

# Added gulp.
echo "Addeding gulp"
npm install -g gulp gulp-concat gulp-uglify gulp-sass gulp-jshint jshint-stylish gulp-rename gulp-sourcemaps gulp-notify gulp-util gulp-header gulp-if gulp-ng-annotate browser-sync gulp-shell

# Added sculpin
echo "Adding Sculpin"
curl -O https://download.sculpin.io/sculpin.phar
chmod +x sculpin.phar
mv sculpin.phar /usr/local/bin/sculpin

# Restart services
echo "Restarting services..."
service apache2 restart > /dev/null 2>&1
service mysql restart > /dev/null 2>&1
service memcached restart > /dev/null 2>&1

echo "Provisioning completed..."
