#docker network create --internal no-internet
#docker run --network no-internet <image>
function install_btcrecover {

if [[ $OS == Mac ]] ; then
docker build -t btcrecover $pn/src/btcrecover
else
docker build -t btcrecover $pn/src/btcrecover/Dockerfile_no_break-system-packages
fi

}