function apply_patches {
#patches ; each patch adds variable to parmanode.conf, sourced higher up
#patch=n
#get $patch from parmanode.conf
temp_patch
#debug "1"
openssh_patch
#debug "2"
make_parmanode_service #Linux only
#debug "3"
make_tor_script_mac
#debug "4"
make_parmanode_tor_service  #makes parmanode tor onion address
#debug "5"
hello
#debug "6"
suggest_brew
#debug "7"

case $patch in 
1) 
patch_2 ; patch_3 ; patch_4 ; patch_5 ; patch_6 ;;
2)
patch_3 ; patch_4 ; patch_5 ; patch_6 ;;
3)
patch_4 ; patch_5 ; patch_6 ;;
4)
patch_5 ; patch_6 ;;
5)
patch_6 ;;
6)
return 0 ;;
*) 
patch_1 ; patch_2 ; patch_3 ; patch_4 ; patch_5 ; patch_6 ;; 
esac
debug "8"
}
