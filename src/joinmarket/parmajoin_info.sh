function parmajoin_info {

set_terminal_high ; echo -e "
########################################################################################
  $cyan                                PARMAJOIN INFO $orange
########################################################################################

    ParmaJoin is software that uses JoinMarket, and gives you an interative menu.

    You'll first have to create a wallet and fund it.

    Then you can decide how you want to coinjoin. There are two ways. Either as
    a maker or a taker.
$cyan
    TAKER:
$orange        
        To be a taker, ie pay a fee to coinjoin, you have to use the GUI. Load it up
        and then use it to load your wallet. Set the configuration opions, and
        then do a single CJ or go through the 'tumbler' continuous mixer.
$cyan
    MAKER:
$orange
        As a maker, you need to use the yield generator. There isn't a GUI for this.
        You go to the Parmanode Yield Generator submenu (after loading a wallet),
        set your CJ terms and then start the Yield Generator background process. 
        This is basically a script which puts your offer on the market. You can see
        the state of the market by running your own OrderBook (see ParmaJoin main
        menu). There'll be a URL and you can go there to see your order is live. 
        You can identify your order with the 'nickname' printed in the YG menu.
$cyan
    Note:
$orange        
        If the YG stops abruptly (ie doesn't go through a graceful shutdown), then
        there will be a residual lock file (which is there to prevent double usage
        of the same wallet). You need to approve this to be deleted before you can
        start the YG again. There's a menu option for that.

$red
        Have a good with your bitcoin and your crypto and everything else that 
        you're playing with. $orange

########################################################################################
"
enter_continue
}