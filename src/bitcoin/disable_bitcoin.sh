function toggle_disable_bitcoin {


if grep -q "disable_bitcoin=true" $pc ; then

    if grep -q btccombo $ic ; then
        docker exec -u root btcpay bash -c "chmod +x /usr/local/bin/bitcoin*" && \
        gsed -i "/disable_bitcoin=true/d" $pc && \
        success "Bitcoin Enabled" 
        return 0
    fi

    if [[ $OS == "Mac" ]] ; then 
        sudo chmod +x /Applications/Bitcoin-Qt.app && \
        gsed -i "/disable_bitcoin=true/d" $pc && \
        success "Bitcoin Enabled" 
        return 0
    fi

    if [[ $OS == "Linux" ]] ; then 
        sudo chmod +x /usr/local/bin/bitcoin* && \
        gsed -i "/disable_bitcoin=true/d" $pc && \
        success "Bitcoin Enabled" 
        return 0
    fi

    return 0

else

    stop_bitcoin
    while true ; do
        clear
        if tmux ls 2>$dn | grep -q "stopping_bitcoin" ; then
            sleep 1
            echo "Waiting for bitcoin to stop"
        else 
            break
        fi
    done

    if grep -q btccombo $ic ; then
        docker exec -u root btcpay bash -c "chmod -x /usr/local/bin/bitcoin*" && \
        echo "disable_bitcoin=true" >> $pc && \
        success "Bitcoin Disabled" 
        return 0
    fi

    if [[ $OS == "Mac" ]] ; then 
        sudo chmod -x /Applications/Bitcoin-Qt.app && \
        echo "disable_bitcoin=true" >> $pc && \
        success "Bitcoin Disabled" 
        return 0
    fi

    if [[ $OS == "Linux" ]] ; then 
        sudo chmod -x /usr/local/bin/bitcoin* && \
        echo "disable_bitcoin=true" >> $pc && \
        success "Bitcoin Disabled" 
        return 0    
    fi
fi
}