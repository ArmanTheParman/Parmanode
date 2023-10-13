function menu_add_other {
while true
menu_add_source
do
set_terminal
echo -e "
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> Main Menu --> Install Menu  -->$cyan Other Install $orange              #
#                                                                                      #
########################################################################################
#                                                                                      #
# Not yet installed...                                                                 #
#                                                                                      #"
if [[ -n $parmashell_n ]]      ; then echo  "$parmashell_n"; fi 
if [[ -n $docker_n ]]          ; then echo  "$docker_n"; fi
if [[ -n $tor_n ]]             ; then echo  "$tor_n"; fi
if [[ -n $torserver_n ]]       ; then echo  "$torserver_n"; fi
echo "#                                                                                      #
# Installed...                                                                         #
#                                                                                      #"
if [[ -n $parmashell_i ]]      ; then echo  "$parmashell_i"; fi 
if [[ -n $docker_i ]]          ; then echo  "$docker_i"; fi
if [[ -n $tor_i ]]             ; then echo  "$tor_i"; fi
if [[ -n $torserver_i ]]       ; then echo  "$torserver_i"; fi
echo "#                                                                                      #
# Failed installs (need to uninstall)...                                               #
#                                                                                      #"
if [[ -n $parmashell_p ]]      ; then echo  "$parmashell_p"; fi 
if [[ -n $docker_p ]]          ; then echo  "$docker_p"; fi
if [[ -n $tor_p ]]             ; then echo  "$tor_p"; fi
if [[ -n $torserver_p ]]       ; then echo  "$torserver_p"; fi

echo "#                                                                                      #
########################################################################################
"
choose "xpq"

read choice

case $choice in
   ps|PS|Ps)
     if [[ -n $parmashell_n ]] ; then
     install_parmashell
     return 0
     fi
     ;;

   d|D)
     if [[ -n $docker_n ]] ; then
     set_terminal
     if [[ $OS == Linux ]] ; then install_docker_linux ; fi
     if [[ $OS == Mac ]] ; then install_docker_mac ; fi
     return 0
     fi
     ;; 

     t|T|tor|Tor)
       if [[ -n $tor_n ]] ; then
       install_tor 
       return 0 
       fi
       ;;
 ts|TS|Ts)
      if [[ -n $torserver_n ]] ; then
      install_tor_server
      return 0
      fi
      ;;

    q|Q|quit|QUIT)
        exit 0
        ;;
    p|P)
        return 0 
        ;;
    *)
        invalid
        continue
        ;;
esac
done

return 0

}
