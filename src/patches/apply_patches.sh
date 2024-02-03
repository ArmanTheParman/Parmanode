function apply_patches {
#patches ; each patch adds variable to parmanode.conf, sourced higher up
#patch=n

temp_patch

case $patch in
1) 
patch_2 ; patch_3 ; patch_4 ; patch_5 ;;
2)
patch_3 ; patch_4 ; patch_5 ;;
3)
patch_4 ; patch_5 ;;
4)
patch_5 ;;
5)
true ;;
*) 
patch_1 ; patch_2 ; patch_3 ; patch_4 ; patch_5 ;; 
esac
}