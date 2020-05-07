# flutter-debug-attach-ios
With theses 2 scripts and config files, you can attach and debug your flutter app running on iOS > 13.3.1 avoiding the famous iOS mDNS bug

### The solution which works in 100% of cases : 
I created two scripts : 
- The first (geturldebug.sh) runs in the background, waiting and scanning in realtime a log file wich is generated by the second script.  When a url is found, a file (observatoryUri.txt) is created containing the ObservatoryUri url (Yes!) which we can use to attach the debugger. 
The script has a default timeout (300 seconds), edit the script to adapt this value with the speed of your Mac (this value must be > time to compile the app by the second script ).

- The second script (buildiosdebug.sh) builds the app in debug mode, and generates a log file which is analyzed by the first script dynamically. The second script must be launched just after the first script.

RESULT : **0% error mDNS lookup failure on iOS, iPhone or iPad, all versions**   !!! YEAH !

### AUTOMATISATION IN VSCODE
I created some tasks in visual studio code to automate all this stuff. Objective: press a key to launch the debugger and attach it to the correct url automatically.
You can find these tasks in my tasks.json here.

I also adapted the launch.json file to launch the debugger in attached mode by providing it with the correct url.

I also used the extension "Tasks: Shell input" because it is not possible without extension to launch shell scripts from attach section configuration in the file launch.json without extensions (am I wrong?).

How does it works ? 
Press F5 in VSCode, and wait few seconds ;) :  
1 - The tasks are launched, and the ObservatoryUri url is created in the file observatoryUri.txt.
2- Vscode will read the url and then launch and attach the debugger to this url.

NOTE : Don't forget to set correct PATH of your app, and the timeout value (if necessary, default = 300 seconds)

Happy debugging !

