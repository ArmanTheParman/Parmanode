function download_fulcrum {
local version="1.9.8"
cd $hp/fulcrum

if [[ $OS == "Linux" ]] ; then

        if [[ $chip == "x86_64" ]] ; then
            curl -LO https://github.com/cculianu/Fulcrum/releases/download/v$version/Fulcrum-$version-x86_64-linux.tar.gz 
	    elif [[ $chip == "aarch64" ]] ; then 				#64 bit Pi4 
            curl -LO https://github.com/cculianu/Fulcrum/releases/download/v$version/Fulcrum-$version-arm64-linux.tar.gz 
        fi
fi
#get shasums and signature
curl -LO https://github.com/cculianu/Fulcrum/releases/download/v$version/Fulcrum-$version-shasums.txt 
curl -LO https://github.com/cculianu/Fulcrum/releases/download/v$version/Fulcrum-$version-shasums.txt.asc 
}