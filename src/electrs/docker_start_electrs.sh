function docker_start_electrs {
docker exec -it electrs /bin/bash -c "/home/parman/parmanode/electrs/target/release/electrs --conf /home/parman/.electrs/config.toml"
}