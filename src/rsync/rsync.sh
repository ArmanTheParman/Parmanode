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

    There are two possible scenarios which must be chosen from:
$green
    Scenario 1) $orange
        The source and the destination directories already exist but the contents 
        may be a bit different.
$green
    Secenario 2) $orange
        The destination directory does not exist, the source directory will be copied
        to the new location.

    Which is it?  $green 1$orange or$green 2$orange ? 
########################################################################################
"
choose "x"
read scenario
case $scenario in
1|2) break ;;
*) invalid ;;
esac ; done

clear
echo -e "
########################################################################################

    Type in the full path to the source directory (where files are to be copied FROM).
    e.g. 

$example1
"
read source

case $scenario in
1)
echo -e "
    Now type in the full path where you want the directory to be synced to. The
    contents of this directory will become the same as the source directory."
read destination
;;

2)
echo -e "
    Now type in the full path where you want the directory to be copied to.
    You shouldn't type in the name of the source directory, just where it's going."
read destination

clear
esac

case $scenario in
1)
echo -e "
########################################################################################
$orange
    Ignore newer files in destination?$green (y)$orange or$red (n)$orange:

########################################################################################
"
choose "x"
read update
if [[ $update == "y" ]] ; then update="u" ; else update="" ; fi
clear
echo -e "
########################################################################################

    Delete unique files in the destination?$red (y)$orange or$green (n) : 

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
    
    Dry run?$green (y)$orange or$red (n)

########################################################################################
"
choose "x"
read dry
if [[ $dry == "y" ]] ; then dry="--dry-run" ; else dry="" ; fi
clear
echo -e "
########################################################################################
    
    Exclude hidden files in path root$green (r)$orange, root & subdirectories$bright_blue 
    (s)$orange or none$red (n)$orange?

########################################################################################
"
choose "x"
read hidden 
       if [[ $hidden == r ]] ; then hidden="--exclude '/.*'" 
     elif [[ $hidden == s ]] ; then hidden="-exclude '.*'"
     else                           hidden=""
       fi
set_terminal_wide
echo "
##############################################################################################################

    The commands are ready. It includes the default options:

    Verbose mode     (-v) 
    Archive mode     (-a)  permissions, ownership, timestamps, + other attributes of the source files.
    Recursive mode   (-r) 
    Compress mode    (-z) 
    Shoe progress    (-P) 

    You can remove any of these if you wish.

    The proposed command for you to copy, paste, and execute is...

$green
rsync -rvarzP$update $del $dry $hidden --ignore-existing $source/ $destination/ 
$orange
...then the directories in reverse 
(otherwise unique files in the destination are not copied to the source)...
$green
rsync -rvarzP$update $del $dry $hidden --ignore-existing $destination/ $source/ 
$orange
##############################################################################################################
"
enter_continue
set_terminal
return 0
}

### a '/' traliling slash specifies the contents of the directory.

