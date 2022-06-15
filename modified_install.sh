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
echo " "
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
        echo " "
        echo "Done!"; sleep 2
        echo " "
else
        echo "Sorry man, your system is not 64 bit ..."
        echo "Exiting script :("
        exit 1
fi

# Add new user called pzuser for the server
echo "==== Creating pzuser for the installation ===="; sleep 3
echo "Creating user called 'pzuser'."
useradd -m pzuser
chsh pzuser -s /bin/bash
echo "If you are hosting this server publicly, please use a stronger password."
echo "Please enter a password for pzuser"
read -p "Password: " password
chpasswd <<< "pzuser:$password"
echo "Account creation, done!"; sleep 3
echo " "

echo "==== Creating server directory ===="
mkdir /opt/pzserver
echo "Created a folder in /opt directory"
/bin/ls -l /opt | grep pzserver; sleep 3
echo " "

echo "==== And changing owner rights for pzuser ===="
chown pzuser:pzuser /opt/pzserver
echo "Change directory rights from root to pzuser"
/bin/ls -l /opt | grep pzserver; sleep 3
echo " "

echo "==== Configuration for server to run under system.d ===="
wget https://raw.githubusercontent.com/fspxnky/PZ-Server-Script/main/zomboid.service
mv zomboid.service /usr/lib/systemd/system/
systemctl enable zomboid.service

echo "==== Installing Project Zomboid Server as pzuser ===="
su pzuser -c 'cd /home/pzuser; wget https://raw.githubusercontent.com/fspxnky/PZ-Server-Script/main/update_zomboid.txt; steamcmd +runscript /home/pzuser/update_zomboid.txt'
su pzuser -c 'cd /home/pzuser; wget https://raw.githubusercontent.com/fspxnky/PZ-Server-Script/main/command-available.txt'
clear
echo "Installation Complete!"; sleep 3
echo " "

echo "For running the server for the first time, type: bash /opt/start-server.sh"
echo "To change the name of the server, type: bash /opt/start-server.sh --servername <ENTER UR SERVERNAME HERE>"
echo "MAKE SURE TO RUN THE GAME AS PZUSER AND NEVER AS ROOT OR ANY USER THAT HAVE SUDO ALL RIGHTS"
echo " "
echo "You will need to give a admin password for the game when you start the server for the first time."
echo " "
echo "The server is live when you see the 'Zomboid Server is VAC Secure'."
echo "Stop the Game Server by simply pressing CTRL+C."
echo "And reboot your machine!"
echo "After a reboot, check the game server by using the journalctl command"
echo "All the helpful commands I have downloaded for you. View the file for more info."

echo "HAPPY SURVIVING WITH YOUR FRIENDS OR ... ALONE!"
# End of Script
