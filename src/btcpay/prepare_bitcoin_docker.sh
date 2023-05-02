function bitcoin_docker_warning {

set_terminal ; echo "
########################################################################################

                         Before installing Bitcoin in Docker


    - Make sure there is no other Bitocin installation on your computer. Just because
      Bitcoin will be in a container, does not mean files on your internal/external
      drive won't be affected. The systems interact.

    - If you have a carefree attitude to this, you could use an existing bitcoin
      data directory, just make sure that there is no bitcoin software funning, 
      otherwise, I'm certain, the data will get corrupted.

########################################################################################
"
enter_continue
}
