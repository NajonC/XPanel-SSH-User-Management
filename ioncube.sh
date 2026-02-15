uname=$(uname -i)
if [[ $uname == x86_64 ]]; then
wget -4 https://storage.filebin.net/filebin/4de3d7c15a596e81abd8e605d2fcb3f70ad50a4621b877e032c178c153bc605b?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=GK352fd2505074fc9dde7fd2cb%2F20260215%2Fhel1-dc4%2Fs3%2Faws4_request&X-Amz-Date=20260215T181424Z&X-Amz-Expires=7200&X-Amz-SignedHeaders=host%3Bx-forwarded-for&response-cache-control=max-age%3D7200&response-content-disposition=inline%3B%20filename%3D%22ioncube_loaders_lin_x86-64.tar.gz%22&response-content-type=application%2Fgzip&x-id=GetObject&X-Amz-Signature=fb86f1dab17dab9353adce8e1a7a5fe360291e6d668db8a88d272d16502ca4c2
sudo tar xzf ioncube_loaders_lin_x86-64.tar.gz -C /usr/local
sudo rm -rf ioncube_loaders_lin_x86-64.tar.gz
fi
if [[ $uname == aarch64 ]]; then
wget -4 https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_aarch64.tar.gz
sudo tar xzf ioncube_loaders_lin_aarch64.tar.gz -C /usr/local
sudo rm -rf ioncube_loaders_lin_aarch64.tar.gz
fi
PHPVERSION=$(php -i | grep /.+/php.ini -oE | sed 's/[^0-9.]*//g')

echo "zend_extension = /usr/local/ioncube/ioncube_loader_lin_${PHPVERSION}.so" > /etc/php/${PHPVERSION::-1}/fpm/conf.d/00-ioncube.ini
echo "zend_extension = /usr/local/ioncube/ioncube_loader_lin_${PHPVERSION}.so" > /etc/php/${PHPVERSION::-1}/cli/conf.d/00-ioncube.ini

PHP_INI_PATH="/etc/php/8.1/fpm/php.ini"
ZEND_EXTENSION_PATH="/usr/local/ioncube/ioncube_loader_lin_8.1.so"
grep -q "^zend_extension" $PHP_INI_PATH && sed -i "s@^zend_extension.*@zend_extension = $ZEND_EXTENSION_PATH@" $PHP_INI_PATH || echo "zend_extension = $ZEND_EXTENSION_PATH" >> $PHP_INI_PATH
sudo systemctl restart php8.1-fpm
systemctl restart nginx
