function compile_bitcoin {
[[ $version == self ]] && return 0 
[[ $bitcoin_compile == "false" ]] && return 0 

#to reduce errors on screen, making temporary git variables...
    export GIT_AUTHOR_NAME="Temporary Parmanode"
    export GIT_AUTHOR_EMAIL="parman@parmanode.parman"
    export GIT_COMMITTER_NAME="Parmanode Committer"
    export GIT_COMMITTER_EMAIL="parman@parmanode.parman"

bitcoin_compile_dependencies || return 1

#for later when mac is supported
[[ $OS == "Mac" ]] && brew install berkeley-db@4

cd $hp || { enter_continue "Can't change directory. Aborting." ; return 1 ; }

[[ -e $hp/bitcoin_github ]] && sudo rm -rf $hp/bitcoin_github >$dn 2>&1

if [[ $knotsbitcoin != "true" ]] ; then  

    git clone https://github.com/bitcoin/bitcoin.git bitcoin_github || { announce "Algo correu mal com o download. Abortando." ; return 1 ; }
    
    cd $hp/bitcoin_github || { announce "Não é possível mudar para o diretório bitcoin_github. Abortando." ; return 1 ; }
    
    git checkout v$version || { announce "Não é possível efetuar o checkout para a versão especificada. Abortando." ; return 1 ; }

            #apply ordinals patch to v25 or v26
            if [[ $ordinals_patch == "true" ]] ; then
                git checkout -b parmanode_ordinals_patch
                curl -LO https://gist.githubusercontent.com/luke-jr/4c022839584020444915c84bdd825831/raw/555c8a1e1e0143571ad4ff394221573ee37d9a56/filter-ordinals.patch 
                git apply filter-ordinals.patch
                git add . ; git commit -m "ordinals patch applied"
            fi

elif [[ $knotsbitcoin == "true" ]] ; then  #compile bitcoin not true
    set_github_config
    if [[ -e $hp/bitcoinknots_github ]] ; then 
        cd $hp/bitcoinknots_github ; git fetch ; git pull ; git checkout origin/HEAD ; git pull 
    else
        cd $hp && git clone https://github.com/bitcoinknots/bitcoin.git bitcoinknots_github && cd bitcoinknots_github
    fi

fi 

#clean up variables
    unset GIT_AUTHOR_NAME
    unset GIT_AUTHOR_EMAIL
    unset export GIT_COMMITTER_NAME
    unset export GIT_COMMITTER_EMAIL


./autogen.sh || { enter_continue "Algo parece ter corrido mal. Proceder com cautela." ; }

while true ; do
set_terminal ; echo -e "
########################################################################################

    O Bitcoin pode ser compilado com ou sem uma interface gráfica de utilizador (GUI).

    O Parmanode não precisa de uma GUI, uma vez que é ele próprio a interface entre o 
    utilizador e as funções do nó - é em parte para isso que o Parmanode serve.

    Você escolhe...
$green
              1)   Compilar Bitcoin SEM uma GUI (recomendado, e mais rápido) 
$cyan
              2)   Compilar bitcoin COM uma GUI
$orange
########################################################################################
"
choose "xpmq" ; read choice
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;;
1) gui=no ; break ;;
2) gui=yes ; 
bitcoin_compile_dependencies "GUI" || return 1
break ;;
*) invalid ;;
esac
done


while true ; do
clear ; echo -e "
########################################################################################

   O comando configure que será executado é o seguinte: 

$cyan
   ./configure --with-gui=$gui --enable-wallet --with-incompatible-bdb --with-utils
$orange

   Prima$green <enter>$orange para continuar, ou,$yellow escreva em$orange opções adicionais 
   que possa ter pesquisado e que gostaria de incluir, depois carregue em$green <enter>$orange

########################################################################################
"
read options
clear
case $options in
"") break ;;
*)
clear
echo -e "
########################################################################################

    Introduziu $options

    Prima y para aceitar ou n para tentar novamente.

########################################################################################
"
    read choice
    case $choice in
    y) break ;; *) continue ;;
    esac
;;
esac
done

set_terminal

./configure --with-gui=$gui --enable-wallet --with-incompatible-bdb --with-utils $options || {
    enter_continue "Algo pode ter corrido mal."
}

echo -e "
########################################################################################

    Se não houver erros, prima $cyan<enter>$orange para continuar.

    Caso contrário, sai e corrige tu mesmo o erro, ou pede ajuda ao Parman através do 
    grupo de chat do Telegram.

########################################################################################
"
choose "epmq"
read choice
set_terminal
case $choice in
q|Q) exit ;; p|P|M|m) back2main ;;
esac

while true ; do
set_terminal
# j will be set to $(nproc) or user choice
echo -e "
########################################################################################

    Running make command...
$green
    make -j $(nproc)
$orange
    Se pretender substituir o valor j, prima 'o' agora; caso contrário, prima <enter> 
    para continuar.

$pink
    Para tua informação, o valor j é o número de núcleos de processadores a utilizar 
    para compilar. A Parmanode calculou o valor máximo para si.
$orange
########################################################################################
"
read choice
if [[ $choice != o ]] ; then j=$(nproc) ; break ; fi

clear
echo -e "
########################################################################################

    Introduza o valor$green j$orange que pretende utilizar e, em seguida, prima Enter.

########################################################################################
"
read j
set_terminal
echo -e "
########################################################################################

    Escolheu $j para o valor j. <enter> para continuar, ou$cyan n$orange e <enter> 
    para tentar novamente.

########################################################################################
"
read choice2
if [[ $choice2 == "" ]] ; then break ; fi
done
clear
echo "Executando o comando make, por favor aguarde..."
sleep 3

#compile
make -j $j || enter_continue "Algo pode ter corrido mal." 


set_terminal
echo -e "
########################################################################################
$cyan
    A fazer testes.$orange Só vai demorar alguns minutos. 

    A saída é guardada no ficheiro:
$green
    $HOME/.parmanode/bitcoin_compile_check.log
$orange
########################################################################################

"
enter_continue
please_wait_no_clear

sudo make -j $j check | tee $dp/bitcoin_compile_check.log

echo -e "$orange
########################################################################################

    Testes efectuados. Carregue em $cyan<enter>$orange para continuar a instalação 
    (copia os binários para diretórios de todo o sistema).

    Se houver erros, prima$cyan x$orange para abandonar a instalação. Terá então de 
    desinstalar a instalação parcial do bitcoin antes de poder tentar novamente.

    Nota: Se selecionou o patch de ordinais, é normal que alguns testes de transação 
    falhem. Continue.

    Para o Knots Bitcoin, se vir algum erro bitcoin.ico, provavelmente é seguro 
    continuar, pois trata-se apenas de um ficheiro de ícone.

########################################################################################
"
choose "xpmq"
read choice
clear
case $choice in
q|Q) exit 0 ;; p|P|M|m|x|X) back2main ;;
esac

sudo make install || enter_continue "algo pode ter corrido mal aqui."

}

function bitcoin_compile_dependencies {

if [[ -z $1 ]] ; then 
set_terminal ; echo -e "${pink}Atualização e instalação de dependências para compilar o bitcoin...$orange"
sudo apt-get update -y
sudo apt-get --fix-broken install -y
sudo apt-get install -y make              || { enter_continue "Algo correu mal com o make.$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y automake          || { enter_continue "Algo correu mal com o automake.$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y cmake             || { enter_continue "Algo correu mal com o cmake.$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y curl              || { enter_continue "Algo correu mal com o curl.$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y g++-multilib     
sudo apt-get install -y libtool           || { enter_continue "Algo correu mal com o libtool.$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y binutils          || { enter_continue "Algo correu mal com o binutils.$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y bsdmainutils      || { enter_continue "Algo correu mal com o bsdmainutils.$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y build-essential   || { enter_continue "Algo correu mal com o build-essential.$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y autotools-dev     || { enter_continue "Algo correu mal com o autotools-dev.$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y pkg-config        || { enter_continue "Algo correu mal com o pkg-config.$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y python3           || { enter_continue "Algo correu mal com o python3.$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y patch             || { enter_continue "Algo correu mal com o patch.$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y autoconf          || { enter_continue "Algo correu mal com o autoconf.$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y libboost-all-dev  || { enter_continue "Algo correu mal com libboost-all-dev.$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y imagemagick       || { enter_continue "Algo correu mal com imagemagick.$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y librsvg2-bin      || { enter_continue "Algo correu mal com librsvg2-bin.$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y libdb-dev         || { enter_continue "Algo correu mal com libdb-dev.$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y libdb++-dev       || { enter_continue "Algo correu mal com libdb++-dev.$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y libzmq3-dev       || { enter_continue "Algo correu mal com libzmq3-dev.$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y libqrencode-dev   || { enter_continue "Algo correu mal com libqrencode-dev.$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y libsqlite3-dev    || { enter_continue "Algo correu mal com libsqlite3-dev.$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y libevent-dev      || { enter_continue "Algo correu mal com libevent-dev.$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y libssl-dev        || { enter_continue "Algo correu mal com libssl-dev.$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y libminiupnpc-dev  || { enter_continue "Algo correu mal com libminiupnpc-dev.$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y libprotobuf-dev   || { enter_continue "Algo correu mal com libprotobuf-dev.$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y protobuf-compiler || { enter_continue "Algo correu mal com protobuf-compiler.$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
fi

if [[ $1 == GUI ]] ; then

sudo apt-get install -y qtchooser 
sudo apt-get install -y qtbase5-dev-tools
sudo apt-get install -y qtcreator  || { enter_continue "Algo correu mal com .$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y qtbase5-dev || { enter_continue "Algo correu mal com .$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y qt5-qmake || { enter_continue "Algo correu mal com .$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y qttools5-dev-tools || { enter_continue "Algo correu mal com .$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y qt5-default  
sudo apt-get install -y qtchooser || { enter_continue "Algo correu mal com .$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y libqt5gui5 || { enter_continue "Algo correu mal com .$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y libqt5core5a || { enter_continue "Algo correu mal com .$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y libqt5dbus5 || { enter_continue "Algo correu mal com .$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y qttools5-dev || { enter_continue "Algo correu mal com .$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }
sudo apt-get install -y libqt5widgets5 || { enter_continue "Algo correu mal com .$green i$ornage to ignore." ; [[ $enter_cont == i ]] || return 1 ; }

 



fi

}
