# Install PHP 7.4 on Amazon Linux 2

```
sudo yum -y update
sudo yum -y install amazon-linux-extras
sudo amazon-linux-extras enable php7.4
sudo yum -y clean metadata
sudo yum -y install php-cli php-pdo php-fpm php-json php-mysqlnd
sudo yum -y install php-gd php-mbstring php-xml php-dom php-intl php-simplexml
php -v
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl start php-fpm
sudo systemctl enable php-fpm
```
