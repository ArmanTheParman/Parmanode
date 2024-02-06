function torrelay_intro {
set_terminal
echo -e "
########################################################################################
$cyan
                                 Tor Relay            
$orange
    There are various types of relay's that you can potentially run, but the one with
    the least headache is called the 'middle' relay, which is the default (and only)
    option with Parmanode. The other types introduce some risks which I prefer not
    to be responsible for. You'll have to research that yourself and make your own
    tweaks.

    A middle relay is the least you can do to help the network and easy enough. It
    requires about 500 GB (0.5 TB) of data passing through your network.  It's not 
    a trivial amount - you're bascially donating bandwidth to help privacy on the 
    internet.

    Initially, your relay will not be used much as information about it is not
    instantaneously propagated; it's takes some time. It is recommended not to turn
    on a Tor relay unless you will be letting it run for a few days at least.

########################################################################################
"
enter_continue
}