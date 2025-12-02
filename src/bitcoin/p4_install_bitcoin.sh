function p4_install_bitcoin { debugf

grep -q "bitcoin-end" $ic && { echo "Bitcoin detected installed in installed.conf" >> $dp/error.log && return 1 ; }
jq .bitcoin $p4 | grep "clientchoice" | grep -qE "core|knots|deis" || { echo "clientchoice not set" >> $dp/error.log ; return 1 ; }
jq .bitcoin $p4 | grep "bitcoin_compile" | grep -qE "true|false" || { echo "bitcoin_compile not set" >> $dp/error.log ; return 1 ; }
jq .bitcoin $p4 | grep -q "version" || { echo "version not set" >> $dp/error.log ; return 1 ; }
jq .bitcoin $p4 | grep -q "prune" || { echo "prune not set" >> $dp/error.log ; return 1 ; }
jq .installed | grep -q "bitcoin" || { echo "bitcoin already installed" >> $dp/error.log ; return 1 ; }
jq .partially_installed | grep -q "bitcoin" || { echo "bitcoin already partially installed" >> $dp/error.log ; return 1 ; }

export parmaview=1  

if install_bitcoin ; then
    return 0
else
   echo "Bitcoin failed to install" >> $dp/error.log 
   return 1
fi

}