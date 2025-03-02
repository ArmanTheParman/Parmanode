function mount_RAID {

#used when installing
if [[ -n $1 ]] ; then
sudo mount $1 $2
debug "mounted?"
return 0
fi

#used if there is more than one RAID in parmanode.conf
if [[ $(grep raid $pc | wc -l) -gt 1 ]] ; then
announce  "Please choose which number RAID you want to mount:
    
$(grep raid $pc | grep -n raid)
"

raid_choice=$enter_cont

else
#used if there is only one raid in parmanode.conf
sudo mount \
   $(grep raid= $pc | cut -d = -f 2 | cut -d @ -f 1) \
   $(grep raid= $pc | cut -d @ -f 2) 
fi
}