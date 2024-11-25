function make_fulcrum_startup_script {
local file="$hp/startup_scripts/fulcrum_startup.sh"
cat <<'EOF' > $file
#!/bin/bash

echo "" | tee $HOME/.fulcrum/fulcrum.log 2>&1

/usr/local/bin/Fulcrum $HOME/.fulcrum/fulcrum.conf 

exit
EOF

sudo chmod +x $file >$dn 2>&1
}