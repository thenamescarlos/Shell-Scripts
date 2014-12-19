#Replace someuser with desired user account. Remember that you need to specify the name that appears in /Users

USER="someuser"

#Script
dscl . -delete /Users/$USER
rm -rf /Users/$USER
