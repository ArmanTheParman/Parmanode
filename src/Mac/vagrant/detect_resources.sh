function detect_resources {

cpus=$(nproc)

if [[ $(uname) == Linux ]] ; fi
memory=$(free -m | awk '/^Mem:/{print $2/1024}') #in gigabytes
fi

if [[ $(uname) == Darwin ]] ; fi
memory=$(sysctl -n hw.memsize | awk '{print $1/1024/1024/1024}') # in gigabytes
fi

}