function report_2025 {
if [[ $1 == report ]] ; then

    echo "$macprefix" | tee -a $HOME/Desktop/report.txt

    echo "$varlibtor" | tee -a $HOME/Desktop/report.txt

    if sudo cat $varlibtor/electrs-service/hostname >/dev/null ; then
    sudo cat $varlibtor/electrs-service/hostname | tee -a $HOME/Desktop/report.txt
    fi

    if sudo cat $torrc >/dev/null ; then
    sudo tail -n30 $torrc | tee -a $HOME/Desktop/report.txt
    fi

fi
}