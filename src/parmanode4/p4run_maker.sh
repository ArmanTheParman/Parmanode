function p4run_maker {

file=$pn/src/parmanode4/p4run
hash=xxx
grep -q $hash <(shasum -a 256 $file) || return 1

#put scrpt in secure place
sudo cp -rf $file /usr/local/bin/

if ! sudo test -f /etc/sudoers.d/parmanode || ! sudo grep -q "/usr/local/bin/p4run" /etc/sudoers.d/parmanode ; then {
    #all script to run without password, but only from secure location
    sudoers_patch
}
fi

}