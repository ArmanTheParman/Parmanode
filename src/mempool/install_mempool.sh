function install_mempool {

cd $HOME/parmanode

git clone http://github.com/mempool/mempool.git

cd mempool/docker

docker-compose.yml
    -change port from 80 to 4080
    change core_RPC_Host, and username and password
    change on failure to always (three locations)
    change mempool backend to "electrum"

    api:
        environment:
            ELECTRUM_HOST: "own IP"
            ELECTRUM_PORT: "50002"
            ELECTRUM_TLS_ENABLED: "true"

    add at the end:
    
    networks:
        default:
            driver: bridge
            ipam:
                config:
                    -subnet: 172.16.57.0/24
    
    docker compose up -d


}