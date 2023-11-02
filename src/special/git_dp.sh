function git_dp {
if [[ ! -e ${dp}/.git ]] ; then
cd ${dp}
git init >/dev/null 2>&1
git add . >/dev/null 2>&1
git commit -m "initial commit" >/dev/null 2>&1
cd -
else
cd ${dp}
git add . >/dev/null 2>&1
git commit -m "auto-commit" >/dev/null 2>&1
cd -
fi
}