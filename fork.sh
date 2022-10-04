#! /bin/bash

# Print dei passaggi da fare per forkare un progetto su Github

Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Cyan='\033[0;36m'         # Cyan
Color_Off='\033[0m'       # Text Reset

echo -e "${Red}\nPrint dei passaggi da fare per forkare un progetto su Github\n$Color_Off"

echo -e "${Green}STEP 1: Fork$Color_Off"
echo -e "Forka da github.com\n"

echo -e "${Yellow}STEP 2: Pull Request$Color_Off"
echo -e "git remote add upstream https://github.com/Ptah-engineering/<repo>.git"
echo -e "git remote -v\n"

echo -e "${Cyan}STEP 3: Pull da upstream$Color_Off"
echo -e "git fetch upstream"
echo -e "git merge upstream/master"