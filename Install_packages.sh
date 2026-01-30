#!/bin/bash

# -------------------------------------------------
# Script Name : install_packages.sh
# Author      : Neelima Thumma
# Description : This script will install the packages passed as arguments
# -------------------------------------------------

USER_ID=$(id -u)
LOGS_FOLDER="/var/log/learn-shell"
LOGS_FILE="$LOGS_FOLDER/$0.log"

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
#Checking for root user
if [ $USER_ID -ne 0 ] ; then
    echo -e "$R You should run this script as root user $N"
    exit 1
fi  
# Checks if Directory exists else creates the directory
mkdir -p $LOGS_FOLDER

# Function to check the status of the previous command
validate() {
    if [$1 -ne 0 ] ; then
        echo -e "$R FAILURE $N" | tee -a $LOGS_FILE
        echo "Refer the log file $LOGS_FILE for more information" 
        exit 1
    else
        echo -e "$G SUCCESS $N" | tee -a $LOGS_FILE
    fi
}

# Loop to iterate through all the packages passed as arguments
for package in $@
do
    dnf list installed $package &>>$LOGS_FILE
    if [ $? != 0 ] ; then
        echo "$package is not installed" | tee -a $LOGS_FILE
        dnf install $package -y &>> $LOGS_FILE
        validate $? "Installing $package " | tee -a $LOGS_FILE
    else
        echo "$package is already installed"  | tee -a $LOGS_FILE
    fi
done

# End of the script