function electrs_better_4pi {

if [[ $chip == "arm64" || $chip == "aarch64" || $chip == "armv6l" || $chip == "armv7l" ]] ; then
while true ; do
set_terminal
announce "It's best for Raspberry Pi's to use electrs insteat of Fulcrum" \
"Continue Fulcrum installation?     y     or     n"
read choice

case $choice in 
y|Y) return 0 ;;
n|N) return 1 ;;
*) invalid ;;
esac
done
fi
}