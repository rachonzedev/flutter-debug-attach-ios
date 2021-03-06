#!/bin/zsh

############################################################################################################################
# FOR INFO
# 
# This script build your flutter app in debugmode thanks to ios-deploy, and create a log file which will be watch by 
# the script geturldebug.sh to find the Observatory url.
# 
# Note : The app is desinstalled/installed in each time. 
#
#   /!\ This script need to be run from the root folder of your app,  and just after launching the script geturldebug.sh/!\
# 
#############################################################################################################################

#This file will contain the Observatory url we are looking for.
#FILETOPARSE=~/AndroidStudioProjects/PROD/custom_painter/logtee.txt
FILETOPARSE=./logtee.txt


#############################################################################################################################
#               Check if the script is launched from the root folder
#############################################################################################################################
PUBSPECFILE=pubspec.yaml
if [ -f "$PUBSPECFILE" ]; then
#if [ -f "$FILE" ]; then
    echo "  File $PUBSPECFILE found, continue...";
    sleep 2
else
  
    echo ""
    echo "  \033[0;31m--------------------------------------------- /!\ ERROR ! /!\ ---------------------------------------------------\033[0m";
    echo "  File $PUBSPECFILE not found ! ";
    echo ""  
    echo "\033[1;36m  /!\ This script need to be run from the root folder of your app. /!\\ \033[0m";
    echo "";
    echo "  The program will exit..."
    echo "";
    exit 1;
fi

#############################################################################################################################
#               Check if the first script (the watcher) is running from the root folder of your app
#############################################################################################################################
# Name of the first script (the watcher)
SCRIPT_WATCHER=geturldebug.sh
#Check if the first script has been  launched
STATUS_OF_SCRIPT_WATCHER=$(pgrep -f $SCRIPT_WATCHER | wc -l);

if [ "$STATUS_OF_SCRIPT_WATCHER" -gt 0 ]; 
then     
    echo " The script \033[1;36m$SCRIPT_WATCHER\033[0m is running in the background, everything OK, continue...";
else
    echo "";
    echo "  \033[0;31m--------------------------------------------- /!\ ERROR ! /!\ ---------------------------------------------------\033[0m";
    echo "  The script \033[1;36m$SCRIPT_WATCHER\033[0m is not running ! ";
    echo "" ;     
    echo "  /!\ The script \033[1;36m$SCRIPT_WATCHER\033[0m must be launched first /!\\ \033[0m";
    echo "";
   exit 1;
   
fi





#############################################################################################################################
#               Check if ios-deploy is running
#############################################################################################################################
# echo "\033[1;36m  /!\ This script need to be run from the root folder of your app,  and just after launching the script geturldebug.sh /!\\ \033[0m";

# We make sure  that process IOS-DEPLOY IS NOT RUNNING...if it is, IT WILL BE KILLED,
# because if ios-deploy is present and the previous debug session has crashed (or if you've killed lldb), 
# the script will not run correctly (lldb will produce an error and we will never 
# get the observatoryUri url), futhermore the device can bug displaying a white screen....

# check if ios-deploy is running
STATUS=$(pgrep -f ios-deploy | wc -l);

if [ "$STATUS" -gt 0 ]; 
then 
    echo ""
    echo "ios-deploy is running...killing ios-deploy... "
    pkill -f ios-deploy;
   
fi

while [ "$STATUS" -gt 0 ]; do 
    STATUS=$(pgrep -f ios-deploy | wc -l)
done

echo ""
echo "ios-deploy is not running, continue..."
echo "launching flutter build IOS  & DEPLOYING THE APP IN DEBUG MODE..."


#############################################################################################################################
#       Deploy the app in debug mode, creating a log file named $FILETOPARSE which will be analysed by $SCRIPT_WATCHER
#############################################################################################################################
#Build the flutter app for IOS in debug mode
# use -r to uninstall and reinstall app

flutter build ios --debug -v && ios-deploy -r --bundle build/ios/iphoneos/Runner.app --debug | tee $FILETOPARSE




exit 0;
