function rp_counter {
rp_count=$((rp_count + 1))
parmanode_conf_remove "rp_count" #necessary because cleanup function inside parmanode_conf_add
                                 #detects what is being added, and deletes first in case there 
                                 #are multiples, but in this usage, the argument is iterative
                                 #so it will always be different. Without it, rp_count=1, rp_count=2
                                 #etc will be added ongoing, with no clean up.
parmanode_conf_add "rp_count=$rp_count"
}
