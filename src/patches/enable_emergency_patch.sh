function enable_emergency_patch {
file="${pn}/src/patches/emergency.sh" 
sudo chmod +x $file >/dev/null 2>&1
source $file
}