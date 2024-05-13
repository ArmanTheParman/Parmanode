function install_btcrecover {



docker build -t btcrecover .

docker network create --internal no-internet

docker run -du root --name btcrecover btcrecover --network no-internet btcrecover


}