function gpg_check {

which gpg >$dn 2>&1 && return 0

    if [[ $btcpay_combo == "true" ]] ; then sudo apt-get install gpg -y ; return 0 ; fi

while true ; do 
set_terminal #don't use echo -e
echo "
########################################################################################

                            Testing \"gpg\" checkpoint

    Parmanode has tested if the \"gpg\" command is available on your computer and it
    is not. 
    
    Gpg is necessary for certain commands that Parmanode will use, like verifying 
    signatures from developers who release their code. 

    Parmanode can install gpg for you if you like:

                              g)      Install gpg

                              s)      Skip gpg installation (not recommended)

########################################################################################
"
choose "xq"; read choice
case $choice in
g) set_terminal 
   [[ $(uname) == "Linux" ]] && sudo apt-get install gpg -y 
   [[ $(uname) == "Darwin" ]] && install_gpg4mac
   return 0 
   ;;
q)	
   exit 0
   ;;
s) return ;;
*) continue ;;
esac
done 
}
