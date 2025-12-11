function p4_install_bitcoin { debugf

grep -q "bitcoin-end" $ic && { echo "Bitcoin detected installed in installed.conf" >> $errorlog && return 1 ; }
jq -r .bitcoin $p4 | grep "clientchoice" | grep -qE "core|knots|deis" || { echo "clientchoice not set" >> $errorlog ; return 1 ; }
jq -r .bitcoin $p4 | grep "bitcoin_compile" | grep -qE "true|false" || { echo "bitcoin_compile not set" >> $errorlog ; return 1 ; }
jq -r .bitcoin $p4 | grep -q "version" || { echo "version not set" >> $errorlog ; return 1 ; }
jq -r .bitcoin $p4 | grep -q "prune" || { echo "prune not set" >> $errorlog ; return 1 ; }
jq -r .installed | grep -q "bitcoin" || { echo "bitcoin already installed" >> $errorlog ; return 1 ; }
jq -r .partially_installed | grep -q "bitcoin" || { echo "bitcoin already partially installed" >> $errorlog ; return 1 ; }

export parmaview=1  

if install_bitcoin ; then
    return 0
else
   echo "Bitcoin failed to install" >> $errorlog
   return 1
fi

}