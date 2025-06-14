function sound_error_suppression {

#without this, the log file gets spammed, and very large, if sound isn't configured.
[[ -f ~/.asoundrc ]] && return 0

cat > ~/.asoundrc <<EOF
pcm.!default {
  type file
  slave.pcm "null_sink"
  file "/dev/null"
  format raw
}

pcm.null_sink {
  type null
}

ctl.!default {
  type hw
  card -1
}
EOF
}
