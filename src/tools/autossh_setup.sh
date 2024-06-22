function autossh_setup {

while true ; do
set_terminal ; echo -e "
########################################################################################

    Instructions to set up an$cyan autossh tunnel$orange from a VPS to a home server 

########################################################################################
"
choose epmq ; read choice ; set_terminal
case $choice in q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;; *) break ;; esac
done

while true ; do
set_terminal ; echo -e "
########################################################################################

    1. Install autossh on the host and VPS running Linux, and install/enable SSH if
       not already done.

    2. Then check a ssh public key exits. If it doesn't exist, make one:
            $cyan
                           ssh-keygen -t rsa -b 4096
$orange
########################################################################################
"
choose epmq ; read choice ; set_terminal
case $choice in q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;; *) break ;; esac
done

while true ; do
set_terminal ; echo -e "
########################################################################################

    3. Decide on a port number for the host and VPS (they need to be different, eg
       9000 and 9001)

    4. Gather the IP address of each computer (the external IP not internal).

    5. If required, buy a Domain Name and point it to the VPS IP using CloudFlare
       or similar. Do not enable a proxy at the CloudFlare end.

    6. Copy the ID of the VPS to the host computer. Run this from the host:
    $cyan
                   ssh-copy-id root@<put_the_vps_ip_address_here> 
$orange
       This will copy the public key to the VPS computer's authorized_keys file.

########################################################################################
"
choose epmq ; read choice ; set_terminal
case $choice in q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;; *) break ;; esac
done
while true ; do
set_terminal_wide ; echo -e "
########################################################################################
    
    6b. OPTIONAL: You can edit the authorized_keys files manually to include some
        extra security features:
        $cyan
   
command=\"true\",no-pty,no-agent-forwarding,no-X11-forwarding,no-user-rc,permitopen=\"localhost:9000\" ssh-rsa AAAB3... root@home_computer

$orange
########################################################################################
"
choose epmq ; read choice ; set_terminal
case $choice in q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;; *) break ;; esac
done

while true ; do
set_terminal_wide ; echo -e "
########################################################################################

    7. Then, add these to the end of file$cyan /etc/ssh/sshd_config$orange on the VPS, or 
       find these lines and adjust them as needed.
$green
                            PubkeyAuthentication yes 
                            GatewayPorts yes 
                            AllowTcpForwarding yes 
                            ClientAliveInterval 60
$orange
       Restart sshd to make changes take effect.
$cyan
       sudo systemctl restart sshd
$orange
########################################################################################
"
choose epmq ; read choice ; set_terminal
case $choice in q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;; *) break ;; esac
done

while true ; do
set_terminal ; echo -e "
########################################################################################

    8. Create a systemd service file on the host computer. This is what will make the 
       SSH connection. Fill in the correct values inside the < >, then remove the <>'s.
$cyan
       filename: /etc/systemd/system/autossh-tunnel.service

$green
[Unit]
  Description=AutoSSH tunnel service
  After=network.target

  [Service]
  User=root
  Group=root
  Environment="AUTOSSH_GATETIME=0"
  ExecStart=/usr/bin/autossh -C -M 0 -v -N -o "ServerAliveInterval=60" -R <VPS_port>:localhost:<host_port> root@<VPS_ip>
  StandardOutput=journal

  [Install]
  WantedBy=multi-user.target

$orange
   You should then run the following commands... $cyan

   sudo systemctl daemon-reload
   sudo systemctl enable autossh-tunnel.service
   sudo systemctl start autossh-tunnel.service
$orange
########################################################################################
"
# M 0 - disables autossh monitoring port
# -N Do not execute remote commands
# -i path_to_private key; if not using default
choose epmq ; read choice ; set_terminal
case $choice in q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;; *) break ;; esac
done

while true ; do
set_terminal ; echo -e "
########################################################################################

    9. Monitoring. Check if there are any errors on the host computer:
     $cyan
       sudo journalctl -fexu autossh-tunnel
$orange
########################################################################################
"
choose epmq ; read choice ; set_terminal
case $choice in q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;; *) break ;; esac
done

while true ; do
set_terminal ; echo -e "
########################################################################################

    10. For domain name forwarding, Nginx on the VPS need to be configured. The 
        config set up can be tricky and is outside the scope of these instructions. 
        Make sure to restart nginx.service once done.
$orange
########################################################################################
"
choose epmq ; read choice ; set_terminal
case $choice in q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;; *) break ;; esac
done
}