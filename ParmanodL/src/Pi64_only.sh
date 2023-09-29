function Pi64_only {

if [[ $(uname -s) != Linux ]] ; then 
clear ; echo "
    This script only works on a Raspberry Pi 64 bit."
    enter_continue
exit
fi

}