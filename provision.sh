echo "======================= provisioning start ============================"

echo "### disable SELinux ###"
sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config

echo "### Time Zone ###"
cp /etc/localtime /etc/localtime.bkup
cp /usr/share/zoneinfo/Japan /etc/localtime

echo "### add Repository ###"
rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

echo "### install Apache ###"
yum -y install httpd

echo "### install PHP ###"
yum install -y --enablerepo=remi-php55 php php-mcrypt php-mbstring php-pdo php-mysqlnd php-tokenizer php-xml

echo "### install MySQL ###"
yum -y install mysql-server

echo "### chkconfig Apache, MySQL ###"
mkdir /vagrant/html
cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bkup
sed -i 's#/var/www/html#/vagrant/html#g' /etc/httpd/conf/httpd.conf
sed -i 's/#ServerName www.example.com:80/ServerName 127.0.0.1/g' /etc/httpd/conf/httpd.conf

chkconfig httpd on
service httpd restart

chkconfig mysqld on
service mysqld restart

echo "### create vhost ###"
touch /etc/httpd/conf.d/vhosts.conf
echo "NameVirtualHost *:80" >> /etc/httpd/conf.d/vhosts.conf
echo "<VirtualHost *:80>" >> /etc/httpd/conf.d/vhosts.conf
echo "	ServerName vhost" >> /etc/httpd/conf.d/vhosts.conf
echo "	DocumentRoot /vagrant/lean_blog/public" >> /etc/httpd/conf.d/vhosts.conf
echo "	<Directory /vagrant/lean_blog/>" >> /etc/httpd/conf.d/vhosts.conf
echo "		Options All" >> /etc/httpd/conf.d/vhosts.conf
echo "		AllowOverride All" >> /etc/httpd/conf.d/vhosts.conf
echo "		Order allow,deny" >> /etc/httpd/conf.d/vhosts.conf
echo "		Allow from all" >> /etc/httpd/conf.d/vhosts.conf
echo "	</Directory>" >> /etc/httpd/conf.d/vhosts.conf
echo "</VirtualHost>" >> /etc/httpd/conf.d/vhosts.conf

echo "###  ###"
echo "start on vagrant-mounted" >> /etc/init/httpd.conf
echo "exec sudo service httpd start" >> /etc/init/httpd.conf

echo "### install Composer ###"
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
# composer self-update

echo "======================= provisioning finished ========================="
