#docker network create --internal no-internet
#docker run --network no-internet <image>
function btcrecover_install {

docker build -t btcrecover $pn/src/btcrecover

}