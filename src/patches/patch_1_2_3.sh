function patch_1 { debugf

turn_off_spotlight
add_rp_function
parmanode_conf_add "patch=1"
debug end patch 1
}

function patch_2 { debugf

sudo_check # needed for preparing drives etc.
gpg_check  # needed to download programs from github
curl_check # needed to download things using the command prompt rather than a browser.
which_computer_type

parmanode_conf_remove "patch=1"
parmanode_conf_add "patch=2"
debug end patch  2
}

function patch_3 { debugf


if [[ -e $ic ]] ; then

    if grep -q electrum-end $ic || \
    grep -q sparrow-end  $ic || \
    grep -q specter-end  $ic || \
    grep -q bitbox-end   $ic || \
    grep -q trezor-end   $ic || \
    grep -q ledger-end   $ic ; then

        if ! grep -q "udev-end" $ic && [[ $OS == Linux ]] ; then
            installed_conf_add "udev-end"
        fi
    fi

fi

#needed to fix a variable bug in lnd log trap
parmanode_conf_remove "patch="
parmanode_conf_add "patch=3"
debug "patch 3"
}
