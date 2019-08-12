#!/bin/bash
#this is lite version of php switcher
#this tools switching version 5.6 to 7.2 or 7.2 to 5.6
if ! whoami | grep -q "root" ; then
	echo "Please run as root mas !" && exit
else echo "checking user [root]"
fi
if ! ls /var/www/html/ | grep -q "info.php" ; then
	cd /var/www/html
	touch info.php
echo "<?php
phpinfo();
?>" > info.php
fi
if ! ls /etc/apt/sources.list.d | grep -q "ondrej\|php"; then
	echo "checking sources php [not found !]"
	echo "adding ppa ondrej php"
	add-apt-repository ppa:ondrej/php -y
else echo "checking sources php [`ls /etc/apt/sources.list.d | grep "ondrej" `]"
fi

MSG_CAUTION() {
whiptail --title "[ $TITLE ]" --msgbox "$MSGBOX" 15 70
}
MSG_INPUT() {
input=$(whiptail --title "[ $TITLE ]" --no-button "Exit" --inputbox "$MSGBOX" 10 60 3>&1 1>&2 2>&3) 
inputquit=$?
if ! [ $inputquit = 0 ]; then
    exit
fi
}

if ! command -v curl ; then
	apt install curl
fi
PHP_SEKARANG() {
	curl -S http://localhost/info.php 2>/dev/null | grep "PHP Version" | tail -n1
}
PHP5.6() {
	if ! command -v php5.6 ; then
		echo "php5.6 is not installed, this tools will install it automatic ..."
		apt install php5.6 -y
		echo "switching php to ver 5.6 ..." 
		a2dismod php7.2 ; a2enmod php5.6 ; service apache2 restart
		TITLE="php5.6"
		MSGBOX="DONE!" && MSG_CAUTION
	elif echo "$PHP56" | grep -q "aktif" ; then
		TITLE="php5.6"
		MSGBOX="PHP nya sudah aktif bujank" && MSG_CAUTION
	else echo "switching php to ver 5.6 ..." 
		a2dismod php7.2 ; a2enmod php5.6 ; service apache2 restart
		TITLE="php5.6"
		MSGBOX="DONE!" && MSG_CAUTION
	fi

}
PHP7.2() {
	if ! command -v php7.2 ; then
		echo "php7.2 is not installed, this tools will install it automatic ..."
		apt install php7.2 -y
		echo "switching php to ver 7.2 ..." 
		a2dismod php5.6 ; a2enmod php7.2 ; service apache2 restart
		TITLE="php7.2"
		MSGBOX="DONE!" && MSG_CAUTION
	elif echo "$PHP72" | grep -q "aktif" ; then
		TITLE="php7.2"
		MSGBOX="PHP nya sudah aktif bujank" && MSG_CAUTION
	else echo "switching php to ve7.5.2 ..." 
		a2dismod php5.6 ; a2enmod php7.2 ; service apache2 restart
		TITLE="php7.2"
		MSGBOX="DONE!" && MSG_CAUTION
	fi

}

PHP72="Tidak digunakan (OFF)"
PHP56="Tidak digunakan (OFF)"

	if PHP_SEKARANG | grep -q "7.2" ;then
		PHP72="Sedang aktif (ON)"
	elif PHP_SEKARANG | grep -q "5.6" ;then
		PHP56="Sedang aktif (ON)"	
	fi


TITLE="welcome to phpsw lite"
MSGBOX="this is php switcher for php v5.6 to 7.2 or otherwise
this tools only work for Ubuntu + Apache2 Webserver" && MSG_CAUTION
while true
do
clear
menu=$(whiptail --title "[ Menu ]" --cancel-button "exit" --menu "Choose version : " 15 60 6 \
"php5.6" "${PHP56}" \
"php7.2" "${PHP72}" 3>&1 1>&2 2>&3)
#check array data
quitmenu=$?

if ! [[ $quitmenu = 0 ]]; then
	exit
else
	case $menu in
		 php5.6)PHP5.6 && exit
			;;
		 php7.2)PHP7.2 && exit
			;;
	esac
fi
done