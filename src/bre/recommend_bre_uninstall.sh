function recommend_bre_uninstall {
if grep -q "bre-end" $ic && ! grep "bre-ignore=true" $hm ; then
    announce "${red}Warning$orange - Parmanode has detected that you have BTC RPC Explorer
    installed on your system. It has come to light that the package manager
    that is necessary to install this program has been exposed to security
    breaches. It is recommended that you uninstall BTC RPC Explorer from the
    Parmanode 'remove' menu. Type 'ignore' to not see this message again."

    if [[ $enter_cont == "ignore" ]] ; then
    echo "bre-ignore=true" | tee -a $hm >$dn 2>&1
    fi
fi
}