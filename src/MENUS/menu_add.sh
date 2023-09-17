function menu_add_programs {
# the somewhat complex code for the menu is to make it dynamic, depending on if
# programs have been installed or not. 

#the output variable includes a new line, but if the variable is empty, echo -n means
#nothing will be printed and no new line created.

#BITCOIN
unset bitcoin_i bitcoin_p bitcoin_n
if grep -q "bitcoin-end" < $HOME/.parmanode/installed.conf ; then 
   #installed
bitcoin_i="#                                      Bitcoin Core                                    #
#                                                                                      #"

elif grep -q "bitcoin-start" < $HOME/.parmanode/installed.conf ; then 
   #partially installed
bitcoin_p="#                                      Bitcoin Core                                    #
#                                                                                      #"
else 
   #not installed
bitcoin_n="#                            (b)           Bitcoin Core                                #
#                                                                                      #"
fi

#DOCKER
unset docker_i docker_p docker_n
if [[ $OS != "Mac" ]] ; then
if grep -q "docker-end" < $HOME/.parmanode/installed.conf ; then 
   #installed
docker_i="#                                      Docker                                          #
#                                                                                      #"
elif grep -q "docker-start" < $HOME/.parmanode/installed.conf ; then
   #partially installed
docker_p="#                                      Docker                                          #
#                                                                                      #"
else
   #not installed
docker_n="#                            (d)           Docker                                      #
#                                                                                      #"
fi
fi

#FULCRUM
unset fulcrum_i fulcrum_p fulcrum_n
if  grep -q "fulcrum-end" < $HOME/.parmanode/installed.conf ; then 
   #installed
fulcrum_i="#                                      Fulcrum                                         #
#                                                                                      #"
elif grep -q "fulcrum-start" < $HOME/.parmanode/installed.conf ; then 
   #partially installed
fulcrum_p="#                                      Fulcrum                                         #
#                                                                                      #"
else
   #not installed
fulcrum_n="#                            (f)           Fulcrum (an Electrum Server)                #
#                                                                                      #"
fi

#BTCPAY
unset btcpay_i btcpay_p btcpay_n
if grep -q "btcpay-end" < $HOME/.parmanode/installed.conf ; then 
   #installed
btcpay_i="#                                      BTCPay Server                                   #
#                                                                                      #"
elif grep -q "btcpay-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
btcpay_p="#                                      BTCPay Server                                   #
#                                                                                      #"
else
   #not installed
btcpay_n="#                            (btcp)        BTCPay Server                               #
#                                                                                      #"
fi

#Sparrow
unset sparrow_i sparrow_p sparrow_n
if grep -q "sparrow-end" < $HOME/.parmanode/installed.conf ; then  
   #installed
sparrow_i="#                                      Sparrow Wallet                                  #
#                                                                                      #"
elif grep -q "sparrow-start" < $HOME/.parmanode/installed.conf ; then 
   #partially installed
sparrow_p="#                                      Sparrow Wallet                                  #
#                                                                                      #"
else
   #not installed
sparrow_n="#                            (s)           Sparrow Wallet                              #
#                                                                                      #"
fi

#Electrs
unset electrs_i electrs_p electrs_n
if grep -q "electrs-end" < $HOME/.parmanode/installed.conf ; then 
   #installed
electrs_i="#                                      electrs                                         #
#                                                                                      #"
elif grep -q "electrs-start" < $HOME/.parmanode/installed.conf ; then
   #partially installed
electrs_p="#                                      electrs                                         #
#                                                                                      #"
else
   #not installed
electrs_n="#                            (ers)         electrs                                     #
#                                                                                      #"
fi

#LND
unset lnd_i lnd_p lnd_n
if grep -q "lnd-end" < $HOME/.parmanode/installed.conf ; then 
  #installed
lnd_i="#                                      LND                                             #
#                                                                                      #"
elif grep -q "lnd-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
lnd_p="#                                      LND                                             #
#                                                                                      #"
else
   #not installed
lnd_n="#                            (lnd)         LND                                         #
#                                                                                      #"
fi

#RTL
unset 
if grep -q "rtl-end" < $HOME/.parmanode/installed.conf ; then 
  #installed
rtl_i="#                                      RTL Wallet                                      #
#                                                                                      #"

elif grep -q "rtl-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
rtl_p="#                                      RTL Wallet                                      #
#                                                                                      #"
else
   #not installed
rtl_n="#                            (r)           RTL Wallet                                  #
#                                                                                      #"
fi

#Electrum
unset 
if grep -q "electrum-end" < $HOME/.parmanode/installed.conf ; then 
  #installed
electrum_i="#                                      Electrum                                        #
#                                                                                      #"
elif grep -q "electrum-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
electrum_p="#                                      Electrum                                        #
#                                                                                      #"
else
   #not installed
electrum_n="#                            (e)           Electrum Wallet                             #
#                                                                                      #"
fi


#Tor
unset tor_i tor_p tor_n
if grep -q "tor-end" < $HOME/.parmanode/installed.conf ; then 
  #installed
tor_i="#                                      Tor                                             #
#                                                                                      #"
elif grep -q "tor-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
tor_p="#                                      Tor                                             #
#                                                                                      #"
else
   #not installed
tor_n="#                            (t)           Tor                                         #
#                                                                                      #"
fi

#Specter
unset specter_i specter_p specter_n
if grep -q "specter-end" < $HOME/.parmanode/installed.conf ; then 
  #installed
specter_i="#                                      Specter Wallet                                  #
#                                                                                      #"
elif grep -q "specter-start" < $HOME/.parmanode/installed.conf ; then 
   #partially installed
specter_p="#                                      Specter Wallet                                  #
#                                                                                      #"
else
   #not installed
specter_n="#                            (specter)     Specter Wallet                              #
#                                                                                      #"
fi

#Tor Server
unset torserver_i torserver_p torserver_n
if grep -q "tor-server-end" < $HOME/.parmanode/installed.conf ; then 
  #installed
torserver_i="#                                      Tor Server                                      #
#                                                                                      #"
elif grep -q "tor-server-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
torserver_p="#                                      Tor Server                                      #
#                                                                                      #"
else
   #not installed
torserver_n="#                            (ts)          Tor Server (Darknet Server)                 #
#                                                                                      #"
fi

#BTCPay Tor
unset btcpTOR_i btcpTOR_p btcpTOR_n
if grep -q "btcpTOR-end" < $HOME/.parmanode/installed.conf ; then 
  #installed
btcpTOR_i="#                                      BTCP over Tor (Darknet BTCPay)                  #
#                                                                                      #"
elif grep -q "btcpTOR-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
btcpTOR_p="#                                      BTCP over Tor (Darknet BTCPay)                  #
#                                                                                      #"
else
   #not installed
btcpTOR_n="#                            (btcpt)       BTCP over Tor (Darknet BTCPay)              #
#                                                                                      #"
fi

#BTC RPC Explorer
unset btcrpcexplorer_i btcrpcexplorer_p btcrpcexplorer_n
if grep -q "btcrpcexplorer-end" < $HOME/.parmanode/installed.conf ; then 
  #installed
btcrpcexplore_i="#                                      BTC RPC Explorer                                #
#                                                                                      #"
elif grep -q "btcrpcexplore-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
btcrpcexplore_p="#                                      BTC RPC Explorer                                #
#                                                                                      #"
else
   #not installed
btcrpcexplore_n="#                                      BTC RPC Explorer                                #
#                                                                                      #"
fi


while true
do
set_terminal_higher
echo "
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> Main Menu --> Install Menu                                  #
#                                                                                      #
########################################################################################
#                                                                                      #
# Not yet installed...                                                                 #
#                                                                                      #"
if [[ -n $bitcoin_n ]]         ; then echo  "$bitcoin_n"; fi
if [[ -n $electrs_n ]]         ; then echo  "$electrs_n"; fi
if [[ -n $btcrpcexplorer_n ]]  ; then echo  "$btcrpcexplorer_n"; fi
if [[ -n $sparrow_n ]]         ; then echo  "$sparrow_n"; fi
if [[ -n $electrum_n ]]        ; then echo  "$electrum_n"; fi
if [[ -n $specter_n ]]         ; then echo  "$specter_n"; fi
if [[ -n $lnd_n ]]             ; then echo  "$lnd_n"; fi
if [[ -n $docker_n ]]          ; then echo  "$docker_n"; fi
if [[ -n $rtl_n ]]             ; then echo  "$rtl_n"; fi
if [[ -n $btcpay_n ]]          ; then echo  "$btcpay_n"; fi
if [[ -n $fulcrum_n ]]         ; then echo  "$fulcrum_n"; fi
if [[ -n $tor_n ]]             ; then echo  "$tor_n"; fi
if [[ -n $btcpTOR_n ]]         ; then echo  "$btcpTOR_n"; fi
if [[ -n $torserver_n  ]]      ; then echo  "$torserver_n"; fi
echo "#                                                                                      #
# Installed...                                                                         #
#                                                                                      #"
if [[ -n $bitcoin_i ]]         ; then echo  "$bitcoin_i"; fi
if [[ -n $electrs_i ]]         ; then echo  "$electrs_i"; fi
if [[ -n $btcrpcexplorer_i ]]  ; then echo  "$btcrpcexplorer_i"; fi
if [[ -n $sparrow_i ]]         ; then echo  "$sparrow_i"; fi
if [[ -n $electrum_i ]]        ; then echo  "$electrum_i"; fi
if [[ -n $specter_i ]]         ; then echo  "$specter_i"; fi
if [[ -n $lnd_i ]]             ; then echo  "$lnd_i"; fi
if [[ -n $docker_i ]]          ; then echo  "$docker_i"; fi
if [[ -n $rtl_i ]]             ; then echo  "$rtl_i"; fi
if [[ -n $btcpay_i ]]          ; then echo  "$btcpay_i"; fi
if [[ -n $fulcrum_i ]]         ; then echo  "$fulcrum_i"; fi
if [[ -n $tor_i ]]             ; then echo  "$tor_i"; fi
if [[ -n $btcpTOR_i ]]         ; then echo  "$btcpTOR_i"; fi
if [[ -n $torserver_i  ]]      ; then echo  "$torserver_i"; fi
echo "#                                                                                      #
# Failed installs (need to uninstall)...                                               #
#                                                                                      #"
if [[ -n $bitcoin_p ]]         ; then echo  "$bitcoin_p"; fi
if [[ -n $electrs_p ]]         ; then echo  "$electrs_p"; fi
if [[ -n $btcrpcexplorer_p ]]  ; then echo  "$btcrpcexplorer_p"; fi
if [[ -n $sparrow_p ]]         ; then echo  "$sparrow_p"; fi
if [[ -n $electrum_p ]]        ; then echo  "$electrum_p"; fi
if [[ -n $specter_p ]]         ; then echo  "$specter_p"; fi
if [[ -n $lnd_p ]]             ; then echo  "$lnd_p"; fi
if [[ -n $docker_p ]]          ; then echo  "$docker_p"; fi
if [[ -n $rtl_p ]]             ; then echo  "$rtl_p"; fi
if [[ -n $btcpay_p ]]          ; then echo  "$btcpay_p"; fi
if [[ -n $fulcrum_p ]]         ; then echo  "$fulcrum_p"; fi
if [[ -n $tor_p ]]             ; then echo  "$tor_p"; fi
if [[ -n $btcpTOR_p ]]         ; then echo  "$btcpTOR_p"; fi
if [[ -n $torserver_p  ]]      ; then echo  "$torserver_p"; fi
echo "
########################################################################################
"
choose "xpq"

read choice

case $choice in
    B|b|bitcoin|Bitcoin)
        if [[ -n $bitcoin_n ]] ; then
        set_terminal 
        install_bitcoin
        return 0
        fi
        ;;
    f|F)
       if [[ -n $fulcrum_n ]] ; then
       set_terminal
       if [[ $OS == "Linux" ]] ; then 
       electrs_better_4pi || return 1 
       install_fulcrum && return 0 ; fi
       if [[ $OS == "Mac" ]] ; then install_fulcrum_mac && return 0 ; fi
       return 0 
       fi
       ;;
    d|D)
       if [[ -n $docker_n ]] ; then
        set_terminal
        install_docker_parmanode_linux  
        return 0
        fi
        ;;
    btcp|BTCP|Btcp)
       if [[ -n $btcpay_n ]] ; then
       if [[ $OS == "Linux" ]] ; then 
       install_btcpay_linux ; return 0 ; fi
       if [[ $OS == "Mac" ]] ; then 
       no_mac ; return 0  ; fi
       fi
       ;;
    
    t|T|tor|Tor)
       if [[ -n $tor_n ]] ; then
       install_tor 
       return 0 
       fi
       ;;
    lnd|LND|Lnd)
       if [[ -n $lnd_n ]] ; then
       if [[ $OS == "Linux" ]] ; then install_lnd ; return 0 ; fi 
       if [[ $OS == "Mac" ]] ; then no_mac ; return 0 ; fi
       fi
       ;;
    
    s|S|Sparrow|sparrow|SPARROW)
       if [[ -n $sparrow_n ]] ; then

        if [[ $chip == "arm64" || $chip == "aarch64" || $chip == "armv6l" || $chip == "armv7l" ]] ; then
        announce \
        "Sorry but Sparrow isn't available with Parmanode on non-Mac ARM chips (Raspberry Pi)" \
        "Coming soon, promise."
        continue
        fi

       install_sparrow
       return 0
       fi
       ;;
   r|R|RTL|rtl|Rtl)
      if [[ -n $rtl_n ]] ; then
      install_rtl
      return 0
      fi
      ;;
   e|E|electrum|Electrum|ELECTRUM)
      if [[ -n $electrum_n ]] ; then

        if [[ $chip == "arm64" || $chip == "aarch64" || $chip == "armv6l" || $chip == "armv7l" ]] ; then
        announce \
        "Sorry but Electrum isn't ready with Parmanode for ARM chips (eg RaspberryPi)" \
        "Coming soon, promise"
        continue
        fi

      install_electrum
      return 0
      fi
      ;;
   ts|TS|Ts)
      if [[ -n $torserver_n ]] ; then
      install_tor_server
      return 0
      fi
      ;;
   
   btcpt|BTCPT)
      if [[ -n $btcpTOR_n ]] ; then
      install_btcpay_tor
      return 0
      fi
      ;;
   
   specter|Specter|SPECTER)
      if [[ -n $specter_n ]] ; then
      install_specter
      return 0
      fi
      ;;

    bre|BRE|Bre)
       if [[ -n $btcrpcexplorer_n ]] ; then
         if [[ $OS == "Mac" ]] ; then no_mac ; return 0 ; fi 
         install_btcrpcexplorer ; return 0 
       fi
       ;;
   
   ers|ERS|Ers|electrs)
      if [[ -n $electrs_n ]] ; then
         if [[ $OS != "Mac" ]] ; then
         install_electrs
         return 0
         else
         no_mac ; return 0
         fi
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


function electrs_better_4pi {

while true ; do
if [[ $chip == "arm64" || $chip == "aarch64" || $chip == "armv6l" || $chip == "armv7l" ]] ; then
set_terminal
announce "It's best for Raspberry Pi's to use electrs insteat of Fulcrum" \
"Abort Fulcrum installation?     y     or     n"
read choice

case $choice in 
y|Y) return 1 ;;
n|N) return 0 ;;
*) invalid ;;
esac
fi
break
done

}