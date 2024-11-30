function back2main {

export main_loop=$((main_loop + 1)) 
if [[ $main_loop -gt 50 ]] ; then
announce "A função do menu principal chamou-se a si própria demasiadas vezes.
É provavelmente uma boa ideia sair do Parmanode e reiniciá-lo 
- isto irá libertar alguma da memória do computador."
fi
menu_main

#redundant...
exit
}
