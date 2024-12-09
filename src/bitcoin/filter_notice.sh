function filter_notice {
set_terminal ; echo -e "
########################################################################################

    Por favor, note que se decidiu filtrar os ordinais, a saída dos dados do seu 
    próprio nó será diferente dos dados publicamente disponíveis no Mempool Space 
    ou no BTC RPC Explorer, uma vez que esses nós não filtram os ordinais.

########################################################################################
"
enter_continue
jump $enter_cont
}
