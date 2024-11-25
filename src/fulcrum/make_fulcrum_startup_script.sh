function make_fulcrum_startup_script {
local file="$hp/startup_scripts/fulcrum_startup.sh"
cat <<'EOF' > $file
#!/bin/bash
/usr/local/bin/Fulcrum $HOME/.fulcrum/fulcrum.conf 
exit
EOF

sudo chmod +x $file >$dn 2>&1
}