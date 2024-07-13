# Bonus for born2beroot project

## Install PHP

Run the following command:

```sh
sudo apt update && sudo apt upgrade && sudo apt install php
```

Also, install php-cgi and php-mysql to allow php to work with lighttpd:

```sh
sudo apt install php-cgi -y && sudo apt install php-mysql -y
```


## Uninstall Apache2

Apache2 might have been automatically installed during php installation. Remove it:

```sh
sudo apt purge apache2 && sudo apt autoremove
```

## Install lighttpd

Now it's time to install lighttpd

```sh
sudo apt install lighttpd
```

To test if everything is set up correctlym you should see no warning or error during the installation of lighttpd.

Also, add http to ufw

```sh
sudo ufw allow http
```

Go to your host webpage and type the IP address ```ip a``` of the guest on the browser with port ```80```. You should see the placeholder page of ```lighttpd```. This will work only if you have used the Bridged Network.

Otherwise, if you used the NAT, make sure to configure ```Port Forwarding``` and test accordingly.

### Lighttpd fast CGI

Before proceeding to the next step, we need to make sure that lighttpd will work with php:

```sh
sudo lighty-enable-mod fastcgi && sudo lighty-enable-mod fastcgi-php && sudo service lighttpd force-reload
```

To test php is working with lighttpd, create a file in /var/www/html named info.php. In that php file, write:

```php
<?php
phpinfo();
?>
```

Now go to your host browser and check if php information is displayed.

```sh
ip_address:port/info.php
```

## Install MariaDB

Time to install MariaDB

```sh
sudo apt install mariadb-server
```

Start, enable and check MariaDB status:

```sh
sudo systemctl start mariadb
sudo systemctl enable mariadb
systemctl status mariadb
```

Then do the MySQL secure installation to secure MariaDB:

```sh
sudo mysql_secure_installation
```

Answer the questions like so (root here does not mean root user of VM, it's the root user of the databases!):

```sh
Enter current password for root (enter for none): <Enter>
Switch to unix_socket authentication [Y/n]: Y
Set root password? [Y/n]: Y
New password: 101Asterix! (Set you root password for the database)
Re-enter new password: 101Asterix!
Remove anonymous users? [Y/n]: Y
Disallow root login remotely? [Y/n]: Y
Remove test database and access to it? [Y/n]:  Y
Reload privilege tables now? [Y/n]:  Y
```

Restart mariadb so the changes will take effect:

```sh
sudo systemctl restart mariadb
```

Test if mariadb works correctly:

```sh
mysql -u root -p
```

Enter the root password for database.

```sh
MariaDB [(none)]> CREATE DATABASE wordpress_db;
MariaDB [(none)]> CREATE USER 'login'@'localhost' IDENTIFIED BY 'WPpassw0rd';
MariaDB [(none)]> GRANT ALL ON wordpress_db.* TO 'login'@'localhost' IDENTIFIED BY 'WPpassw0rd' WITH GRANT OPTION;
MariaDB [(none)]> FLUSH PRIVILEGES;
MariaDB [(none)]> EXIT;
```

## Install Wordpress

### Tools required

Before installing WordPress correctly, we need two tools:

- First the ```wget``` tool to download from a web link.
- Second the ```tar``` tool to extract the compressed file we just downloaded.

```sh
sudo apt install wget
sudo apt install tar
```

### WordPress

Download latest version in ```.tar.gz``` format:

```sh
wget http://wordpress.org/latest.tar.gz
```

Extract the files:

```sh
tar {-xzvf | -xpzvf} latest.tar.gz
```

Move or copy files to ```/var/www/html/``` folder

```sh
sudo {cp | mv} wordpress/* /var/www/html/
```

Clean up

```sh
rm -rf latest.tar.gz wordpress/
```

### WP Configurations

Create the ```php``` configuration file:

```sh
sudo cp wp-config-sample.php wp-config.php
```

Edit the file

```sh
sudo nano wp-config.php
```

```php
define( 'DB_NAME','database_name_here');
define( 'DB_USER','username_here');
define( 'DB_PASSWORD','password_here');
define( 'DB_HOST','localhost');
```

Change owner and permission of html folder

```sh
sudo chown -R www-data:www-data /var/www/html && sudo chmod -R 755 /var/www/html
```

Run the ```localhost:8080``` on your host, and finish WordPress Setup.

You still have the possibility to modify your website further.
