function bitcoin_byo {
set_terminal ; echo -e "
########################################################################################
$cyan
             Como trazer os seus dados Bitcoin existentes de outra drive.
$orange
    Se os seus dados forem do Umberl, Mynode ou RaspiBlitz, então é melhor abortar 
    e utilizar a função de importação personalizada.

    Para importar os seus dados Bitcoin existentes numa drive não-Parmanode, faça o seguinte: 
$green
        1)$orange   Identifique a sua drive como 'parmanode' - isto é importante para a 
             deteção e prevenção de erros mais tarde.
        
$green        2)$orange   Cria uma diretoria chamada '.bitcoin' na raiz do disco. Não te 
             esqueças do ponto, que indica que se trata de uma diretoria oculta.

$green        3)$orange   Copie os seus dados de bitcoin para este diretório. Se precisares 
             de ajuda com isso, provavelmente não deverias estar a tentar fazer isto. 
             Além disso, pode considerar a utilização da ferramenta auxiliar rsync da Parmanode 
             no menu Tools para uma cópia fiável de dados e atributos de ficheiros; também é 
             possível copiar os dados de outro computador de SSH usando esta ferramenta. 
             Certifique-se de que qualquer cópia de dados do Bitcoin acontece quando o próprio 
             Bitcoin não está a funcionar ou os dados ficarão certamente corrompidos. 
             Não é uma piada.

$green        4)$orange   A partir deste ponto, repita a instalação do Bitcoin e selecione 
             "import Parmanode drive" (importar drive Parmanode), porque é isso que é 
             efetivamente agora.
       
$orange
########################################################################################
"
enter_continue
jump $enter_cont
}
