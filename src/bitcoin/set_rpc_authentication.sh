function set_rpc_authentication {
if [[ $bitcoin == "yolo" ]]
	then export rpcuser=null ; export rpcpassword=null
	return 0 
	fi

while true ; do
set_terminal_bit_higher  

if [[ -z $1 ]] ; then
echo -e "
########################################################################################
$cyan
                           Autenticação RPC do Bitcoin Core
$orange
    Remote Procedure Call (RPC) é como outras aplicações (como carteiras) se conectam
    ao Bitcoin Core.
    Para que nenhum software aleatório se conecte ao Bitcoin Core, um desafio de 
    autenticação de nome de usuário/senha é introduzido. Note que esta palavra-passe 
    não precisa de ser incrivelmente segura, e tenha em conta que será armazenada no 
    computador em texto claro$pink$orange ( ou seja, não encriptado) dentro do 
    ficheiro bitcoin.conf e outros ficheiros de configuração. Por conseguinte, não 
    utilize palavras-passe muito sensíveis que possa utilizar para outras coisas.

    Se decidir alterar o nome de utilizador/palavra-passe predefinidos (parman/parman), 
    certifique-se de que$pink$blinkon não utiliza quaisquer símbolos$blinkoff$orange, pois alguns 
    deles são interpretados pelo computador como comandos em vez de texto simples.

$green
       (s)     Definir o nome de usuário e a senha do Bitcoin (edita o bitcoin.conf para você)
$orange
       (l)     Deixar o nome de utilizador e a palavra-passe Bitcoin inalterados
$red
       (c)     Usar cookie ...(apaga a palavra-passe de bitcoin.conf) - NÃO
$orange
########################################################################################

"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
else
choice=$1
fi

case $choice in
p|P) return 1 ;; q|Q|Quit|QUIT) exit 0 ;; m|M) back2main ;;

    s|S)
	            if [[ $2 == install ]] ; then
				export rpcuser=parman
				export rpcpassword=parman
				else
	            password_changer
				fi
				 
				if [[ $2 != install ]] ; then #no need to stop bitcoin if it hasn't been installed yet.
	            stop_bitcoin
				fi

                set_rpc_authentication_update_conf_edits #defined below
				
				export btc_authentication="user/pass" >$dn
				parmanode_conf_remove "btc_authentication" && parmanode_conf_add "btc_authentication=$btc_authentication"

                if [[ ! $dontstartbitcoin == "true" ]] ; then #will run unless dontstartbitcoin=true
				sleep 1 
				echo "Starting Bitcoin"
				start_bitcoin
				fi

                break
		        ;;
		
	l|L) 
				break
				;;
	c)
	            stop_bitcoin
                sudo gsed -i "/rpcuser/d" $bc && unset rpcuser
                sudo gsed -i "/rpcpassword/d" $bc && unset rpcpassword

				export btc_authentication="cookie"
				parmanode_conf_remove "btc_authentication" && parmanode_conf_add "btc_authentication=$btc_authentication"

                if [[ ! $dontstartbitcoin == "true" ]] ; then #will run unless dontstartbitcoin=true
				sleep 1
				start_bitcoin
				fi
				return 1 #important for testing if user/pass set
	;;
	*)
		invalid
		;;	
esac

done
check_rpc_credentials_match
return 0
}

function set_rpc_authentication_update_conf_edits {

	sudo gsed -i "/rpcuser/d" $bc >$dn 2>&1
	sudo gsed -i "/rpcpassword/d" $bc >$dn 2>&1
	echo "rpcuser=$rpcuser" | sudo tee -a $bc 2>&1
	echo "rpcpassword=$rpcpassword" | sudo tee -a $bc 2>&1
	parmanode_conf_add "rpcuser=$rpcuser"
	parmanode_conf_add "rpcpassword=$rpcpassword"

set_terminal

if [[ ! $dontstartbitcoin == "true" ]] ; then #will run unless dontstartbitcoin=true
start_bitcoin
fi

}

function add_userpass_to_fulcrum {

source $pc >$dn 2>&1

sudo gsed -i "/rpcuser/d" $fc 
sudo gsed -i "/rpcpassword/d" $fc 
echo "rpcuser = $rpcuser" | sudo tee -a $fc 2>$dn
echo "rpcpassword = $rpcpassword" | sudo tee -a $fc 2>$dn

}
