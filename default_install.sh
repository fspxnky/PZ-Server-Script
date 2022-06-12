#!/bin/bash

# Start of Script 

# Check if its run by root
# If not, exit the script
if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root" 1>&2
        exit 1
fi

# Script Message :)
clear
echo "==== WELCOME TO MY PROJECT ZOMBOID SERVER INSTALLATION SCRIPT ===="
echo "==== Script Created by: fspxnky ===="
echo "Please continue with the installation ONLY if this is a fresh install."
echo "Take note that this script does not do any firewall or security settings."
echo "If you hosting this server publicly, please do all the necessary security settings."
echo "The process of installing can be found here: https://pzwiki.net/wiki/Dedicated_Server"
echo "Press ENTER if you understand and wish to continue."
echo "If not, press CTRL+C to cancel the installation."
read

echo "Installation will start now :)"; sleep 2
echo " "

# Check if system is 64 bit
# If yes, install package and continue with installation
# If no, exit installation
echo "==== Checking system architecture ===="; sleep 1
if (uname -m | grep -q 'x86_64')
then
        echo "System is 64 bit :)"
        echo "Installing packages and steamCMD."
        dpkg --add-architecture i386
        apt update; apt install steamcmd -y
        echo "Done!"; sleep 2
        echo " "
else
        echo "Sorry man, your system is not 64 bit ..."
        echo "Exiting script :("
        exit 1
fi

# Add new user called pzuser for the server
echo "==== Creating new user for the installation ===="; sleep 1
echo "Creating user called 'pzuser'."
useradd -m pzuser
chsh pzuser -s /bin/bash
echo "If you are hosting this server publicly, please use a stronger password."
echo "Please enter a password for pzuser"
read -p "Password: " password
chpasswd <<< "pzuser:$password"
echo "Account creation, done!"; sleep 1
echo " "

echo "==== Creating server directory ===="
mkdir /opt/pzserver
echo "Created a folder in /opt directory"
/bin/ls -l /opt | grep pzserver; sleep 2
echo " "

echo "==== And changing owner rights for pzuser ===="
chown pzuser:pzuser /opt/pzserver
echo "Change directory rights from root to pzuser"
/bin/ls -l /opt | grep pzserver; sleep 2
echo " "

echo "==== Installing Project Zomboid Server as pzuser ===="
su pzuser -c 'cd /home/pzuser; wget https://raw.githubusercontent.com/fspxnky/PZ-Server-Script/main/update_zomboid.txt; steamcmd +runscript /home/pzuser/update_zomboid.txt'
echo " " 
echo "Installation Complete!"; sleep 2
echo " "

echo "==== WHAT TO DO NEXT ===="
echo "To start the server, type: bash /opt/start-server.sh"
echo "To change the name of the server, type: bash /opt/start-server.sh --servername <ENTER UR SERVERNAME HERE>"
echo "You will need to give a admin password for the game when you start the server for the first time."
echo "The server is live when you see the 'Zomboid Server is VAC Secure'."
echo "If you want to stop the Game Server, simply press CTRL+C."
echo "If you want to run the Game Server background, try to run the Game Server with screen."
echo ""

echo "HAPPY SURVIVING WITH YOUR FRIENDS OR ... ALONE!"
echo "Press enter to exit ...."
read

# End of Script 
