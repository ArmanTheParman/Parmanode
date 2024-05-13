function install_btcrecover {



docker build -t btcrecover .

docker network create --internal no-internet

docker run -d --network no-internet --name btcrecover btcrecover  


}