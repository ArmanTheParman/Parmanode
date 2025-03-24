function choose_bitcoin_version {
if [[ $version == self ]] ; then return 0 ; fi
if [[ $OS == Mac ]] ; then return 0 ; fi

if [[ $btcpayinstallsbitcoin == "true" || $btcpodmanchoice == "yes" ]] ; then
parmanode_conf_add "bitcoin_choice=precompiled"
export bitcoin_compile="false"
return 0
fi


while true ; do
#default version set at the beginning of instll_bitcoin()
set_terminal 40 120 ; echo -e "
########################################################################################################################
$cyan
                THERE ARE SEVERAL WAYS TO INSTALL BITCOIN WITH PARMANODE. PLEASE CHOOSE WISELY ...
$orange
########################################################################################################################
$green

   hit <enter>)       Pre-compiled Bitcoin KNOTS, v$knotsversion, verified with gpg $blinkon(recommended)$blinkoff
$green
         knots)       Guided compile Bitcoin KNOTS, v$knotsversion
$yellow
          core)       Pre-compiled Bitcoin CORE v$version, verified with gpg

          hfsp)       Guided compile Bitcoin CORE v$version

          rekt)       Guided compile Bitcoin CORE, v$version, (with FILTER-ORDINALS patch by Luke Dashjr)
$blue
          info)       Read how to compile yourself, and import the installation to Parmanode. You can come back to 
                      this menu after selecting this. 
$red
           few)       Custom version (you choose) - Download and verify 'trusted' releases

          yolo)       Guided compile custom version (you choose) 

       builder)       Guided compile of most recent Github update, i.e. pre-release
                      (for testing only)

        import)       IMPORT binaries you have compiled yourself (or previously downloaded without the help of the 
                      Parmanode install process). 'Binaries' refers to the executable files, eg bitcoind and 
                      bitcoin-qt, not the blockchain.
$orange
########################################################################################################################
"
choose "xpmq" 
unset bitcoin_compile ordinals_patch knotsbitcoin byo_bitcoin
read choice
jump $choice || { invalid ; continue ; } ; set_terminal

case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;;
pck|pk|kp|"")
parmanode_conf_add "bitcoin_choice=knots"
export bitcoin_compile="false" 
export knotsbitcoin="true" ; version="28.x-knots" ; break ;;
0|27|c|core)
parmanode_conf_add "bitcoin_choice=precompiled"
export bitcoin_compile="false" ; break ;;
few|custom) 
parmanode_conf_add "bitcoin_choice=precompiled"
select_custom_version || return 1
export bitcoin_compile="false" ; break ;;
yolo) 
parmanode_conf_add "bitcoin_choice=compiled"
select_custom_version || return 1
export bitcoin_compile="true" ; break ;;
hfsp) 
parmanode_conf_add "bitcoin_choice=compiled"
export bitcoin_compile="true" ; break ;;
rekt)
parmanode_conf_add "bitcoin_choice=compiled"
export bitcoin_compile="true" ; export ordinals_patch="true" ; break ;;
knots)
parmanode_conf_add "bitcoin_choice=knots"
export bitcoin_compile="true"
export knotsbitcoin="true" ; export version="28.1-knots" ; break ;;
builder)
parmanode_conf_add "bitcoin_choice=compiled"
export bitcoin_compile="true" ; export version="master" ; break ;;
info)
bitcoin_compile_instructions
return 0
;;

import)
set_terminal ; echo -e "
########################################################################################
  Make sure the Bitcoin binary files have been placed in the /usr/local/bin/ directory
########################################################################################
"
enter_continue  ; jump $enter_cont
export bitcoin_compile="false"
export version="self"
if ! which bitcoind >$dn ; then
set_terminal ; echo -e "
########################################################################################

    Parmanode could not detect bitcoind in$cyan /usr/local/bin$orange. Aborting.

########################################################################################
"
enter_continue ; jump $enter_cont
return 1
else
return 0
fi
;;

*) 
invalid ;;
esac
done

if [[ $bitcoin_compile != "false" ]] ; then
# $hp/bitcoin directory made earlier for downloading compiled bitcoin. Can delete.
sudo rm -rf $hp/bitcoin >$dn 2>&1
fi

}

function select_custom_version {
nogsedtest
while true ; do 
set_terminal ; echo -e "
########################################################################################
    
    Please type in a version number

    Eg. ${cyan}25.0$orange

    Please note, the Parmanode automatic compile script won't work with every version,
    especially early versions. Won't hurt to try. I might work on this in the future.

########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; }
case $choice in
p|P) return 1 ;; q|Q) exit ;; m|M) back2main ;;
*)
#remove the v if entered
choice=$(echo $choice | gsed 's/^v//')

    if ! echo $choice | grep -Eq "^[0-9]+\.[0-9]+" ; then
    yesorno "What you entered seems to not be valid. Proceed anyway?" || continue
    fi
    if echo $choice | grep -Eq "^0\.1.*" ; then
    announce "This won't work, versions below 0.2.0 compiled on Windows."
    continue
    fi
    if echo $choice | grep -Eq "^0\.(1|2)$" ; then
    announce "Version number not in the right format."
    continue
    fi


export version=$choice
break
;;
esac
done

}

#### precompile not working because it's dynamically linked and getting issues.
#     
#      reckless)       ${yellow}Knots$bright_blue compiled by Parman (saves time, but may now work and
#                      less secure than compiling yourself)