function rest_protocol_test { 

set_terminal 38 110 ; echo -e "
##############################################################################################################

    The REST protocol format to test lnd with curl is:
$cyan
    curl -X GET https://localhost:8080/v1/getinfo -H \"Grpc-Metadata-macaroon: YOUR_MACAROON_VALUE\" -k
$orange
##############################################################################################################
"
enter_continue ; jump $enter_cont
}
