function p4run_maker {

file="$pn/src/parmanode4/p4run"
filefinal=/usr/local/bin/p4run
hash=xxx
grep -q "$hash" <(shasum -a 256 "$file") || return 1

#put scrpt in secure place
sudo cp -f "$file" "$filefinal"
sudo chown root:root "$filefinal"
sudo chmod 4710 "$filefinal"

if ! sudo test -f /etc/sudoers.d/parmanode || ! sudo grep -q "/usr/local/bin/p4run" /etc/sudoers.d/parmanode ; then 
    #all script to run without password, but only from secure location
    sudoers_patch
fi

}