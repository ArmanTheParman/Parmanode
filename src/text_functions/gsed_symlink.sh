function gsed_symlink {
#make a gsed symlink
if [[ $OS == Linux ]] && ! which gsed >$dn 2>&1 ; then
sedpath=$(which sed | sed -n 's/\(.*\)sed/\1/p')
sudo ln -s $(which sed) $sedpath/gsed
fi
}

