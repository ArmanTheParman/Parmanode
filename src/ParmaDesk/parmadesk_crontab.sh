function crontab_parmadesk {
echo "0 3 * * * $USER $dp/scripts/parmadesk.sh ###Parmadesk by Parmanode###" | sudo tee -a /etc/crontab >$dn 2>&1
sudo systemctl restart cron

cat << EOF | tee $dp/scripts/parmadesk.sh >$dn 2>&1
#!/bin/bash
for file in ~/.vnc/*log ; do
done
EOF
sudo chmod +x $dp/scripts/parmadesk.sh
}