#Modify the following to create a new account

FRIENDLYNAME="Change Me" #Appears in account list. Can include spaces.
USERNAME="changeme" #Name that appears in /Users folder. No Spaces
PASSWORD="changeme"
ISADMIN=false #Set as true to enable admin

#Don't Modify the following
#Gets available UUID to create account 
LastID=`dscl . -list /Users UniqueID | awk '{print $2}' | sort -n | tail -1`
AvailID=$((LastID + 1))

#Group id 20 resolves to staff which is like standard. 80 is admin
PRIVILEGE=`if [ $ISADMIN == true ]; then echo "80"; else echo "20"; fi`

dscl . -create /Users/$USERNAME
dscl . -create /Users/$USERNAME UserShell /bin/bash
dscl . -create /Users/$USERNAME RealName "$FRIENDLYNAME"
dscl . -create /Users/$USERNAME UniqueID $AvailID 
dscl . -create /Users/$USERNAME PrimaryGroupID $PRIVILEGE 
dscl . -create /Users/$USERNAME NFSHomeDirectory /Users/$USERNAME
dscl . -passwd /Users/$USERNAME $PASSWORD 



#The following script disables the iCloud sign in pop up on first login. It was written by rtrouton and can be found below.
#https://github.com/rtrouton/rtrouton_scripts/tree/master/rtrouton_scripts/disable_apple_icloud_and_diagnostic_pop_ups

# Determine OS version
osvers=$(sw_vers -productVersion | awk -F. '{print $2}')
sw_vers=$(sw_vers -productVersion)

# Determine OS build number

sw_build=$(sw_vers -buildVersion)

# Checks first to see if the Mac is running 10.7.0 or higher. 
# If so, the script checks the system default user template
# for the presence of the Library/Preferences directory. Once
# found, the iCloud and Diagnostic pop-up settings are set 
# to be disabled.

if [[ ${osvers} -ge 7 ]]; then

 for USER_TEMPLATE in "$3/System/Library/User Template"/*
  do
    /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant DidSeeCloudSetup -bool TRUE
    /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant GestureMovieSeen none
    /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant LastSeenCloudProductVersion "${sw_vers}"
    /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant LastSeenBuddyBuildVersion "${sw_build}"      
  done
 
 # Checks first to see if the Mac is running 10.7.0 or higher.
 # If so, the script checks the existing user folders in /Users
 # for the presence of the Library/Preferences directory.
 #
 # If the directory is not found, it is created and then the
 # iCloud and Diagnostic pop-up settings are set to be disabled.

 for USER_HOME in "$3/Users"/*
  do
    USER_UID=`basename "${USER_HOME}"`
    if [ ! "${USER_UID}" = "Shared" ]; then
      if [ ! -d "${USER_HOME}"/Library/Preferences ]; then
        /bin/mkdir -p "${USER_HOME}"/Library/Preferences
        /usr/sbin/chown "${USER_UID}" "${USER_HOME}"/Library
        /usr/sbin/chown "${USER_UID}" "${USER_HOME}"/Library/Preferences
      fi
      if [ -d "${USER_HOME}"/Library/Preferences ]; then
        /usr/bin/defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant DidSeeCloudSetup -bool TRUE
        /usr/bin/defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant GestureMovieSeen none
        /usr/bin/defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant LastSeenCloudProductVersion "${sw_vers}"
        /usr/bin/defaults write "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant LastSeenBuddyBuildVersion "${sw_build}"
        /usr/sbin/chown "${USER_UID}" "${USER_HOME}"/Library/Preferences/com.apple.SetupAssistant.plist
      fi
    fi
  done
fi

exit 0
