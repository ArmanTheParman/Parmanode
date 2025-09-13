function choose_bitcoin_version {
if [[ $version == "self" ]] ; then return 0 ; fi
if [[ $OS == "Mac" ]] ; then return 0 ; fi

if [[ $btcpayinstallsbitcoin == "true" || $btcdockerchoice == "yes" ]] ; then
parmanode_conf_add "bitcoin_choice=precompiled"
export bitcoin_compile="false"
return 0
fi

echo test

while true ; do
set_terminal 32 120 ; echo -e "$orange
########################################################################################################################$green
                THERE ARE SEVERAL WAYS TO INSTALL BITCOIN WITH PARMANODE. PLEASE CHOOSE WISELY ...$orange
########################################################################################################################
$cyan
                    Which flavour of the Bitcoin client do you want to install?


$green
<enter>  or  k)     ${orange}Bitcoin Knots (default, filters spam)$blue
                    Maintained by Luke Dashjr
$yellow
         knutz)     ${orange}Bitcoin Deis (forks Core client v28.1 with filter ordinals patch)$blue
                    Maintained by Parman
$red
             c)     ${orange}Bitcoin Core (for spam enjooyers)
$cyan
          info)     ${orange}Read how to compile yourself, and import the installation to Parmanode. You can come back to 
                    this menu after selecting this. 
$cyan
        import)     ${orange}IMPORT binaries you have compiled yourself (or previously downloaded without the help of the 
                    Parmanode install process). 'Binaries' refers to the executable files, eg bitcoind and 
                    bitcoin-qt, not the blockchain.
                    


########################################################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;;
k|"")
export clientchoice="knots" ; break
;;
knutz|d)
export clientchoice="deis"
parmanode_conf_add "bitcoin_choice=deis"
export bitcoin_compile="true" ; deis="true" ; return 0
;;
c)
export clientchoice="core"
break
;;
info)
bitcoin_compile_instructions
continue
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


[[ $clientchoice == "knots" ]] && while true ; do

set_terminal 40 120 ; echo -e "
########################################################################################################################
    More questions, sorry...

$cyan
     1)$orange     Pre-compiled Bitcoin KNOTS, v$knotsversion $blinkon(recommended)$blinkoff
$cyan
     2)$orange     Guided compile Bitcoin KNOTS, v$knotsversion
$cyan
     3)$orange     Pre-compile Bitcoin Knots, v28.1 (March 5, 2025)


########################################################################################################################
"
choose "xpmq" 
read choice
jump $choice || { invalid ; continue ; } ; set_terminal

case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;;
1|"")
parmanode_conf_add "bitcoin_choice=knots"
export bitcoin_compile="false" 
export knotsbitcoin="true" ; version="$knotsmajor-knots" ; return 0 ;;
2)
parmanode_conf_add "bitcoin_choice=knots"
export bitcoin_compile="true"
export knotsbitcoin="true" ; export version="29.1-knots" ; return 0 ;;
3)
export knotsversion="28.1"
export knotsdate="20250305"
export knotsmajor="28.x"
#probably redundant
export knotstag="v${knotsversion}.knots${knotsdate}"

parmanode_conf_add "bitcoin_choice=knots"
export bitcoin_compile="false" 
export knotsbitcoin="true" ; version="$knotsmajor-knots" ; return 0 
;;

*)
invalid ;;
esac
done

while true ; do
set_terminal 40 120 ; echo -e "
########################################################################################################################
    More questions, sorry...
$cyan
          core)       ${orange}Pre-compiled Bitcoin CORE v$version, verified with gpg
$cyan
          hfsp)       ${orange}Guided compile Bitcoin CORE v$version
$cyan
          rekt)       ${orange}Guided compile Bitcoin CORE, v$version, (with FILTER-ORDINALS patch by Luke Dashjr)
$cyan
           few)       ${orange}Custom Bitcoin Core version (you choose) - Download and verify 'trusted' releases
$cyan
          yolo)       ${orange}Guided compile custom Bitcoin Core version (you choose) 
$cyan
       builder)       ${orange}Guided compile of most recent Bitcoin Core Github update, i.e. pre-release
                      (for testing only)
$orange
########################################################################################################################
"
choose "xpmq" 
unset ordinals_patch bitcoin_compile
read choice
jump $choice || { invalid ; continue ; } ; set_terminal

case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;;

0|27|c|core)
parmanode_conf_add "bitcoin_choice=precompiled"
export core="true" ; export bitcoin_compile="false" ; return 0 ;;
few|custom) 
parmanode_conf_add "bitcoin_choice=precompiled"
select_custom_version || return 1
export core="true" ; export bitcoin_compile="false" ; return 0 ;;
yolo) 
parmanode_conf_add "bitcoin_choice=compiled"
select_custom_version || return 1
export bitcoin_compile="true" ; return 0 ;;
hfsp) 
parmanode_conf_add "bitcoin_choice=compiled"
export bitcoin_compile="true" ; return 0 ;;
rekt)
parmanode_conf_add "bitcoin_choice=compiled"
export bitcoin_compile="true" ; export ordinals_patch="true" ; return 0 ;;
builder)
parmanode_conf_add "bitcoin_choice=compiled"
export bitcoin_compile="true" ; export version="master" ; return 0 ;;
esac
done


while true ; do
#default version set at the beginning of instll_bitcoin()
set_terminal 40 120 ; echo -e "
########################################################################################################################
$cyan
$orange
########################################################################################################################




########################################################################################################################
"
choose "xpmq" 
read choice
jump $choice || { invalid ; continue ; } ; set_terminal

case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;;





*) 
invalid ;;
esac
done

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

    Also, Bitcoin Core devs removed the autogen.sh file and changed the compile
    process. Parmanode will not compile for you for versions greater then 28.

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
