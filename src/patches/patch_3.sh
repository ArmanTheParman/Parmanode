function patch_3 {

if grep -q electrum-end < $dp/installed.conf ; then
    if ! grep -q udev-end <$dp/installed.conf ; then
        installed_conf_add "udev-end"
    fi

if grep -q sparrow-end < $dp/installed.conf ; then
    if ! grep -q udev-end <$dp/installed.conf ; then
        installed_conf_add "udev-end"
    fi

if grep -q specter-end < $dp/installed.conf ; then
    if ! grep -q udev-end <$dp/installed.conf ; then
        installed_conf_add "udev-end"
    fi

}