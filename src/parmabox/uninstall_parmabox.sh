function uninstall_parmabox {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Desinstalar ParmaBox 
$orange
    Tens a certeza? (y) (n)

########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) backtomain ;;
y) break ;;
n) return 1 ;;
*) invalid ;;
esac
done
if ! docker ps >$dn ; then announce \
"Certifique-se de que o Docker está a funcionar antes de pedir à Parmanode para limpar 
    o ParmaBox instalado."
return 1
fi

docker stop parmabox 
docker rm parmabox 
docker rmi parmabox

yesorno "Pretende apagar este diretório também no seu sistema?
$cyan     
        $HOME/parmanode/parmabox $orange" && sudo rm -rf $HOME/parmanode/parmabox >$dn

installed_config_remove "parmabox"
success "ParmaBox" " a ser desinstalado"

}
