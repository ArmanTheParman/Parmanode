function colcard_firmware {
unset ccversion
export ccDFU3="4.1.9"
export ccDFU4="5.2.2"

while true ; do
set_terminal ; echo -e "
########################################################################################

    This tool will help you install the latest firmware on your ColdCard Device.


 $bright_blue   
    The latest version Parmanode has for ColdCard firmware is:
$orange

                           Mark III/II   $green $ccDFU3 $orange

                           Mark IV       $green $ccDFU4 $orange


$cyan    
    Which version of ColdCard do you have?
$orange
                  3)    Coldcard Mark III (or II)
                             
                  4)    Coldcard Mark IV

                  man)  Manually input version of software (assisted with wizard)


########################################################################################
"
choose "xpmq" ; read choice ; clear
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;;
3) 
export ccversion=3 
break
;;
4)
export ccversion=4 
break
;;
man)
manual_cc
export ccversion=man 
break
;;
*)
invalid ;;
esac
done

mkdir -p $hp/coldcard ; debug "coldcard dir made"
cd $hp/coldcard >/dev/null && rm ./* 2>/dev/null #crucial to use && because if cd fails, rm command will delete the wrong things!
debug "cd and clear coldcard dir contents"

#get latest signatures file...
curl -LO https://raw.githubusercontent.com/Coldcard/firmware/master/releases/signatures.txt || \
{ announce "Failed to get signature file. Aborting." ; return 1 ; }
sigfile="$hp/coldcard/signatures.txt"
debug "downloaded sigs"

#download CC firmware file...
if [[ $ccversion == 3 ]] ; then
curl -LO https://coldcard.com/downloads/2023-06-26T1241-v4.1.9-coldcard.dfu
elif [[ $ccversion == 4 ]] ; then
curl -LO https://coldcard.com/downloads/2023-12-21T1526-v5.2.2-mk4-coldcard.dfu
elif [[ $ccversion == man ]] ; then
curl -LO $choice_file
fi
debug "ccversion is $ccversion"

#verification
gpg --import $HOME/parman_programs/parmanode/src/coldcard/ccpubkey.asc
gpg --verify $sigfile || { announce "error. verification of signatures.txt failed." ; return 1 ; }
debug "imported pubkey and verified sigs"

#hash the firmware...
hash=$(shasum -a 256 *.dfu | awk '{print $1}')
grep -q "$hash" < $sigfile || { debug "failed hash" ; announce "error. verification of the hash failed." ; return 1 ; }
debug "hashed dfu file"

cc_firmware_instructions

}

