function command_tip {
# $1 = for hiding
# $2 = the command
# $3 = goback signal -- need code to hand that from calling function

set_terminal 

if [[ -n $3 ]] ; then goback="Hit $3 to go back" ; fi

if grep -q "$1" $hc ; then return 0 ; fi
announce "The command that will run:\n
$cyan
    $2
$red
    Type 'hide' to not see this tip anymore.
    To undo this action, just manually delete the text,$green $1 $red
    from $dp/hide_commands.conf 
$orange
    $goback$orange
"

unset goback ; jump $enter_cont ; clear

[[ $enter_cont == "$3" ]] && return 1 #need || after command_tip call for this to do anything

return 0
}