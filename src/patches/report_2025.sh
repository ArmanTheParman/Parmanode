function report_2025 {

    echo "Macprefix is... $macprefix" | tee -a $HOME/Desktop/report.txt >/dev/null

    echo "Varlib tor variable ...$varlibtor" | tee -a $HOME/Desktop/report.txt >/dev/null

    if sudo cat $varlibtor/parmanode-service/hostname >/dev/null 2>&1 ; then
    echo "Parmanode onion... " | tee -a $HOME/Desktop/report.txt >/dev/null
    sudo cat $varlibtor/parmanode-service/hostname | tee -a $HOME/Desktop/report.txt >/dev/null
    fi

    if sudo cat $varlibtor/electrs-service/hostname >/dev/null 2>&1 ; then
    echo "Electrs onion... " | tee -a $HOME/Desktop/report.txt >/dev/null
    sudo cat $varlibtor/electrs-service/hostname | tee -a $HOME/Desktop/report.txt >/dev/null
    fi

    if sudo cat $torrc >/dev/null ; then
    echo -e "############################## torrc ###################################################" | tee -a $HOME/Desktop/report.txt >/dev/null
    sudo cat $torrc | tee -a $HOME/Desktop/report.txt >/dev/null
    fi

    echo "Report done. See Desktop for report.txt"
    enter_continue

}