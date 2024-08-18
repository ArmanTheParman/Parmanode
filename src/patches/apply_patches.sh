function apply_patches {
#patches ; each patch adds variable to parmanode.conf, sourced higher up
#patch=n
#get $patch from parmanode.conf
temp_patch
openssh_patch
make_parmanode_service #Linux only
echo "choose add (a) or remove (r)"
read choice
case $choice in
a) make_tor_script_mac;;
r)   
sudo cat /etc/crontab | sudo sed '/REMOVE_TOR_FLAG/d' | sudo tee /tmp/crontab >/dev/null && \
sudo mv /tmp/crontab /etc/crontab
;;
esac

#make_parmanode_tor_service
#hello

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
}
