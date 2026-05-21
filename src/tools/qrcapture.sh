function install_qrcapture {

sudo apt-get -y update 
sudo apt-get -y install zbar-tools #fswebcam

#usage
    #zbarcam --raw | head -n 1 > qr_output.txt
    #result=$(zbarimg --raw /tmp/qr.jpg)
}

function qrcapture {


if ! which zbarcam >$dn 2>&1 ; then
   yesorno "zbarcam is not installed. Would you like to install it?" || return 1
   install_qrcapture
fi

fifo="$tmp/qr_fifo"
rm -f "$fifo"
mkfifo "$fifo"

zbarcam --raw > "$fifo" &
pid=$!

IFS= read -r result < "$fifo"

kill "$pid" 2>/dev/null
rm -f "$fifo"

if [[ -z $1 ]] ; then
    
    announce "QR code results:

$green
$result
$orange

    You have options...

          <enter>    Do nothing and move on
          f)         Save restuls to ~/Desktop/qrresult.txt
"
case $enter_cont in
    f)
        echo "$result" > ~/Desktop/qrresult.txt
        announce "Saved to ~/Desktop/qrresult.txt"
        ;;
    *)
        ;;
esac

elif [[ $1 == "sdout" ]] ; then
    echo "$result"
else
    echo "$result"
    enter_continue
fi


}