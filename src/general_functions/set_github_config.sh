function set_github_config {
if ! git config --global user.email > $dn 2>&1 ; then git config --global user.email sample@parmanode.com ; fi
if ! git config --global user.name > $dn 2>&1 ; then git config --global user.name parman ; fi
}