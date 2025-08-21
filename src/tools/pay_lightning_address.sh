function pay_lightning_address {

while true ; do
announce "Please type/paste the lightning address you want to pay"
jump $enter_cont
yesorno "Use $enter_cont?" || continue
ADDR="$enter_cont"
break
done

while true ; do
announce "Please enter the number of sats to pay"
jump $enter_cont
yesorno "Use $enter_cont?" || continue
SATS="$enter_cont"
MSATS=$(($SATS * 1000))
break
done

USER="${ADDR%@*}"; DOMAIN="${ADDR#*@}"
INFO="$(curl -s "https://${DOMAIN}/.well-known/lnurlp/${USER}")"

set_terminal 50 88
#echo $INFO | jq
#enter_continue

CALLBACK="$(echo $INFO | jq -r '.callback')"
INV="$(curl -sG "$CALLBACK" -d "amount=$MSATS" | jq -r '.pr')"

echo -e "${orange}Your invoice to pay $SATS to $ADDR is:
$green
$INV
$orange \n
"
qrencode -t ansiutf8 <<<$INV
enter_continue
}