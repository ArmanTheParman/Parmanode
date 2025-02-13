
function max_upload_file_size_info {
set_terminal ; echo -e "$blue
########################################################################################

    Google it.

########################################################################################
"
enter_continue ; jump $enter_cont
set_terminal ; echo -e "$blue
########################################################################################
$pink
    Just kidding!
$blue
    You need to edit the php.ini file. There are more than one of these, you go 
    need to edit the correct one. It should be in...
$orange
        /etc/php/${red}7.4$orange/fpm/php.ini
$blue
    Obviously, if a new version comes out, you need to change$red 7.4$blue to the 
    right number. Also, make sure you are in the fpm subdirectory no cli, as there is
    a php.ini file in there as well, but it's not the one you need.

    Then in the file edit the values of: $orange
        
        post_max_size=
$blue& $orange
        upload_max_filesize= $blue
    
    Then save the file and restart php... $orange

        sudo systemctl restart php7.4-fpm.service $blue

    In case the file name changes type up to php7 and then hit <tab> to autocomplete.

########################################################################################
" ; enter_continue ; jump $enter_cont

return 0
}