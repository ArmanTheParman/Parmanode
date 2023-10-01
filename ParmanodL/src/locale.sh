function set_locale {

if [[ $OS == Linux ]] ; then
sudo chroot /tmp/mnt/raspi /bin/bash -c 'raspi-config nonint do_change_locale en_US.UTF-8'
fi

if [[ $OS == Mac ]] ; then
docker exec -it ParmanodL /bin/bash -c "chroot /tmp/mnt/raspi /bin/bash -c 'raspi-config nonint do_change_locale en_US.UTF-8'"
fi

}


