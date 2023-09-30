function set_keyboard {
sudo chroot /tmp/mnt/raspi /bin/bash -c 'raspi-config nonint do_configure_keyboard us'
}
function set_timezone {
sudo chroot /tmp/mnt/raspi /bin/bash -c 'raspi-config nonint do_change_timezone Etc/UTC'
}
function set_wifi_country {
sudo chroot /tmp/mnt/raspi /bin/bash -c 'raspi-config nonint do_wifi_country US'
}
function set_locale {
sudo chroot /tmp/mnt/raspi /bin/bash -c 'raspi-config nonint do_change_locale en_US.UTF-8'
}