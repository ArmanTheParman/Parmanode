function rsync {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                            Parman's Easy AF Rsync Tool

$orange
    Rsync is a powerful open source program that lets you synchronise 2 directories.

    Then can be on the same computer, same or different connected drives, or even 
    across different computers communicating over a network.

    Parmanode will help you perform a task to sync two different directories on the
    same computer. More features may be added later, or you can read the rsync manual
    and do it completely on your own without the help of Parmanode if you're keen and
    tech savvy.

$green
    This wizard will ask you questions, and then based on your answers provide you 
    with a command for you to copy and paste into the terminal.
$orange

########################################################################################
"
enter_abort
read choice ; case $choice in a|A) return 1 ;; "") break ;; esac ; done
clear

if [[ $OS == Mac ]] ; then
example1="    /Users/your_username/my_directory"
example2="    /Volumes/my_external_drive/my_directory"
elif [[ $OS == Linux ]] ; then
example1="    /home/your_username/my_directory"
example2="    /media/your_username/my_external_drive/my_directory"
else
echo "error" ; sleep 4
return 1
fi
clear
while true ; do
echo -e "
########################################################################################

    There are two possible scenarios to be chosen from:
$green
    Scenario 1) $orange
        The source and the destination directories already exist but the contents 
        may be a bit different.
$green
    Secenario 2) $orange
        The destination directory does not exist, the source directory will be copied
        to the new location.

    Which is it? $blue 1$orange or$blue 2$orange ? 

########################################################################################
"
choose "x"
read scenario


case $scenario in
1|2) break ;;
*) invalid ;;
esac ; done

unset source
while true ; do
if [[ -z $source ]] ; then
clear
echo -e "
########################################################################################

    Type in the full path to the source directory (where files are to be copied$green FROM$orange).
    e.g. 
$blue
$example1
$orange
########################################################################################
"
read source
check_for_validity $source || { unset source ; continue ; }
fi

case $scenario in
1)
echo -e "
########################################################################################

    Now type in the full path where you want the directory to be synced$green TO$orange. The
    contents of this directory will become the same as the source directory.

########################################################################################

"
read destination
check_for_validity $destination || continue
break
;;

2)
echo -e "
########################################################################################

    Now type in the full path where you want the directory to be copied to.
    You shouldn't type in the name of the source directory, just where it's going.

########################################################################################

"
read destination
check_for_validity $destination || continue
clear
break
esac
done

case $scenario in
1)
echo -e "
########################################################################################
$orange
    Ignore newer files in destination?$green (y)$orange or$red (n)$orange

########################################################################################
"
choose "x"
read update
if [[ $update == "y" ]] ; then update="u" ; else update="" ; fi
clear
echo -e "
########################################################################################

    Delete unique files in the destination?$red (y)$orange or$green (n)$orange  

########################################################################################
"
choose "x"
read del
if [[ $del == "y" ]] ; then del="--delete" ; else del="" ; fi
clear
;;
esac
echo -e "
########################################################################################
    
    Dry run?$green (y)$orange or$red (n)$orange

########################################################################################
"
choose "x"
read dry
if [[ $dry == "y" ]] ; then dry="--dry-run" ; else dry="" ; fi
clear
echo -e "
########################################################################################
    
    Exclude hidden files in the:

         path root$green (r)$orange 
         root & subdirectories$bright_blue (s)$orange 
         none$red (n)$orange

########################################################################################
"
choose "x"
read hidden 
       if [[ $hidden == r ]] ; then hidden="--exclude '/.*'" 
     elif [[ $hidden == s ]] ; then hidden="-exclude '.*'"
     else                           hidden=""
       fi

case $scenario in
1)
command1="rsync -rvazP$update $del $dry $hidden --ignore-existing $source/ $destination/"
command2="
    ...then the directories in reverse 
    (otherwise unique files in the destination are not copied to the source)...
$green
    rsync -rvazP$update $del $dry $hidden --ignore-existing $destination/ $source/ 
$orange"
;;

2)
command1="rsync -rvarzP$update $del $dry $hidden --ignore-existing $source $destination/"
;;
esac

set_terminal_wide
echo -e "
##############################################################################################################

    The commands are ready. It includes the default options:

    Verbose mode     (-v) 
    Archive mode     (-a)        permissions, ownership, timestamps, + other attributes of the source files.
    Recursive mode   (-r) 
    Compress mode    (-z) 
    Show progress    (-P) 

    You can remove any of these if you wish.


    The proposed command for you to copy, paste, and execute is... 
$green
    $command1 $orange
    $command2 

$pink
    EXTRA INFO: 
        - If the source directory is actually a symlink, then add -L to the list of options in
          the provided command.
        - If the destination directory is a remote computer, you can add '-e ssh' after the options and
          then add username@IP_address: before the destination directory. Right after the ':' add a '/'
          and type out the full path.
$orange
##############################################################################################################
"
enter_continue
set_terminal
return 0
}

### a '/' traliling slash specifies the contents of the directory.

function check_for_validity {

if ! echo "$1" | grep -oqE ^/ ; then announce "directory must start with '/'" ; clear ; return 1 ; fi
if echo "$1" | grep -oqE /$ ; then announce "directory should not end with '/'" ; clear ; return 1 ; fi
clear
}
