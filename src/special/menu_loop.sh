#do loop, no sourcing

function do_loop_ns {
exit_loop=false 

while [[ $exit_loop == false ]] ; do
exit_loop=true
menu_main $@
done

exit



}