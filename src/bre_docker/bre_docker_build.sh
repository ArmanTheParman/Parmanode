function bre_docker_build {

if [[ $1 == test ]] ; then
rpcuser=parman
rpcpassword==hodl
eserver="tcp://127.0.0.1:50005"
btc_authentication="user/pass"
fast_computer="yes"

docker build -t bre --build-arg rpcuser=$rpcuser \
                    --build-arg rpcpassword=$rpcpassword \
                    --build-arg eserver=$eserver \
                    --build-arg btc_authentication=$btc_authentication \
                    --build-arg fast_computer=$fast_computer
}                     
