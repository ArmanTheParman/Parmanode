function fix_openssl_ripemd160 {
opensslconf="$(openssl info -configdir)/openssl.cnf"
if [[ -e ${opensslconf}_backup ]] ; then
sudo cp ${opensslconf}_backup $opensslconf  #restores original
fi
sudo cp $opensslconf ${opensslconf}_backup #backs up original
swap_string "$opensslconf" "# activate = 1" "activate = 1"
echo "[legacy sect]
activate = 1" | sudo tee -a $opensslconf >/dev/null
}