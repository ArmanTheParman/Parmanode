manage_users_pi {

# parman user

echo "parman:x:1001:996::/home/parman:/bin/bash" | sudo tee /tmp/mnt/raspi/etc/passwd
echo "parman ALL=(ALL:ALL) ALL" | sudo tee /tmp/mnt/raspi/etc/sudoers

# pi user

rm -rf /tmp/mnt/raspi/home/pi

# rpi-first-boot-wizard user

rm -rf /tmp/mnt/raspi/home/rpi-first-boot-wizard




echo "parman:$6$zRPK7zBj$GZt6bG5ZzAh8.FpzgA0GNy2K2gQo5HAA8.JmP./7Be2xfZtB.YBQrTJbKcVgJqzozc8O3A1R15vDxJ358xurN.:0:0:99999:7:::" >> /path_to_mounted_image/etc/shadow

}