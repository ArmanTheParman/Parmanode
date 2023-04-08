#Dependent or user input from calling function.

function make_directories () {

install_program="$1" #could be parmanode, could be bitcoin

drive="$2" #could be internal could be external
set_terminal

if [[ $1 == "parmanode" ]]  
    then 
    home_parmanode_directories #make parmanode and .parmanode 
    read
fi 

return 0
}
