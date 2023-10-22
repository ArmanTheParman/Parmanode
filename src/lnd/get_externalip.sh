function get_extIP {

export extIP=$(curl http://whatismyip.akamai.com/ | grep .)



}