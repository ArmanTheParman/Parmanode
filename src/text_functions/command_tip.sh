function command_tip_blue {
# $1 = for hiding
# $2 = the command
# $3 = goback signal -- need code to hand that from calling function
# $4 = extra optional text

#skip if user has cancelled this popup
if grep -q "$1" $hc ; then return 0 ; fi

extra_text="\n$4\n"

set_terminal 

if [[ -n $3 ]] ; then goback="Hit $3 to go back" ; fi

if grep -q "$1" $hc ; then return 0 ; fi
announce_blue "The command that will run:\n
$cyan
    $2
$red
    Type 'hide' to not see this tip anymore.
    To undo this action, just manually delete the text,$green $1 $red
    from $dp/hide_commands.conf 
$blue
    $goback $extra_text
"

unset goback ; jump $enter_cont ; clear

case $enter_cont in
"$3")
return 1 #need || after command_tip call for this to do anything
;;
hide)
echo "$1" | tee -a $hc >$dn 2>&1
;;
esac

return 0
}