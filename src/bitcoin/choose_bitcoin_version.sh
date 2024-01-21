function choose_bitcoin_version {
while true ; do
clear ; echo -e "
########################################################################################
$cyan
    THERE ARE SEVERAL WAYS TO INSTALL BITCOIN WITH PARMANODE. PLEASE CHOOSE...
$orange
########################################################################################
$red
          1)  v25.0 orange (Installs and verifies precompiled binaries)
$green
          2)  v26.0 orange (Installs and verifies precompiled binaries)
$red
          3)  Guided compile v25.0/v26.0 
$green
          4)  Guided compile v25.0/v26.0 (FILTER-ORDINALS patch, by Luke Dashr Jr)
$red
          5)  Guided compile Knots Bitcoin (Luke Dashr Jr's version of Bitcoin Core,
              which also has FILTER-ORDINALS patch) version v25.1.knots20231115
$red
          6)  BYO Bitcoin binary installation (imports to Parmanode)
$red
          7)  Guided compile of most recent Github update, ie pre-release
              (for testing only)

########################################################################################   
"
choose "xpmq" 
unset bitcoin_compile version ordinals_patch knotsbitcoin byo_bitcoin
read choice

case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;;
1|25) 
export version="25.0" ; export bitcoin_compile=false ; break ;;
2|26) 
export version="26.0" ; export bitcoin_compile=false ; break ;;
3) 
export bitcoin_compile=true ; export version=choose ; break ;;
4)
export bitcoin_compile=true ; export version=choose ; export ordinals_patch=true ; break ;;
5)
export knotsbitcoin=true ; export version="v25.1.knots20231115" ; break ;;
6)
export byo_bitcoin=true ; break ;;
7)
export bitcoin_compile=true ; export version=latest ; break ;;
*) 
invalid ;;
esac
done
}