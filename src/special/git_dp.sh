function git_dp {
if [[ ! -e ${dp}/.git ]] ; then
cd ${dp}
git init >/dev/null 2>&1
git add . >/dev/null 2>&1
git commit -m "initial commit" >/dev/null 2>&1
debug "pause in git_dp 0"
cd - >/dev/null
else
cd ${dp} >/dev/null
git add . >/dev/null 2>&1
git commit -m "auto-commit" >/dev/null 2>&1
debug "pause in git_dp"
cd - >/dev/null
fi
}