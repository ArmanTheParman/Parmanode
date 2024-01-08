function download_electrum {

cd $HOME/parmanode/electrum
electrum_version="4.4.6"

clear ; echo -e "
########################################################################################
    
    Parmanode will download version $electrum_version for you.

    If you prefer my favourite version,$cyan v4.4.4$orange, then type 'old' then <enter>, 
    otherwise anything else and <enter> to have the later version.

########################################################################################
"
read choice
if [[ $choice == "old" ]] ; then $electrum_version="4.4.4" ; debug "version1 $electrum_version"; fi
clear

debug "version2 $electrum_version"

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

while true ; do
if [[ $OS == Mac ]] ; then
clear ; echo -e "
########################################################################################

    If you have a Mac with a newer M1/M2 chip, you might run in to problems with
    the standard Electrum chip. If this has happened, or you don't want to take
    any chances, you can select to install the 'python' version instead. It works
    the same, you just won'g get a Mac executable in your Applications directory.

                        1)         Regular install

                        2)         Python install 

########################################################################################
"
read choice
case $choice in 
1)
curl -LO https://download.electrum.org/${electrum_version}/electrum-${electrum_version}.dmg && \
curl -LO https://download.electrum.org/${electrum_version}/electrum-${electrum_version}.dmg.asc && \
curl -LO https://raw.githubusercontent.com/spesmilo/electrum/master/pubkeys/ThomasV.asc 
break
;;

2)
curl -LO https://download.electrum.org/${electrum_version}/Electrum-${electrum_version}.tar.gz
curl -LO https://download.electrum.org/${electrum_version}/Electrum-${electrum_version}.tar.gz.asc
curl -LO https://raw.githubusercontent.com/spesmilo/electrum/master/pubkeys/ThomasV.asc 
break
;;

*)
invalid ;;
esac

else
   return
fi

done

}