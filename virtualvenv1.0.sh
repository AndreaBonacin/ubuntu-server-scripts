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

#echo -e "${Red}\nPip\n$Color_Off"
#sudo apt install python3-venv python3-pip -y


if [ $(whoami) = 'root' ]; then
    echo -e "$Red Don't run pip as root!!!$Color_Off"
	
else             
	echo ""
    echo -e "$Green      ██████╗ ██╗██████╗$Color_Off"  
    echo    "      ██╔══██╗██║██╔══██╗"
    echo -e "$Yellow      ██████╔╝██║██████╔╝$Color_Off"  
    echo    "      ██╔═══╝ ██║██╔═══╝" 
    echo -e "$Cyan      ██║     ██║██║$Color_Off"   
    echo    "      ╚═╝     ╚═╝╚═╝"
    echo ""
	
	echo -e "$PurpleB                                                                       $Color_Off"
	echo -e "$PurpleB ██ ███    ██ ███████ ████████  █████  ██      ██      ███████ ██████  $Color_Off"  
	echo -e "$PurpleB ██ ████   ██ ██         ██    ██   ██ ██      ██      ██      ██   ██ $Color_Off" 
	echo -e "$PurpleB ██ ██ ██  ██ ███████    ██    ███████ ██      ██      █████   ██████  $Color_Off" 
	echo -e "$PurpleB ██ ██  ██ ██      ██    ██    ██   ██ ██      ██      ██      ██   ██ $Color_Off" 
	echo -e "$PurpleB ██ ██   ████ ███████    ██    ██   ██ ███████ ███████ ███████ ██   ██ $Color_Off"
	echo -e "$PurpleB                                                                       $Color_Off\n\n"


	echo -e "${Green}Python Virtual Enviroments installer...$Color_Off"

	# Update packages
	#echo -e "$Cyan \nUpdating System.. $Color_Off"
	#apt update -y

	# Software selection
	#echo -e "$Cyan \nSoftware prerequisites.. $Color_Off"
	#apt install -y dialog wget software-properties-common zip unzip gzip

    echo -e "${Yellow}Upgrade Pip\n$Color_Off"
    python3 -m pip install --upgrade pip

    echo -e "${Yellow}Virtualenv\n$Color_Off"
    pip install virtualenv

	cmd=(dialog --separate-output --checklist "Please Select Software you want to install:" 22 76 16)
	options=(
			1 "Upgrade Pip (DANGER)" off    # any option can be set to default to "on"
            2 "Install Virtualenv (LESS DANGER)" off
            3 "Create enviroment" on
	        4 "Pip packages: numpy,pandas,matplotlib,etc (must create env)" off
	        #4 "MariaDB" off
	        #5 "MySQL - TBD" off
	        #6 "Git" off
			#7 "" off
	        #8 "" off
	       	#9 "Rsnapshot" off
	        #10 "Net tools" off
            #11 "Fish" off
			#12 "RabbitMQ" off
			#13 "Samba /var/www/" off
	)
		choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
		clear

		for choice in $choices
			do
				case $choice in
					1)
                        # Upgrade Pip
                        echo -e "\n\n${Green}Upgrading Pip...$Color_Off"
						python3 -m pip install --upgrade pip
						;;

					2)
						# Install Virtualenv
						echo -e "\n\n${Green}Installing virtualenv...$Color_Off"
						pip install virtualenv 
						;;
                    3)
						# Create enviroment folder
						echo -e "\n\n${Green}Virtualenv folder...$Color_Off"
						echo -e "${Yellow}Insert folder name (e.g 'Enviroments')$Color_Off" 
                        read FOLDERNAME
                        mkdir $FOLDERNAME && cd $FOLDERNAME

                        # Create enviroment
                        echo -e "\n\n${Green}Creating enviroment...$Color_Off"
                        echo -e "${Yellow}Insert env name (e.g 'myproject_env')$Color_Off" 
                        read ENVNAME
                        virtualenv $ENVNAME

						# Change enviroment
						echo -e "\n\n${Green}Changing enviroment...$Color_Off"
                        source ${ENVNAME}/bin/activate
                        echo -e "\n\n${Green}Which python..$Color_Off"
                        which python3
						;;

                    4)
						# Pip packages
						echo -e "\n\n${Green}Installing Pip packages...$Color_Off"
                        pip install simpy
						;;

	        	esac
	 		done

	# Postinstall	
	echo -e "$Cyan \nPip list...$Color_Off"
	pip list

    echo -e "$Green \nGenerating requirements.txt...$Color_Off"
	pip freeze --local > requirements.txt


    # Helper	
    echo -e "$Red \n\nDon't move ${FOLDERNAME} into projects!!!!!!!!!$Color_Off"
    echo -e "$Yellow However move requirements.txt into your project$Color_Off"
    echo -e "$Cyan \ncd ${FOLDERNAME} && source ${ENVNAME}/bin/activate$Color_Off for activate$Cyan \ndeactivate$Color_Off for deactivate"	

fi

