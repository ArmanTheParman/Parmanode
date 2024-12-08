function make_bitcoin_symlinks {
set_terminal

while true ; do

if [[ $btcpayinstallsbitcoin == "true" ]] ; then return 0 ; fi

if [[ $OS == "Linux" && $drive == "internal" ]] ; then
    return 0 
    #no symlink needed
    fi

if [[ $OS == "Linux" && $drive == "external" ]] ; then
    cd $HOME && ln -s /media/$(whoami)/parmanode/.bitcoin/ .bitcoin  
    break  #symlink can be made without errors even if target doesn't exist yet
    fi

if [[ $OS == "Mac" && $drive == "internal" ]] ; then
    cd $HOME/Library/"Application Support"/ ; rm -rf  Bitcoin
    cd $HOME/Library/"Application Support"/ && ln -s $HOME/.bitcoin Bitcoin 
    break
    fi

if [[ $OS == "Mac" && $drive == "external" ]] ; then
    cd $HOME/Library/Application\ Support/ >$dn 2>&1 && rm -rf Bitcoin >$dn 2>&1 
    cd $HOME && rm -rf .bitcoin >$dn 2>&1 
    cd $HOME/Library/Application\ Support/ && ln -s /Volumes/parmanode/.bitcoin Bitcoin && \
    cd $HOME && ln -s $parmanode_drive/.bitcoin .bitcoin 
    break
    fi
done

if [[ $btcdockerchoice != "yes" && $btcpayinstallsbitcoin != "true" ]] ; then
set_terminal ; echo -e "
########################################################################################

                                $cyan 
                                 Ligações simbólicas criadas
$orange
    NADA A FAZER, É APENAS PARA VOSSA INFORMAÇÃO, CASO QUEIRAM.

    Foi criada uma ligação simbólica para o diretório de dados.

    Para unidades externas, $HOME/.bitcoin aponta para
$green
            $parmanode_drive/.bitcoin
$orange
    Para os utilizadores de Mac com uma unidade interna, 
    $HOME/Library/Application Support/Bitcoin (a localização predefinida), 
    aponta agora para:
$green
            $HOME/.bitcoin
$orange
########################################################################################
"
enter_continue
fi #end btcdockerchoice

set_terminal
return 0
}
