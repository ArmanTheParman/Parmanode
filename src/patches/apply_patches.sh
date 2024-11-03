function apply_patches {
#patches ; each patch adds variable to parmanode.conf, sourced higher up
#patch=n
#get $patch from parmanode.conf
temp_patch
openssh_patch
make_parmanode_service #Linux only
make_tor_script_mac
make_parmanode_tor_service  #makes parmanode tor onion address
hello
suggest_brew

debug "before patch sequence"

case $patch in 
1) 
debug "case1"
patch_2 ; patch_3 ; patch_4 ; patch_5 ; patch_6 ;;
2)
debug "case2"
patch_3 ; patch_4 ; patch_5 ; patch_6 ;;
3)
debug "case3"
patch_4 ; patch_5 ; patch_6 ;;
4)
debug "case4"
patch_5 ; patch_6 ;;
5)
debug "case5"
patch_6 ;;
6)
debug "case6"
return 0 ;;
*) 
patch_1 ; patch_2 ; patch_3 ; patch_4 ; patch_5 ; patch_6 ;; 
esac
debug "end apply_patches"
}
