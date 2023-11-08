function install_gpg4mac {
clear
echo -e "
########################################################################################

    Parmanode will install GPG on your system. It is a necessary tool to verify
    software and to use Bitcoin safely.

    At some point during the installation, you'll see dmg file mounted - ignore it,
    Parmanode is dealing with it and will eject it later.

    Also, you may get a pop up about using GPG with your email account. This is not
    necessary; it's safe to dismiss it.

    Hit <enter> to continue or <control> c to exit.

########################################################################################
"
read

if [[ -e $HOME/parmanode ]] ; then mkdir $HOME/parmanode ; fi
cd $HOME/parmanode
mkdir gpg4mac 2>/dev/null
cd gpg4mac
clear
curl -LO https://releases.gpgtools.com/GPG_Suite-2023.3.dmg
hdiutil attach GPG*.dmg
cd /Volumes/GPG*
sudo installer -pkg Install.pkg -target /
hdiutil detach /Volumes/GPG*
}