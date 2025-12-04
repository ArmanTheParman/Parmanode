function filter_notice { debugf
set_terminal ; echo -e "
########################################################################################

    Please note, if you have decided to filter ordinals, the output of your own
    node data will look different to the publicly available data on Mempool Space or
    BTC RPC Explorer, as those nodes do not filter ordinals.

    It's totally fine to use a public service for estimating fees - that part of
    Bitcoining doesn't need to be self-sovereign; think about it.

########################################################################################
"
enter_continue
jump $enter_cont
}