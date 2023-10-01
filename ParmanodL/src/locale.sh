function set_locale {

if [[ $OS == Linux ]] ; then
sudo chroot /tmp/mnt/raspi /bin/bash -c 'raspi-config nonint do_change_locale en_US.UTF-8'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'raspi-config nonint do_wifi_country US'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'raspi-config nonint do_change_timezone Etc/UTC'
sudo chroot /tmp/mnt/raspi /bin/bash -c 'raspi-config nonint do_configure_keyboard us'

fi

if [[ $OS == Mac ]] ; then
docker exec -it ParmanodL /bin/bash -c "chroot /tmp/mnt/raspi /bin/bash -c 'raspi-config nonint do_change_locale en_US.UTF-8'"
docker exec -it ParmanodL /bin/bash -c "chroot /tmp/mnt/raspi /bin/bash -c 'raspi-config nonint do_wifi_country US'"
docker exec -it ParmanodL /bin/bash -c "chroot /tmp/mnt/raspi /bin/bash -c 'raspi-config nonint do_change_timezone Etc/UTC'"
docker exec -it ParmanodL /bin/bash -c "chroot /tmp/mnt/raspi /bin/bash -c 'raspi-config nonint do_configure_keyboard us'"
fi

}