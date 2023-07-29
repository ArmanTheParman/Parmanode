function unpack_specter {

if [[ $OS == "Mac" ]] ; then hdiutil attach $HOME/parmanode/Specter*.dmg
    cp -r /Volumes/Specter/Specter.app /Applications || { log "specter" "move to Applications failed" && return 1 ; }
    diskutil unmountDisk /Volumes/Specter
    fi


if [[ $OS == "Linux" ]] ; then

cd $HOME/parmanode/specter

tar -xvf *tar* || { log "specter" "tar extract failed" && return 1 ; }
sudo chmod +x *AppImage*
rm *tar*

}
