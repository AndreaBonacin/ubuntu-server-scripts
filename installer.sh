#! /bin/bash

#COLORS
# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
PurpleB='\033[45m'        # Purple Background

Bold='\0033[1'


if [ $(whoami) = 'root' ]; then

	# Params
	if [[ -z $1 ]];
	then 
		echo "user parameter missing..."
		exit
	fi

	if [[ -z $2 ]];
	then 
		echo "distro name missing..."
		exit
	fi

	# If user exists..
	if id "$1" &>/dev/null; then





		echo ""
		echo -e "$Green		██╗      █████╗ ███╗   ███╗██████╗ $Color_Off"
		echo "		██║     ██╔══██╗████╗ ████║██╔══██╗" 
		echo -e "$Yellow		██║     ███████║██╔████╔██║██████╔╝$Color_Off" 
		echo "		██║     ██╔══██║██║╚██╔╝██║██╔═══╝ " 
		echo -e "$Cyan		███████╗██║  ██║██║ ╚═╝ ██║██║ $Color_Off"
		echo "		╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝" 
		echo ""
		echo -e "$PurpleB                                                                       $Color_Off"
		echo -e "$PurpleB ██ ███    ██ ███████ ████████  █████  ██      ██      ███████ ██████  $Color_Off"  
		echo -e "$PurpleB ██ ████   ██ ██         ██    ██   ██ ██      ██      ██      ██   ██ $Color_Off" 
		echo -e "$PurpleB ██ ██ ██  ██ ███████    ██    ███████ ██      ██      █████   ██████  $Color_Off" 
		echo -e "$PurpleB ██ ██  ██ ██      ██    ██    ██   ██ ██      ██      ██      ██   ██ $Color_Off" 
		echo -e "$PurpleB ██ ██   ████ ███████    ██    ██   ██ ███████ ███████ ███████ ██   ██ $Color_Off"
		echo -e "$PurpleB                                                                       $Color_Off\n\n"


		echo -e "${Green}Adapa web server installer...$Color_Off"

		# Update packages
		echo -e "$Cyan \nUpdating System.. $Color_Off"
		apt update -y

		# Software selection
		echo -e "$Cyan \nSoftware prerequisites.. $Color_Off"
		apt install -y dialog wget software-properties-common zip unzip gzip

		cmd=(dialog --separate-output --checklist "Please Select Software you want to install:" 22 76 16)
		options=(
				1 "PHP (+ Apache)" on    # any option can be set to default to "on"
				2 "Postgres 12" off
				3 "MariaDB" off
				4 "Certbot (no snapd)" off
				5 "Git" off
				6 "Composer (needs PHP)" off
				7 "Symfony Cli" off
				8 "Rsnapshot" off
				9 "Net tools" off
				10 "Fish" off
				11 "RabbitMQ" off
				12 "Samba /var/www/" off
				13 "Supervisor" off
		)
			choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
			clear

			for choice in $choices
				do
					case $choice in
						1)
							# Find current version in order to disable apache/php version
							OUTPUT=$(php -v)
							apacheversion=${OUTPUT:4:3}


							
							# Install PHP
							echo -e "${Yellow}Select PHP version:$Color_Off"

							while true; do
								echo -e "Which PHP version do you wish to install?\n* 1) 7.0\n* 2) 7.4\n* 3) 8.0\n* 4) 8.1"
									read -p "	-->" choice
									case $choice in
										1 ) version='7.0'; break;;
										2 ) version='7.4'; break;;
										3 ) version='8.0'; break;;
										4 ) version='8.1'; break;;
										* ) echo -e "${Red}Please select a correct version...$Color_Off";;
									esac
							done


							echo -e "\n\n${Green}Installing PHP ${version}...$Color_Off"
							add-apt-repository ppa:ondrej/php
							add-apt-repository ppa:ondrej/apache2
							apt update -y && apt install -y php${version}
							apt install libapache2-mod-php${version}

							# Install LAMP requirements 	
							echo -e "\n\n${Green}Installing LAMP packages...$Color_Off"
							apt install -y php${version}-{cli,curl,gd,imap,dom,xml,zip,mbstring,pgsql,dev,mysql,fpm}
							php -m
							update-alternatives --set php /usr/bin/php${version}
							a2dismod php${apacheversion}
							a2enmod php${version}

							# /var/www permissions 
							echo -e "\n${Cyan}Permissions for /var/www as www-data:www-data$Color_Off"
							chown -R www-data:www-data /var/www/
							chgrp -R www-data /var/www/
							chmod -R 775 /var/www/
							usermod -a -G www-data ${1}
							usermod -a -G ${1} www-data
							echo -e "${Green}Permissions have been set $Color_Off"
							
							a2enmod rewrite && a2enmod headers
							mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.backup
							wget --user=bonuts91 --password=ciaomammaguardacomemidiverto  https://bonuts91.deimos.usbx.me/files/000-default.conf
							mv 000-default.conf /etc/apache2/sites-available/
							systemctl enable apache2
							;;

						2)
							# Install Postgres
							echo -e "\n\n${Green}Installing Postgres...$Color_Off"

							#todo: change pg_hba.conf and postgresql.conf

							# Create the file repository configuration:
							# Added [ arch=amd64 ] for Ubuntu 22.04
							sudo sh -c 'echo "deb [ arch=amd64 ] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

							# Import the repository signing key:
							wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

							# Update the package lists:
							sudo apt-get update

							echo -e "${Yellow}Select Postgres version:$Color_Off"

							while true; do
								echo -e "Which Postgres version do you wish to install?\n* 1) 12\n* 2) 13\n* 3) 14\n* 4) latest"
									read -p "	-->" choice
									case $choice in
										1 ) pg_version='postgresql-12'; break;;
										2 ) pg_version='postgresql-13'; break;;
										3 ) pg_version='postgresql-14'; break;;
										4 ) pg_version='postgresql'; break;;
										* ) echo -e "${Red}Please select a correct version...$Color_Off";;
									esac
							done

							echo -e "\n\n${Green}Installing ${pg_version}...$Color_Off"
							apt install -y ${pg_version} libpq-dev postgresql-client postgresql-client-common
							systemctl enable postgresql

							# Postgres users
							while true; do
								echo -e "${Yellow}Do you wish to install a postgres user?$Color_Off"
									read -p "-->" yn
									case $yn in
										[Yy]* ) sudo -u postgres createuser --interactive;;
										[Nn]* ) break;;
										* ) echo -e "${Red}Please answer yes or no.$Color_Off"
									;;
									esac
							done

							# Listen addresses

							systemctl restart postgresql 
							;;
						3)
							# Install MariaDB
							echo -e "\n\n${Green}Installing MariaDB...$Color_Off"
							apt install -y mariadb-server
							mysql_secure_installation
							;;


						4)	# Install Certbot
							apt install certbot python3-certbot-apache -y
							;;



						5)
							# Install git
							echo -e "\n\n${Green}Installing git...$Color_Off"
							apt install git -y
							git config --global credential.helper store
							;;
						
						6)
							# Install composer
							echo -e "\n\n${Green}Installing composer...$Color_Off"
							php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
							php composer-setup.php
							php -r "unlink('composer-setup.php');"
							mv composer.phar /usr/local/bin/composer
							;;
						
						7)
							# Install symfony-cli
							echo -e "\n\n${Green}Installing symfony...$Color_Off"
							curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | sudo -E bash
							sudo apt install symfony-cli
							;;
						
						8)
							# Install Rsnapshot
							echo -e "\n\n${Green}Installing Rsnapshot...$Color_Off"
							apt install rsnapshot -y
							wget --user=bonuts91 --password=ciaomammaguardacomemidiverto  https://bonuts91.deimos.usbx.me/files/rsnapshot.conf
							wget --user=bonuts91 --password=ciaomammaguardacomemidiverto  https://bonuts91.deimos.usbx.me/files/rsnapshot@.service
							wget --user=bonuts91 --password=ciaomammaguardacomemidiverto  https://bonuts91.deimos.usbx.me/files/rsnapshot-hourly.timer
							wget --user=bonuts91 --password=ciaomammaguardacomemidiverto  https://bonuts91.deimos.usbx.me/files/rsnapshot-daily.timer
							wget --user=bonuts91 --password=ciaomammaguardacomemidiverto  https://bonuts91.deimos.usbx.me/files/rsnapshot-weekly.timer
							wget --user=bonuts91 --password=ciaomammaguardacomemidiverto  https://bonuts91.deimos.usbx.me/files/rsnapshot-monthly.timer
							echo -e "${Green}Files has been copied$Color_Off"

							mv /etc/rsnapshot.conf /etc/rsnapshot.conf.backup
							mv rsnapshot.conf /etc/ 
							mv rsnapshot@.service /etc/systemd/system/
							mv rsnapshot-hourly.timer /etc/systemd/system/
							mv rsnapshot-daily.timer /etc/systemd/system/
							mv rsnapshot-weekly.timer /etc/systemd/system/
							mv rsnapshot-monthly.timer /etc/systemd/system/
							echo -e "${Green}Files has been moved$Color_Off"

							# Enable services
							echo -e "${Yellow}Do you wish to enabled hourly snapshots?$Color_Off"
								read -p "-->" yn
								case $yn in
									[Yy]* ) systemctl enable --now rsnapshot-hourly.timer;;
									[Nn]* ) ;;
									* ) echo -e "${Red}Please answer yes or no.$Color_Off"
								;;
								esac

							echo -e "${Yellow}Do you wish to enabled daily snapshots?$Color_Off"
								read -p "-->" yn
								case $yn in
									[Yy]* ) systemctl enable --now rsnapshot-daily.timer;;
									[Nn]* ) ;;
									* ) echo -e "${Red}Please answer yes or no.$Color_Off"
								;;
								esac

							echo -e "${Yellow}Do you wish to enabled weekly snapshots?$Color_Off"
								read -p "-->" yn
								case $yn in
									[Yy]* ) systemctl enable --now rsnapshot-weekly.timer;;
									[Nn]* ) ;;
									* ) echo -e "${Red}Please answer yes or no.$Color_Off"
								;;
								esac

							echo -e "${Yellow}Do you wish to enabled monthly snapshots?$Color_Off"
								read -p "-->" yn
								case $yn in
									[Yy]* ) systemctl enable --now rsnapshot-monthly.timer;;
									[Nn]* ) ;;
									* ) echo -e "${Red}Please answer yes or no.$Color_Off"
								;;
								esac
							
							;;
							
						9)
							# Install net-tools
							echo -e "\n\n${Green}Installing net-tools...$Color_Off"
							apt install net-tools -y
							;;

						10)
							# Install fish (mettere sudo !!)
							echo -e "\n\n${Green}Installing fish...$Color_Off"
							apt install fish -y
							# sudo !! command
							wget --user=bonuts91 --password=ciaomammaguardacomemidiverto  https://bonuts91.deimos.usbx.me/files/config.fish
							mv /etc/fish/config.fish /etc/fish/config.fish.backup
							mv config.fish /etc/fish/
							echo 'fish' >> /home/${1}/.bashrc
							;;

						11)
							# Install RabbitMQ
							echo -e "\n\n${Green}Installing RabbitMQ...$Color_Off"
							apt-get install curl gnupg apt-transport-https -y
							## Team RabbitMQ's main signing key
							curl -1sLf "https://keys.openpgp.org/vks/v1/by-fingerprint/0A9AF2115F4687BD29803A206B73A36E6026DFCA" | sudo gpg --dearmor | sudo tee /usr/share/keyrings/com.rabbitmq.team.gpg > /dev/null
							## Cloudsmith: modern Erlang repository
							curl -1sLf https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/gpg.E495BB49CC4BBE5B.key | sudo gpg --dearmor | sudo tee /usr/share/keyrings/io.cloudsmith.rabbitmq.E495BB49CC4BBE5B.gpg > /dev/null
							## Cloudsmith: RabbitMQ repository
							curl -1sLf https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-server/gpg.9F4587F226208342.key | sudo gpg --dearmor | sudo tee /usr/share/keyrings/io.cloudsmith.rabbitmq.9F4587F226208342.gpg > /dev/null

							## Add apt repositories maintained by Team RabbitMQ
							wget --user=bonuts91 --password=ciaomammaguardacomemidiverto  https://bonuts91.deimos.usbx.me/files/rabbitmq.list
							mv rabbitmq.list /etc/apt/sources.list.d/rabbitmq.list
							
							## Update package indices
							sudo apt-get update -y

							## Install Erlang packages
							sudo apt-get install -y erlang-base \
													erlang-asn1 erlang-crypto erlang-eldap erlang-ftp erlang-inets \
													erlang-mnesia erlang-os-mon erlang-parsetools erlang-public-key \
													erlang-runtime-tools erlang-snmp erlang-ssl \
													erlang-syntax-tools erlang-tftp erlang-tools erlang-xmerl

							## Install rabbitmq-server and its dependencies
							sudo apt-get install rabbitmq-server -y --fix-missing
							
							# Plugins
							sudo systemctl start rabbitmq-server
							
							sudo rabbitmq-plugins enable rabbitmq_management
							sudo rabbitmq-plugins enable rabbitmq_management_agent
							sudo rabbitmq-plugins enable rabbitmq_mqtt
							sudo rabbitmq-plugins enable rabbitmq_web_mqtt

							sudo rabbitmq-plugins list

							# User guest-guest seems to work only on localhost
							echo -e "${Yellow}Do you wish to add \"${1}\" as a RabbitMQ user?$Color_Off"
								read -p "-->" yn
								case $yn in
									[Yy]* ) echo "Enter Password : "
											read -s mypassword
											sudo rabbitmqctl add_user ${1} mypassword
											sudo rabbitmqctl set_user_tags ${1} administrator
											sudo rabbitmqctl set_permissions -p / ${1} ".*" ".*" ".*";;
									[Nn]* ) ;;
									* ) echo -e "${Red}Please answer yes or no.$Color_Off"
								;;
								esac

							# Rabbitmqadmin: CLI management
							echo -e "${Yellow}Do you wish install Rabbitmqadmin ?$Color_Off"
								read -p "-->" yn
								case $yn in
									[Yy]* ) #IPV4=$(hostname -I)
											#wget http://${IPV4}:15672/cli/rabbitmqadmin
											wget http://localhost:15672/cli/rabbitmqadmin
											cp rabbitmqadmin /usr/local/bin/
											chmod a+rx /usr/local/bin/rabbitmqadmin;;
									[Nn]* ) ;;
									* ) echo -e "${Red}Please answer yes or no.$Color_Off"
								;;
								esac



							;;

						12)
							# Install Samba
							echo -e "\n\n${Green}Installing Samba...$Color_Off"
							apt install samba -y
							# /var/www share
							wget --user=bonuts91 --password=ciaomammaguardacomemidiverto  https://bonuts91.deimos.usbx.me/files/smb.conf 
							mv /etc/samba/smb.conf /etc/samba/smb.conf.backup
							mv smb.conf /etc/samba/ 

							sudo service smbd restart
							sudo ufw allow samba
							sudo smbpasswd -a ${1}
							;;

						13)
							# Install Samba
							echo -e "\n\n${Green}Installing Supervisor...$Color_Off"
							apt install supervisor -y
							;;

					esac
				done
		# Postinstall	
		echo -e "$Cyan \nPost install...$Color_Off"
		apt update -y && apt autoremove -y && apt clean

	else
		echo 'user not found'
	fi
	
else
	echo 'Run the script as root!!!'
fi
