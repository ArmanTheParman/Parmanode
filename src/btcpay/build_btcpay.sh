function build_btcpay {

#get the USER ID, and match it to the parman ID inside the container.

thisID=$(id -u) 

debug "btcpay_version_chioce $btcpay_version_chioce"

docker build --build-arg parmanID=$thisID --build-arg btcpay_version=$btcpay_version_choice -t btcpay $pn/src/btcpay  || return 1

}