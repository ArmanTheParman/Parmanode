function run_fulcrum_docker {

docker run -d --name fulcrum -p 50002:50002 -p 50001:50001 -p 50003:50003 fulcrum 

#additional port, 50003 added in case user needs another, the container does not have
#to be rebuilt.


}