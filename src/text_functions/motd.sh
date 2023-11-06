function motd {
if [[ -f $HOME/.parmanode/hide_messages.conf ]] ; then
. $HOME/.parmanode/hide_messages.conf >/dev/null
fi

if [[ ${message_motd} == "1" ]] ; then return 0 ; fi

motdfile="$HOME/.parmanode/.motd"
if [[ ! -e $motdfile ]] ; then
echo "motd=0" | tee $motdfile
motd=0
else
source $motdfile >/dev/null 2>&1
motdNum=$((motd + 1))
echo "motd=$motdNum" | tee $motdfile >/dev/null 2>&1
motd=$motdNum
fi

if [[ $motd == template ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

######################################################################################## 

Type$yellow \"Free Ross\"$orange to disable Message of the day.

Hit$cyan <enter>$orange to continue.
"
read choice ; if [[ $choice == "Free Ross" || $choice == "free ross" ]] ; then hide_messages_add "motd" "1" ; fi
return 0
fi
if [[ $motd == 0 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    People have DIED fighting for freedom.

    All you have to do is "risk" your fiat savings and buy bitcoin.

    Don't be a pussy. It's Bitcoin or lick the boot.


######################################################################################## 

Type$yellow \"Free Ross\"$orange to disable Message of the day.

Hit$cyan <enter>$orange to continue.
"
read choice ; if [[ $choice == "Free Ross" || $choice == "free ross" ]] ; then hide_messages_add "motd" "1" ; fi
return 0
fi
if [[ $motd == 1 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    GREED IS THE PATH TO THE DARK SIDE.

    Greed leads to trading, 

    trading leads to shitcoins, 

    shitcoins... leads to SUFFERING.

######################################################################################## 

Type$yellow \"Free Ross\"$orange to disable Message of the day.

Hit$cyan <enter>$orange to continue.
"
read choice ; if [[ $choice == "Free Ross" || $choice == "free ross" ]] ; then hide_messages_add "motd" "1" ; fi
return 0
fi
if [[ $motd == 2 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    Every time you withdraw bitcoin from the exchange to your own wallet, a child 
    escapes from a central banker's basement.

######################################################################################## 

Type$yellow \"Free Ross\"$orange to disable Message of the day.

Hit$cyan <enter>$orange to continue.
"
read choice ; if [[ $choice == "Free Ross" || $choice == "free ross" ]] ; then hide_messages_add "motd" "1" ; fi
return 0
fi
if [[ $motd == 3 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    The 8 laws of Bitcoin adoption: 

    Law #1 : The only time someone stops being a Bitcoiner is when they die.
    Law #2 : If Rule #1 is broken, you're wrong, that person was not actually a 
             Bitcoiner in the first place.
    Law #3 : Bitcoiners tend to create new Bitcoiners.
    Law #4 : Buying bitcoin per se is not adoption. It also needs to be bought with 
             the intent of not selling until it becomes money.
    Law #5 : Given enough time, Bitcoiners will own virtually all the available Bitcoin
    Law #6 : The lower the price is manipulated down, the faster Law 5 eventuates, 
             leading to destruction of price suppression.
    Law #7 : The correct measure of adoption is the number and bitcoin-wealth of 
             Bitcoiners.
    Law #8 : Adoption only increases, and is independent to price.

######################################################################################## 

Type$yellow \"Free Ross\"$orange to disable Message of the day.

Hit$cyan <enter>$orange to continue.
"
read choice ; if [[ $choice == "Free Ross" || $choice == "free ross" ]] ; then hide_messages_add "motd" "1" ; fi
return 0
fi
if [[ $motd == 4 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    There's no obligation to perfectly time the bottom. Just buy bitcoin and be 
    grateful you can.

######################################################################################## 

Type$yellow \"Free Ross\"$orange to disable Message of the day.

Hit$cyan <enter>$orange to continue.
"
read choice ; if [[ $choice == "Free Ross" || $choice == "free ross" ]] ; then hide_messages_add "motd" "1" ; fi
return 0
fi
if [[ $motd == 5 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    My suggestion for the Sat symbol is the dollar sign in reverse (mirror left to
    right) - The reverse $ looks like a 2, and the vertical line like a 1, which
    gives us symbolism of 21.                               

    Bitcoin was designed to end central banking, so the reversing the $ sign is also 
    nice symbolism for the anit-dollar.

######################################################################################## 

Type$yellow \"Free Ross\"$orange to disable Message of the day.

Hit$cyan <enter>$orange to continue.
"
read choice ; if [[ $choice == "Free Ross" || $choice == "free ross" ]] ; then hide_messages_add "motd" "1" ; fi
return 0
fi
if [[ $motd == 6 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    The number of bitcoin that can be bought and taken into self custody is limited to 
    21 MILLION. The number of "bitcoin" that can be bought and left on an exchange is 
    INFINITE.

    Only bitcoin in self custody is scarce.

######################################################################################## 

Type$yellow \"Free Ross\"$orange to disable Message of the day.

Hit$cyan <enter>$orange to continue.
"
read choice ; if [[ $choice == "Free Ross" || $choice == "free ross" ]] ; then hide_messages_add "motd" "1" ; fi
return 0
fi
if [[ $motd == 7 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    The goal is not to buy bitcoin with the best timing, it's to buy bitcoin all 
    the time, LIKE A BOSS, and HODL until The Federal Reserve is tried for crimes 
    against humanity. 

######################################################################################## 

Type$yellow \"Free Ross\"$orange to disable Message of the day.

Hit$cyan <enter>$orange to continue.
"
read choice ; if [[ $choice == "Free Ross" || $choice == "free ross" ]] ; then hide_messages_add "motd" "1" ; fi
return 0
fi

if [[ $motd == 8 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    All bitcoin, without exception, flow from miners to HODLers, sometimes passing 
    through traders or weak hands first (and sometimes the miner and the HODLer are 
    the same person).

    Combine this fact with a fixed supply, and you can CALCULATE the future.
 

######################################################################################## 

Type$yellow \"Free Ross\"$orange to disable Message of the day.

Hit$cyan <enter>$orange to continue.
"
read choice ; if [[ $choice == "Free Ross" || $choice == "free ross" ]] ; then hide_messages_add "motd" "1" ; fi
return 0
fi
if [[ $motd == 9 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    Why on Earth would you want to accumulate a token that a group of people control 
    and create for themselves for free, while you trade your time, effort, and 
    skill for it?

    i.e. ALL government money, and ALL altcoins (euphemism for shitcoins) and CBDCs.

######################################################################################## 

Type$yellow \"Free Ross\"$orange to disable Message of the day.

Hit$cyan <enter>$orange to continue.
"
read choice ; if [[ $choice == "Free Ross" || $choice == "free ross" ]] ; then hide_messages_add "motd" "1" ; fi
return 0
fi
if [[ $motd == 10 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    Bitcoin is stoppable by worldwide tyranny or human extinction.

    If worldwide tyranny wins, we're fucked anyway, and you''ll be poor and \"happy\"
    wheter you buy bitcoin or not. Bitcoin is the ONLY defense against this.

    If someone was invading your country, you don't surrender because \"they might
    win\", or \"winning isn't inevitable\". You defend yourself with what you have at
    your disposal.

    It's Bitcoin or tyranny - make your choice.

######################################################################################## 

Type$yellow \"Free Ross\"$orange to disable Message of the day.

Hit$cyan <enter>$orange to continue.
"
read choice ; if [[ $choice == "Free Ross" || $choice == "free ross" ]] ; then hide_messages_add "motd" "1" ; fi
return 0
fi
if [[ $motd == 11 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    Gold made possible, or caused, fiat. It certainly can't be the solution to it.

    Bitcoin is here to clean up gold's mess.

######################################################################################## 

Type$yellow \"Free Ross\"$orange to disable Message of the day.

Hit$cyan <enter>$orange to continue.
"
read choice ; if [[ $choice == "Free Ross" || $choice == "free ross" ]] ; then hide_messages_add "motd" "1" ; fi
return 0

fi

if [[ $motd == 12 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    \"There is no worst tyranny than to force a man to pay for what he does not want 
    merely because you think it will be good for him.\"

    -- The Moon is a Harsh Mistress, Robert A. Heinlein, on involuntary taxation.

######################################################################################## 

Type$yellow \"Free Ross\"$orange to disable Message of the day.

Hit$cyan <enter>$orange to continue.
"
read choice ; if [[ $choice == "Free Ross" || $choice == "free ross" ]] ; then hide_messages_add "motd" "1" ; fi
return 0
fi
if [[ $motd == 13 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

   The more #bitcoin you get, the more right you're going to be when you're right.

######################################################################################## 

Type$yellow \"Free Ross\"$orange to disable Message of the day.

Hit$cyan <enter>$orange to continue.
"
read choice ; if [[ $choice == "Free Ross" || $choice == "free ross" ]] ; then hide_messages_add "motd" "1" ; fi
return 0
fi
if [[ $motd == 14 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    Don't stress that people aren't getting into Bitcoin early. By definition, not
    all can. Only the early people can be early. Not everyone will accumulate a
    meaningful amount - it's not possible because of the scarce supply; But precisely
    because it is scarce, and the richest can't produce more (no proof-of-stake), the
    distribution of coins will even out over time.

######################################################################################## 

Type$yellow \"Free Ross\"$orange to disable Message of the day.

Hit$cyan <enter>$orange to continue.
"
read choice ; if [[ $choice == "Free Ross" || $choice == "free ross" ]] ; then hide_messages_add "motd" "1" ; fi
return 0
fi
if [[ $motd == 15 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    In 2023, with a hash rate of 420 million TH/s worldwide, the total amount of 
    energy to produce just 1 bitcoin was 1 trillion Joules.

    Meanwhile, the total number of Joules to produce 1 trillion USE was 5 Joules,
    equivalent to charging your phone for less than 1 second.

    Which is more valuable to exchange your labour for?
 
######################################################################################## 

Type$yellow \"Free Ross\"$orange to disable Message of the day.

Hit$cyan <enter>$orange to continue.
"
read choice ; if [[ $choice == "Free Ross" || $choice == "free ross" ]] ; then hide_messages_add "motd" "1" ; fi
return 0
fi
if [[ $motd == 16 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

   True Bitcoiners, the ones that stack because they want to opt out of slavery and 
   monetary oppression, aren't planning to sell, so the price going down doesn't phase
   them and doesn't make them want to be slaves. Wit a low enough price, and time, 
   they will accumulate all the bitcoin. 
 
######################################################################################## 

Type$yellow \"Free Ross\"$orange to disable Message of the day.

Hit$cyan <enter>$orange to continue.
"
read choice ; if [[ $choice == "Free Ross" || $choice == "free ross" ]] ; then hide_messages_add "motd" "1" ; fi
return 0
fi
}