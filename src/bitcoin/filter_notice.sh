function filter_notice {
set_terminal ; echo -e "
########################################################################################

    Please note,$green IF$orange you have decided to filter ordinals, the output of your own
    node data will look different to the publicly available data on Mempool Space or
    BTC RPC Explorer, as those nodes do not filter ordinals.

########################################################################################
"
enter_continue
}