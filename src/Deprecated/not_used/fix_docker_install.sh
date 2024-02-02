function fix_docker {
  return 0
  if [[ $1 == fix ]] ; then
  sudo source /etc/os-release
  echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$ID \
  "$(echo "jammy")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  exit
fi
}