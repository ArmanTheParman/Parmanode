function electrs_better_4pi {

while true ; do
if [[ $chip == "arm64" || $chip == "aarch64" || $chip == "armv6l" || $chip == "armv7l" ]] ; then
set_terminal
announce "It's best for Raspberry Pi's to use electrs insteat of Fulcrum" \
"Abort Fulcrum installation?     y     or     n"
read choice

case $choice in 
y|Y) return 1 ;;
n|N) return 0 ;;
*) invalid ;;
esac
fi
break
done

}