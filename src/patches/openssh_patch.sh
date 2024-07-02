function openssh_patch {
source $hm 1>/dev/null
if [[ $openssh == "hide" ]] ; then return 0 ; fi

#https://www.bleepingcomputer.com/news/security/new-regresshion-openssh-rce-bug-gives-root-on-linux-servers/

ssh_major=$(ssh -V 2>&1 | grep -oE '[0-9].+\.' | cut -d \. -f1)

if [[ $ssh_major -lt 9 ]] ; then opensshversion="old"
elif [[ $ssh_major -gt 9 ]] ; then return 0
elif [[ $ssh_major == 9 ]] ; then

    ssh_minor=$(ssh -V 2>&1 | grep -oE '\.[0-9]' | head -n1 | cut -d \. -f2) 
        if [[ $ssh_minor -lt 8 ]] ; then
            opensshversion="old"
        else return 0 
        fi

fi

while true ; dp
set_terminal ; echo -e "
########################################################################################

    Parmanode has detected that your OpenSSH server version installed on your
    system is not up today. This was checked because there has been a security 
    breach in the older versions of the software.

    You have:

    $(ssh -V 2>&1 | grep -E '.+,' | cut -d , -f1)

    Parmanode can update to version 9.8p1 - it needs to compile from source, so it
    can take some time.

    Do that now or later?
$green
                    1)      NOW
$orange
                    2)      Later
$red
                    3)      Never, and don't ask again
$orange
########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
1) break ;;
2) return 1 ;;
3) echo "openssh=hide" | tee -a $hm 1>/dev/null 2>&1
*) invalid ;;
esac
done

mkdir $hp/openssh
cd $hp/openssh
curl -LO https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-9.8p1.tar.gz
tar -xvf openssh-9.8p1.tar.gz
cd openssh-9.8p1
sudo apt-get -y install build-essential zlib1g-dev libssl-dev
./configure
make
sudo make install
sudo systemctl restart ssh

backupdir="$hp/openssh/backupbins/"

if [[ -e /usr/local/bin/ssh ]] ; then
sudo mv /usr/bin/ssh $backupdir 2>/dev/null
sudo cp /usr/local/bin/ssh /usr/bin/ssh
fi

if [[ -e /usr/local/sbin/sshd ]] ; then
sudo mv /usr/bin/sshd $backupdir 2>/dev/null
sudo mv /usr/sbin/sshd $backupdir 2>/dev/null
sudo cp /usr/local/sbin/sshd /usr/sbin/sshd
fi

if [[ -e /usr/local/bin/scp ]]; then
sudo mv /usr/bin/scp $backupdir 2>/dev/null
sudo cp /usr/local/bin/scp /usr/bin/scp
fi

if [[ -e /usr/local/bin/sftp ]] ; then
sudo mv /usr/bin/sftp $backupdir 2>/dev/null
sudo cp /usr/local/bin/sftp /usr/bin/sftp
fi

if [[ -e /usr/local/bin/ssh-keygen ]] ; then
sudo mv /usr/bin/ssh-keygen $backupdir 2>/dev/null
sudo cp /usr/local/bin/ssh-keygen /usr/bin/ssh-keygen
fi

if [[ -e /usr/local/bin/ssh-agent ]] ; then
sudo mv /usr/bin/ssh-agent $backupdir 2>/dev/null
sudo cp /usr/local/bin/ssh-agent /usr/bin/ssh-agent
fi

if [[ -e /usr/local/bin/ssh-add ]] ; then
sudo mv /usr/bin/ssh-add $backupdir 2>/dev/null
sudo cp /usr/local/bin/ssh-add /usr/bin/ssh-add
fi

if [[ -e /usr/local/bin/ssh-keyscan ]] ; then
sudo mv /usr/bin/ssh-keyscan $backupdir 2>/dev/null
sudo cp /usr/local/bin/ssh-keyscan /usr/bin/ssh-keyscan
fi

set_terminal
echo -e "
########################################################################################

   The update has completed. You now have version...

   $(ssh -V 2>&1 | grep -E '.+,' | cut -d , -f1)

########################################################################################
"
enter_continue
return 0
}