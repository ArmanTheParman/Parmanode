function menu_parmabox {
if ! grep -q "parmabox-end" $ic ; then return 0 ; fi
while true ; do 
if ! docker ps >$dn 2>&1 ; then
    dockerrunning="
                              ${red}Aviso: O Docker não está a funcionar${orange}
    "
else

   if ! docker ps | grep -qi parmabox ; then
   dockerrunning="
                              ${red}Aviso: O contentor ParmaBox não está a funcionar${orange}
   " 
   else
   dockerrunning="
                              ${green}O ParmaBox está a funcionar${orange}
   " 
   fi

fi

set_terminal ; echo -ne "
########################################################################################
              $cyan                     Menu ParmaBox            $orange                   
########################################################################################

                              $dockerrunning 
$cyan
            r) $orange        Iniciar sessão no contentor como root
$blue                              A palavra-passe é 'parmanode' 
$cyan
            pm)$orange        Inicie sessão no contentor como parman (escreva exit para 
                              regressar aqui)
$blue                              A palavra-passe é 'parmanode' 
$cyan
            s)$orange         Parar o contentor
$cyan
            rs)$orange        Reiniciar o contentor
$cyan
            u)$orange         Executar uma atualização do Parmanode e do SO dentro do 
                              contentor
$cyan
            rf)$orange        Atualizar a ParmaBox (recomeça e inclui novas actualizações)

$orange

########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) menu_use ;; 
r|R) 
docker exec -it -u root parmabox /bin/bash ;;
pm) 
docker exec -it -u parman parmabox /bin/bash ;;
s) 
stop_parmabox ;;
rs) 
start_parmabox ;;
u) 
docker exec -it -u root parmabox bash -c "apt update -y && apt -y upgrade" 
echo "Update Parmanode..."
docker exec -it -u parman parmabox bash -c "cd /home/parman/parman_programs/parmanode ; git pull"
sleep 2
;;
rf)
parmabox_refresh
;;
*)
invalid
;;

esac
done
} 

function start_parmabox {
docker start parmabox >$dn 2>&1
}
function stop_parmabox {
docker stop parmabox >$dn 2>&1
}
