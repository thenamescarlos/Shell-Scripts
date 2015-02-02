#Generate a student account for each class period in a school computer lab.
#Written because the OSX lab was in a non-directory enviroment
#Implements password pattern defined by the teacher.

#Create a group that has restrictions on certain apps.

username(){
    periodno=$1
    echo "Period $periodno"
}
foldername(){
    periodno=$1
    echo "period$periodno"
}
password() {
    computerno=$1
    periodno=$2
    generated=$(expr 5 \* $computerno + $periodno)
    echo "word$generated"
}
createaccount(){
    computerno=$1
    noofperiod=$2
    for (( i = 0; i < $noofperiod; i++ )); do
        periodno="$(expr $i + 1)"
        folder="$(foldername periodno)"
        
        #Gets available UUID to create account copied from online source.
        LastID=`dscl . -list /Users UniqueID | awk '{print $2}' | sort -n | tail -1`
        AvailID=$((LastID + 1))
        
        dscl . -create /Users/$folder
        dscl . -create /Users/$folder UserShell /bin/bash
        dscl . -create /Users/$folder RealName "$(username $periodno)"
        dscl . -create /Users/$folder UniqueID $AvailID
        dscl . -create /Users/$folder PrimaryGroupID 20 #maps to staff which is a standard user.
        dscl . -create /Users/$folder NFSHomeDirectory /Users/$folder
        dscl . -passwd /Users/$folder "$(password $computerno $periodno)" 
    done
}

main(){
    noofcomputer=40
    noofperiod=7
    
    # Get OSX Computer name
    computername="$(scutil --get ComputerName)"
    # Should extract last three digits
    computerno="$(echo $computername | grep -E '[0-9]{3}' -o | tail -n 1)"
    
    
    if [[ -z "$computerno" ]]; then
        echo "FAILED: Accounts not created."
    else
        createaccount computerno
        
        #https://github.com/rtrouton/rtrouton_scripts/tree/master/rtrouton_scripts/disable_apple_icloud_and_diagnostic_pop_ups
        osvers=$(sw_vers -productVersion | awk -F. '{print $2}')
        sw_vers=$(sw_vers -productVersion)
        
        sw_build=$(sw_vers -buildVersion)
        
        if [[ ${osvers} -ge 7 ]]; then
        
         for USER_TEMPLATE in "$3/System/Library/User Template"/*
          do
            /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant DidSeeCloudSetup -bool TRUE
            /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant GestureMovieSeen none
            /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant LastSeenCloudProductVersion "${sw_vers}"
            /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant LastSeenBuddyBuildVersion "${sw_build}"      
          done
        
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
        echo "SUCCESS: Accounts were created."
    fi  
}

main
