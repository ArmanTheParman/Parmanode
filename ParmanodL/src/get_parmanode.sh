function get_parmanode {

if [ ! -e $HOME/parman_programs/parmanode/run_parmanode.sh ] ; then
clear ; echo "
########################################################################################

    The Parmanode software is required on THIS system to run this script. 
    It will be downloaded now. You do not necessirly need it later and you'll be
    asked if you want to delete it.

	Hit n and <enter> to abort.

########################################################################################
" ; read choice ; case $choice in n) return 1 ;; esac
curl https://parmanode.com/install.sh | sh
counter=$((counter + 1))
fi

}