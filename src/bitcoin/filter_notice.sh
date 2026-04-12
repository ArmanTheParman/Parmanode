function filter_notice { debugf
announce "${green}TL;DR = Fee estimate might not be accurate$orange

    If you have decided to filter ordinals with your Bitcoin installation, 
    the output of your own node data will look different to the publicly 
    available data on https://mempool.space as those nodes do not filter ordinals.

    But no need to care... It is my opinion that it's totally fine to use a public 
    service: Do you really need to trustlessly estimate fees?"

enter_continue
jump $enter_cont
}