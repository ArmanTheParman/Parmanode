function set_locale {

# if [[ $OS == Linux ]] ; then
# sudo chroot /tmp/mnt/raspi /bin/bash -c 'raspi-config nonint do_change_locale en_US.UTF-8 2>/dev/null'
# sudo chroot /tmp/mnt/raspi /bin/bash -c 'raspi-config nonint do_wifi_country US 2>/dev/null'
# sudo chroot /tmp/mnt/raspi /bin/bash -c 'raspi-config nonint do_change_timezone Etc/UTC 2>/dev/null'
# sudo chroot /tmp/mnt/raspi /bin/bash -c 'raspi-config nonint do_configure_keyboard us 2>/dev/null'

# fi

# if [[ $OS == Mac ]] ; then
docker exec -it ParmanodL /bin/bash -c "chroot /tmp/mnt/raspi /bin/bash -c 'raspi-config nonint do_change_locale en_US.UTF-8 2>/dev/null'"
docker exec -it ParmanodL /bin/bash -c "chroot /tmp/mnt/raspi /bin/bash -c 'raspi-config nonint do_wifi_country US 2>/dev/null'"
docker exec -it ParmanodL /bin/bash -c "chroot /tmp/mnt/raspi /bin/bash -c 'raspi-config nonint do_change_timezone Etc/UTC 2>/dev/null'"
docker exec -it ParmanodL /bin/bash -c "chroot /tmp/mnt/raspi /bin/bash -c 'raspi-config nonint do_configure_keyboard us 2>/dev/null'"
# fi

}