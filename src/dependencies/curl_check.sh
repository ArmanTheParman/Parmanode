function curl_check {
if ! which curl >$dn 2>&1 ; then
while true ; do
#don't use echo -e
set_terminal ; echo "
########################################################################################

    The program curl needs to be installed on your computer for Parmanode to work.
    It's a small command line program that is used to download links from the 
    internet. It's quite unusual that Parmanode hasn't been able to detect it as 
    most Linux and Mac operating systems come with it. 
    
    On Macs, it requires Homebrew to be installed first - that can take a while.
    
                          i)          Install curl

                          q)          Quit

########################################################################################
"
choose "xpmq" ; read choice
case $choice in 
m|M) back2main ;;
q|Q|Quit|QUIT) exit 0 ;; p|P) return 1 ;; 

    i|I)
    if [[ $OS == "Linux" ]] ; then sudo apt-get install curl -y ; break ; fi 
    if [[ $OS == "Mac" ]] ; then brew_check || return 1 ; brew install curl ; break ; fi
    ;;

    *) invalid ;; 
esac 
done
fi
return 0
}