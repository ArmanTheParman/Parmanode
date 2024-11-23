function update_npm {
if [[ $1 == x ]] ; then return 0 ; fi

local version=$(npm -v | cut -d . -f 1)
if [[ $version -gt $1 ]] ; then return 0 ; fi
sudo npm install -g npm
local version=$(npm -v | cut -d . -f 1) 
if [[ $version -gt $1 ]] ; then return 0 
else
announce "Couldn't get the right version of NPM.

    You have $version.
    
    Aborting."
return 1
fi

}