function which_computer_type {

if [[ $OS == "Linux" ]] ; then

   # if [[ $(uname -m) == "aarch64" || \
   #       $(uname -m) == "arm"     || \
   #       $(uname -m) == "armhf"   || \
   #       $(uname -m) == "armv7l"  || \
   #       $(uname -m) == "armv6l"  || \
   #       $(uname -m) == "armv8l"        ]] ; then
   
   if sudo grep "Model" /proc/cpuinfo | grep -q "Raspberry" ; then 
            export computer_type=Pi 
            parmanode_conf_add "computer_type=Pi" >$dn
   else
            export computer_type=LinuxPC
            parmanode_conf_add "computer_type=LinuxPC" >$dn
   fi

    
else
            export computer_type=Mac 
            parmanode_conf_add "computer_type=Mac" >$dn
fi
}