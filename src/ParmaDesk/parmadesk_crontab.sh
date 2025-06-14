function crontab_parmadesk {
echo "0 3 * * * $USER $dp/parmadesk.sh ###Parmadesk by Parmanode###" | sudo tee -a /etc/crontab >$dn 2>&1
sudo systemctl restart cron

cat << EOF | tee $dp/scripts/parmadesk.sh >$dn 2>&1
#!/bin/bash
for file in ~/.vnc/*log ; do
        > /home/parman/parman_programs/parmasql/src/uninstall_parmasql.sh
done
EOF
sudo chmod +x $dp/parmadesk.sh
}