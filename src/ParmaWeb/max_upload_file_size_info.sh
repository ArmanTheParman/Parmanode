
function max_upload_file_size_info {
set_terminal ; echo -e "
########################################################################################

    Google it.

########################################################################################
"
enter_continue
set_terminal ; echo -e "
########################################################################################
$pink
    Just kidding!
$orange
    You need to edit the php.ini file. There are more than one of these, you go 
    need to edit the correct one. It should be in...
$cyan
        /etc/php/${red}7.4$cyan/fpm/php.ini
$orange
    Obviously, if a new version comes out, you need to change$red 7.4$orange to the 
    right number. Also, make sure you are in the fpm subdirectory no cli, as there is
    a php.ini file in there as well, but it's not the one you need.

    Then in the file edit the values of: $cyan
        
        post_max_size=
$orange& $cyan
        upload_max_filesize= $orange
    
    Then save the file and restart php... $cyan

        sudo systemctl restart php7.4-fpm.service $orange

    In case the file name changes type up to php7 and then hit <tab> to autocomplete.

########################################################################################
" ; enter_continue

return 0
}