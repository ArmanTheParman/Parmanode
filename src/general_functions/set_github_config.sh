function set_github_config {
if ! git config --global user.email > /dev/null 2>&1 ; then git config --global user.email sample@parmanode.com ; fi
if ! git config --global user.name > /dev/null 2>&1 ; then git config --global user.name Parman ; fi
}