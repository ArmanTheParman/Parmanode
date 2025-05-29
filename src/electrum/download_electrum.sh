function download_electrum {

cd $HOME/parmanode/electrum

choose_electrum_version

if [[ $computer_type == "LinuxPC" ]] ; then
    curl -LO https://download.electrum.org/$electrum_version/electrum-${electrum_version}-x86_64.AppImage && \
    curl -LO https://download.electrum.org/${electrum_version}/electrum-${electrum_version}-x86_64.AppImage.asc && \
    curl -LO https://raw.githubusercontent.com/spesmilo/electrum/master/pubkeys/ThomasV.asc 
    return 0
    fi

if [[ $computer_type == "Pi" ]] ; then
    curl -LO https://download.electrum.org/${electrum_version}/Electrum-${electrum_version}.tar.gz
    curl -LO https://download.electrum.org/${electrum_version}/Electrum-${electrum_version}.tar.gz.asc
    curl -LO https://raw.githubusercontent.com/spesmilo/electrum/master/pubkeys/ThomasV.asc 
    return 0
    fi

if [[ $OS == Mac ]] ; then
    curl -LO https://download.electrum.org/${electrum_version}/electrum-${electrum_version}.dmg && \
    curl -LO https://download.electrum.org/${electrum_version}/electrum-${electrum_version}.dmg.asc && \
    curl -LO https://raw.githubusercontent.com/spesmilo/electrum/master/pubkeys/ThomasV.asc 
fi


}
function choose_electrum_version {
while true ; do
clear ; echo -e "
########################################################################################
    
               Please indicate your preferred version of Electrum.
$cyan
                                    1)$orange       4.4.4
$cyan
                                    2)$orange       4.5.8 

                                    3)$orange       custom

########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

1)
export electrum_version="4.4.4" 
break
;;
2)
export electrum_version="4.5.8"
break
;;
3)
announce "If you choose this, you are responsible to verify the software yourself.$red x$orange to abort"
case $enter_cont in x) continue ;; esac
announce "Please enter the version you want."
jump $enter_cont
export electrum_version=$enter_cont
export skip_verify="true"
;;
*)
invalid
;;
esac
done

return 0 
}
