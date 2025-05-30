function set_lnd_alias {
nogsedtest
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                              LIGHTNING NODE ALIAS
$orange
    Please type in an alias for your LND node. It's a good idea not to give away
    personal information about yourself on the public network. For example, don't
    use your real name or Twitter handle. If you leave it blank, the node will be
    called Parmanode_LND followed by a random number.

    Info about privacy. Can people know much about you if you run a LND node? It
    depends on a lot of things, but the most revealing thing is how much bitcoin you
    put on your node channels. This is publically searcable on lightning explorers
    like 1ml.com and others. If you put your name as the alias, anyone can easily
    see how much bitcoin you put in your channel, and your IP address; so, don't do
    that.

    Please type in your alias choice...

########################################################################################
"
read alias_choice

if [[ $alias_choice == "" ]] ; then 
echo "Empty string"
# random_alias_number, RAN
RAN=$((10000000+ RANDOM % 90000000)) 
alias="Parmanode_LND_$RAN"
echo "Your alias will be $alias"
else
alias=$alias_choice
echo "Your alias will be $alias"
fi

echo -e "
Hit$cyan <enter>$orange to accept or $red(x)$orange to try again."
read choice
if [[ $choice == "" ]] ; then break ; else continue ; fi
done

please_wait
if [[ $install == litd ]] ; then
    if [[ -f $HOME/.lit/lit.conf ]] ; then 
    sudo gsed -i "/alias=/c\lnd.alias=$alias" $HOME/.lit/lit.conf
    fi
else
    if [[ -f $HOME/.lnd/lnd.conf ]] ; then 
    sudo gsed -i "/alias=/c\alias=$alias" $HOME/.lnd/lnd.conf
    fi
fi
}