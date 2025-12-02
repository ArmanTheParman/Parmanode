function usb_quirk_patch { debugf
# This script is not to be trusted, it is kept her for reference and education.
# Testing is needed and may be incorporated into Parmanode for Pi's later.
return 0

set -e

cmdline=/boot/firmware/cmdline.txt

# find USB storage devices using UAS
uas_list=$(lsusb -t | grep -i uas || true)
[[ -z "$uas_list" ]] && exit 0   # nothing to patch

# get VID:PID from lsusb
mapfile -t devices < <(lsusb | grep -Ei "Mass|SanDisk|Samsung|WD|Seagate")

for d in "${devices[@]}"; do
    vid=$(printf "%s" "$d" | awk '{print $6}' | cut -d: -f1)
    pid=$(printf "%s" "$d" | awk '{print $6}' | cut -d: -f2)

    entry="usb-storage.quirks=${vid}:${pid}:u"

    # skip if already present
    if grep -q "$entry" "$cmdline"; then
        continue
    fi

    # insert quirk (append to end, preserving all existing boot flags)
    sudo sed -i "s|$| ${entry}|" "$cmdline"
done
}