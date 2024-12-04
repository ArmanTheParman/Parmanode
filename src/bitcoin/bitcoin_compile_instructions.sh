function bitcoin_compile_instructions {

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                       Como compilar Bitcoin a partir do zero
$orange
########################################################################################
    
    Então queres fazer isto. Muito fixe. Vou mostrar-vos como. Abra um terminal separado 
    e siga estes passos sequencialmente. Selecione os itens que pretende ler mais...

    STEPS:

$green                   1)$orange        Atualizar o seu sistema
$green                   2)$orange        Instalar todas as dependências necessárias
$green                   3)$orange        Clonar o repositório Bitcoin no Git e fazer checkout
$green                   4)$orange        Aplicar a correção dos ordinais se assim o desejar
$green                   5)$orange        Executar autogen
$green                   6)$orange        Executar configure com as opções pretendidas
$green                   7)$orange        Executar o comando make
$green                   8)$orange        Executar verificação de fabrico
$green                   9)$orange        Executar make install

$cyan
    Quando tiver terminado, carregue em$green <enter>$cyan para sair da instalação. 
    Pode então começar de novo e escolher importar os ficheiros binários que criou.
$orange

########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;;
"") 
return 1 ;;
1)
set_terminal ;
echo -e "
########################################################################################
$cyan
                            ACTUALIZAR O SEU SISTEMA
$orange                            
    Run these commands to update your system. It's a good idea to do it regularly
    anyway...
$green
        sudo apt-get update

        sudo apt-get upgrade
$orange
    Por vezes, na saída, pode ver uma recomendação para executar este comando, 
    o que pode fazer se quiser ...
$green
        sudo apt-get --fix-broken install 
$orange
########################################################################################       
"
enter_continue ; jump $enter_cont
set_terminal
;;
2)
set_terminal_wide ; echo -e "
##############################################################################################################
$cyan
                                         INSTALAR DEPENDÊNCIAS
$orange
    As dependências são programas ou bibliotecas (ficheiros com código) que são necessários para que um 
    determinado programa funcione. Para compilar o bitcoin, você precisará de algumas coisas.

    Aqui estão os comandos para instalar tudo. Dividi a instalação das dependências em vários comandos 
    para facilitar a leitura, mas pode ser feito tudo de uma só vez. Preste atenção a quaisquer erros 
    (A opção '-y' responderá automaticamente sim à pergunta de confirmação esperada).
$green
    sudo apt-get install make automake cmake curl libtool binutils bsdmainutils g++-multilib -y

    sudo apt-get install pkg-config python3 patch bison autoconf libboost-all-dev autoconf -y

    sudo apt-get install qtcreator qtbase5-dev qt5-qmake -y $orange #Needed for Bitcoin-QT (GUI)$green

    sudo apt-get install imagemagick -y  $orange                    #Needed if installing Knots Bitcoin$green

    sudo apt-get install librsvg2-bin -y $orange                    #Needed if installing Knots Bitcoin$green
$orange
##############################################################################################################
"
enter_continue ; jump $enter_cont
;;
3)
set_terminal ; echo -e "
########################################################################################
$cyan
                         CLONAR O REPOSITÓRIO BITCOIN
$orange                    
    Para isso, é necessário ter o git instalado no seu sistema. 
    Se instalou o Parmanode da forma habitual, então já tem isto instalado.

    Crie um diretório temporário em algum lugar e navegue até ele usando o Terminal. 
    Se não entende isso, pare e aprenda um pouco de Linux básico antes de tentar 
    compilar programas; é muito avançado e você não vai se divertir.

    A partir do diretório temporário, clonar Bitcoin...
$green
        git clone https://github.com/bitcoin/bitcoin.git
$orange
    Em seguida, navegue para o novo diretório bitcoin que clonou (${green}cd bitcoin$orange).

    De seguida, faça o checkout para a versão/ramo que pretende. Para a versão 26...
$green
       git checkout v26.0 
$orange    
########################################################################################    
"
enter_continue ; jump $enter_cont
;;
4)
set_terminal ; echo -e "
########################################################################################
$cyan
                                  PATCHES DE ORDENAMENTO
$orange
    O patch ordinals é um filtro criado pelo desenvolvedor do Bitcoin Core, Luke Dashjr, 
    em resposta ao spam de ordinals e inscriptions. Leia sobre ele aqui:
$magenta
    https://bitcoinnews.com/adoption/bitoin-developer-proposes-patch-bitcoin-ordinals/
$orange
    É importante notar que isto não é uma bifurcação do Bitcoin; simplesmente permite que 
    os executores de nós optem por não receber e propagar novas transacções de e para outros 
    nós. Isso não impede que essas transações sejam mineradas. Uma vez que elas estejam num 
    bloco válido, todos os nós Bitcoin compatíveis (mesmo com um patch) aceitarão o bloco 
    como válido.

    Esta correção NÃO impede os ordinais. Trata-se puramente de uma escolha INDIVIDUAL e não 
    de uma censura das transacções. A censura é uma discussão totalmente diferente.

    Para ativar o patch dos ordinais...

########################################################################################
"
enter_continue ; jump $enter_cont
set_terminal_high ; echo -e "
########################################################################################

    Primeiro, crie uma nova marca FROM a versão desejada do Bitcoin no seu repositório git 
    local do Bitcoin.
$green
        git checkout -b patch
$orange    
    Isto irá criar um ramo chamado 'patch' copiado do ramo em que estava e, ao mesmo tempo, 
    efetuar o checkout para esse ramo.

    Em seguida, descarregue o patch. O comando seguinte está todo numa só linha.
$magenta
        curl -LO https://gist.githubusercontent.com/luke-jr/4c022839584020444915c84bdd825831/raw/555c8a1e1e0143571ad4ff394221573ee37d9a56/ filter-ordinals.patch 
$orange
    Depois, aplique a correção...
$green  
        git apply filter-ordinals.patch
        git add .  $orange #O "." é necessário e faz parte do comando.$green
        git commit -m "patch"
$orange
    Se receber erros do github sobre nomes de utilizador e e-mails, introduza estas variáveis 
    temporárias como comandos. Elas irão para a memória da sessão, então tente novamente.
$green
        export GIT_AUTHOR_NAME="Temporary Parmanode"
        export GIT_AUTHOR_EMAIL="parman@parmanode.parman"
        export GIT_COMMITTER_NAME="Parmanode Committer"
        export GIT_COMMITTER_EMAIL="parman@parmanode.parman"
$orange
########################################################################################
"
enter_continue ; jump $enter_cont
;;
5)
set_terminal ; echo -e "
########################################################################################
$cyan
                                    AUTOGEN
$orange
    Execute este comando a partir do diretório bitcoin...
$green
        ./autogen.sh        
$orange
   Preste atenção aos erros que aparecem no ecrã, pois poderá ter de os resolver.

########################################################################################
"
enter_continue ; jump $enter_cont
;;
6)
set_terminal ; echo -e "
########################################################################################
$cyan
                                   CONFIGURE
$orange
    Execute o comando configure com as opções que desejar.
$green
        ./configure --with-gui=no
$orange        
    Para ver uma lista das opções de configuração, execute primeiro este comando e leia-o:
$green
        ./configure --help
$orange
    Mais uma vez, é necessário prestar atenção aos erros.

########################################################################################
"
enter_continue ; jump $enter_cont
;;

7)
set_terminal ; echo -e "
########################################################################################
$cyan
                                      MAKE                                
$orange                                    
    O Make é o programa que irá compilar o software. Mas antes de o usar, verifique
quantos núcleos tem a sua CPU.
$green
        nproc
$orange
    Obterá um número na saída. Um Pi4 tem tipicamente 4 núcleos. Usa esse número no comando 
    make, que diz quantos núcleos usar. Um núcleo será lento, adicionar mais núcleos ao 
    processo de compilação irá acelerar as coisas. Por exemplo...
$green
        make -j 4
$orange
    Check for errors.

########################################################################################
"
enter_continue ; jump $enter_cont
;;
8)
set_terminal ; echo -e "
########################################################################################
$cyan
                                     VERIFICAR O MAKE
$orange
    Este comando irá executar alguns testes como escritos pelos desenvolvedores do Bitcoin. 
    Note que se você estiver aplicando o patch do filtro ordinals, alguns testes de transação 
    irão falhar, já que o patch não modifica os testes padrão de qualquer forma.
$green
        sudo make -j 4 check
$orange
    Lembra-te de te certificares que o teu nubmer no comando acima corresponde ao teu output nproc.
    
    Presta atenção aos erros.

########################################################################################
"
enter_continue ; jump $enter_cont
;;
9)
set_terminal ; echo -e "
########################################################################################
$cyan
                                  INSTALAR O MAKE
$orange
    Este comando irá mover os binários recém-criados selecionados para os diretórios 
    de destino.
$green
        sudo make install
$orange
    O diretório de destino é$bright_blue /usr/local/bin/ $orange
    
    Uma vez concluído, verifique se os ficheiros foram movidos...
$green    
        which bitcoind bitcoin-cli
$orange
    Se não tiveres saída, é mau sinal. Algo correu mal. Se obtiver /usr/local/bin para ambos os ficheiros, grande sucesso!

########################################################################################
"
enter_continue ; jump $enter_cont
;;


*)
;;
esac
done
}
