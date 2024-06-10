function nextcloud_intro {
while true ; do
set_terminal_custom 50 ; echo -e "
########################################################################################
$cyan
                                N E X T C L O U D
$orange 
########################################################################################
    
    NextCloud is software that allows your to run your own cloud service for your
    files yourself. Sort of like your own Google Drive.

    The software is free to install manually yourself independently to Parmanode.
    If you would like Parmanode to do it for you and make it easy, then there is a
    very smol fee (honesty system).

    It's$green 20,000 sats$orange, please pay using my donation page: $cyan

        https://armantheparman.com/donations $orange

    Much thanks :)

    Continue? $green

            y)          Yeah, this is great 
$red              
            n)          Nah, maybe later, too good to be true
$orange

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in q|Q) exit 0 ;; p|P|n|N) return 1 ;; y|Y|yes) return 0 ;; m|M) back2main ;; *) invalid ;; esac
done
}