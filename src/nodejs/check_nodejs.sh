function check_nodejs {
#extract nodejs version number, and return old vs new (needs to be 16+) or none

if which node ; then
nodejs_version=$(node --version | cut -d "." -f 1 | cut -d "v" -f 2) >/dev/null
else
nodejs_version=none
fi

if [[ $nodejs_version -lt 16 ]] ; then 
    export nodejs_version="old"
else 
    export nodejs_version="new"
fi
}