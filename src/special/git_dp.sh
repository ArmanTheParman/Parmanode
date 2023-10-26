function git_dp {
if [[ ! -e ${dp}/.git ]] ; then
cd ${dp}
git init >/dev/null 2>&1
git add . >/dev/null 2>&1
git commit -m "initial commit" >/dev/null 2>&1
else
git add . >/dev/null 2>&1
git commit -m "$(date)" >/dev/null 2>&1
fi
debug3 "in git_dp"
}