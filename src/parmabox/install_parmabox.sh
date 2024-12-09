function install_parmabox {

if ! which docker > $dn ; then announce \
"Por favor, instale primeiro o Docker a partir do menu de instalação da Parmanode."
return 1
fi

if ! docker ps >$dn ; then announce \
"Por favor, certifique-se de que o Docker está a funcionar primeiro."
return 1
fi

if docker ps | grep -q parmabox ; then 
announce "O contentor parmabox já está a funcionar."
return 1
fi

if [[ $1 != silent ]] ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    TL;DR - Prima$green <enter>$orange para a instalação predefinida (recomendado).


    Pretende instalar um ParmaBox (um contentor Ubuntu Docker) sem qualquer configuração 
    ou opções de menu, que irá gerir, utilizar e limpar sozinho?

    Esta opção é mais rápida (Digite$cyan boring$orange e depois$cyan <enter>$orange).

    Ou continuar com a ParmaBox predefinida com mais funcionalidades e configurações 
    (basta carregar em$cyan <enter>$orange)?

########################################################################################
"
read choice ; set_terminal 
jump $choice || { invalid ; continue ; } ; set_terminal
break
done
else choice=${1} 
fi

case $choice in 
boring|Boring) local pbox=boring ;;
silent|*)
set_terminal ; echo -e "
########################################################################################

    O Parmabox terá um utilizador chamado 'parman'.
    
    A dada altura, durante o processo de instalação, poderá ser-lhe pedida a palavra-passe.

    A palavra-passe é$cyan ' parmanode'$orange.

########################################################################################
"
enter_continue

mkdir $HOME/parmanode/parmabox >$dn
;;
esac


installed_config_add "parmabox-start"

clear

case $choice in 
boring)
docker run -d --name parmabox ubuntu tail -f /dev/null
;;
*)
please_wait
parmabox_build || { enter_continue && announce "a construção falhou" && return 1 ; }
parmabox_run
parmabox_exec
;;
esac

installed_config_add "parmabox-end"

if [[ $1 != silent ]] ; then

    success "A sua ParmaBox" " está a ser instalada" 
    if [[ $choice != boring ]] ; then
    set_terminal ; echo -e "
########################################################################################

    O diretório $HOME/parmanode/parmabox na sua máquina anfitriã é montado 
    no diretório /mnt dentro do contentor ParmaBox Linux. 
    Se mover um ficheiro para lá, este ficará acessível em ambas as localizações.

    O utilizador root está disponível para utilização, bem como o utilizador parman, com a 
    palavra-passe $cyan ' parmanode'$orange.

    O software parmanode também está disponível dentro do contentor em:

    /home/parman/parman_programs/parmanode 

    - a um pouco de ParmInception ;)

    O software ParmaShell é instalado para tornar a experiência do terminal um pouco mais agradável.

########################################################################################
"
    enter_continue ; jump $enter_cont
    fi
fi
}
