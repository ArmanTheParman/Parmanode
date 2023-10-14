function update_npm {

local version=$(npm -v) >/dev/null 2>&1
if [[ $version -gt $1 ]] ; then return 0 ; fi
sudo npm install -g npm
local version=$(npm -v) >/dev/null 2>&1
if [[ $version -gt $1 ]] ; then return 0 
else
announce "Couldn't get the right version of NPM.

    You have $version.
    
    Aborting."
return 1
fi

}