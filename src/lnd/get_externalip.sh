function get_extIP {

export extIP=$(curl -fsSL http://whatismyip.akamai.com/ | grep .)



}