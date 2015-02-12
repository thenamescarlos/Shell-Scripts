#Generates a student account for each class period in a school computer lab.
#Written because the OSX lab was in a non-directory enviroment
#Implements password pattern defined by the teacher.

username(){
    #expects username # ### e.g. username 4 029
    periodno=$1
    computerno=$2
    studentname=$(echo $computerno | grep -E '[0-9][0-9]$' -o)
    echo "Student-$studentname-$periodno"
}
foldername(){
    periodno=$1
    echo "period$periodno"
}
password() {
    periodno=$1
    computerno=$2
    generated=$(expr 5 \* $computerno + $periodno)
    echo "word$generated"
}

createaccount() {
    username=$1
    password=$2
    folder=$3
    #Gets available UUID to create account copied from online source.
    LastID=`dscl . -list /Users UniqueID | awk '{print $2}' | sort -n | tail -1`
    AvailID=$((LastID + 1))
    
    dscl . -create /Users/$folder
    dscl . -create /Users/$folder UserShell /bin/bash
    dscl . -create /Users/$folder RealName "$username"
    dscl . -create /Users/$folder UniqueID $AvailID
    dscl . -create /Users/$folder PrimaryGroupID 20 #maps to staff which is a standard user.
    dscl . -create /Users/$folder NFSHomeDirectory /Users/$folder
    dscl . -passwd /Users/$folder $password
}

createaccounts(){
    computerno=$1
    noofperiod=$2
    periodno=1
    while [ $periodno -le $noofperiod ]
    do
        u=$(username $periodno $computerno)
        p=$(password $periodno $computerno)
        f=$(foldername $periodno)
        createaccount $u $p $f
        echo $u $p $f
        periodno=$(expr $periodno + 1)
    done
}

main(){
    noofperiod=7
    # Get OSX Computer name
    computername="$(scutil --get ComputerName)"
    #computername="B115-iMac-033"
    # Should extract last three digits
    computerno="$(echo $computername | grep -E '[0-9]{3}' -o | tail -n 1)"
    
    
    if [[ -z "$computerno" ]]; then
        echo "FAILED: Accounts not created."
    else
        echo $computerno
        createaccounts $computerno $noofperiod
        echo "SUCCESS: Accounts were created."
    fi  
}

main
