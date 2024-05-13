#docker network create --internal no-internet
#docker run --network no-internet <image>
function install_btcrecover {

docker build -t btcrecover $pn/src/btcrecover

}