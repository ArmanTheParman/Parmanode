function motd {

# For later    zenity --info --title="MOTD" --text="Message" --width=400 --height=100

if [[ -f $HOME/.parmanode/hide_messages.conf ]] ; then
. $HOME/.parmanode/hide_messages.conf >$dn
fi

if grep -q "hide_censorship=1" $hm ; then
another="${red}    Hint: type 'motd' for another."
else
another="${red}    Hint: type 'motd' for another. 



                     #CENSORSHIP OPTIONS...
                    $cyan forkids) $orange for kid friendly language.
                    $cyan ff)      $orange to censor the 'f' word only.
                    $cyan uncensor)$orange to clear censorship
                    $cyan xxxhide) $orange hide/unhide censorship options.

                     Please report any censorship accidents."
fi

if [[ ${message_motd} == "1" ]] ; then return 0 ; fi #hide message choice

#Censorship

censor_fuck=("1" "10" "18" "23" "32" "36" "37" "40" "49" "55" "63" "65")
censor_shit=("9" "17" "21" "23" "55" "58" "63" "67")
censor_all=("${censor_shit[@]}" "${censor_fuck[@]}")


source $pc 2>$dn #access motd value


if ! grep -q "motd=" $pc ; then
    parmanode_conf_add "motd=0" 
    motd=0
fi

#DON'T FORGET TO CHANGE THE MOD TO THE HIGHEST NUMBERERD MESSAGE + 1
motd=$((motd % 85))

if [[ $forkids == 1 ]] ; then
    found=1
    while [[ $found == 1 ]] ; do  #this 'found' nonsense is to increment until a non-censored motd is reached
        for num in "${censor_all[@]}"; do
            if [[ $num == $motd ]] ; then
            motd=$((motd +1))
            found=1
            break
            fi
            found=0
        done
    done
fi

if [[ -z $forkids ]] && [[ $censor_ff == 1 ]] ; then
    found=1
    while [[ $found == 1 ]] ; do  #this 'found' nonsense is to increment until a non-censored motd is reached
        for num in "${censor_all[@]}"; do
            if [[ $num == $motd ]] ; then
            motd=$((motd +1))
            found=1
            break
            fi
            found=0
        done
    done
fi

#motd value is loaded. Now increment and save for next time...

        parmanode_conf_remove "motd="
        parmanode_conf_add "motd=$((motd + 1))"

if [[ $motd == 0 ]] ; then
announce "Please type 'forkids' to keep the 'Message of the Day' propaganda kid-friendly.'"
case $enter_cont in forkids) echo "forkids=1" >> $hm ; export forkids=1 ;; q) exit ;; esac

set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    People have DIED fighting for freedom.

    All you have to do is "risk" your fiat savings and buy bitcoin.

    Don't be a pussy. It's Bitcoin or lick the boot.

######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 1 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

   A Bitcoin node is the ultimate way to say$red \"Fuck off\".$orange

   \"These are my rules; you can't change them. If your payment doesn't register on 
   MY node, the invoice isn't paid.\"

   That's freaking powerful.
 
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 2 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    Every time you withdraw bitcoin from the exchange to your own wallet, a child 
    escapes from a central banker's basement.

######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
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
    Law #5 : Given enough time, Bitcoiners will own virtually all the available bitcoin
    Law #6 : The lower the price is manipulated down, the faster Law 5 eventuates, 
             leading to destruction of any price suppression.
    Law #7 : The correct measure of adoption is the number and bitcoin-wealth of 
             Bitcoiners.
    Law #8 : Adoption only increases, and is independent to price.

######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 4 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    There's no obligation to perfectly time the bottom. Just buy bitcoin and be 
    grateful you can.

######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 5 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    My suggestion for the Sat symbol is the dollar sign but upside down.
    It looks like a 2, and the vertical line like a 1, which gives us symbolism of 21.                               

    Everytime someone writes that sats symbol, they are writing 2 and 1. Glorious.

    Bitcoin was designed to end central banking, so flipping the $ sign is also 
    nice symbolism for the anit-dollar.

######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
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
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 7 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    The goal is not to buy bitcoin with the best timing, it's to buy bitcoin all 
    the time, LIKE A BOSS, and HODL until The Federal Reserve is tried for crimes 
    against humanity. 

######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
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
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
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
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 10 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    Bitcoin is stoppable by worldwide tyranny or human extinction.

    If worldwide tyranny wins, we're fucked anyway, and you'll be poor and \"happy\"
    whether you buy bitcoin or not. Bitcoin is the ONLY defense against this.

    If someone was invading your country, you don't surrender because \"they might
    win\", or \"winning isn't inevitable\". You defend yourself with what you have at
    your disposal.

    It's Bitcoin or tyranny - make your choice.

######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 11 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    Gold made possible, or caused, fiat. It certainly can't be the solution to it.

    Bitcoin is here to clean up gold's mess.

######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 12 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    \"There is no worst tyranny than to force a man to pay for what he does not want 
    merely because you think it will be good for him.\"

    -- The Moon is a Harsh Mistress, Robert A. Heinlein, on involuntary taxation.

######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 13 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

   The more bitcoin you get, the more right you're going to be when you're right.

######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
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
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 15 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    In 2023, with a hash rate of 420 million TH/s worldwide, the total amount of 
    energy to produce just 1 bitcoin was 1 trillion Joules.

    Meanwhile, the total number of Joules to produce 1 trillion USD was 5 Joules,
    equivalent to charging your phone for less than 1 second.

    Which is more valuable to exchange your labour for?
 
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 16 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

   True Bitcoiners, the ones that stack because they want to opt out of slavery and 
   monetary oppression, aren't planning to sell, so the price going down doesn't phase
   them and doesn't make them want to be slaves. With a low enough price, and with 
   time, they will accumulate all the bitcoin. 
 
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 17 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    GREED IS THE PATH TO THE DARK SIDE.

    Greed leads to trading, 

    Trading leads to shitcoins, 

    Shitcoins... leads to SUFFERING.

######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 18 ]] ; then
set_terminal 52 88 ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    A rant for people who don't know why Bitcoin 2.0 is not possible:

    The first thing to understand is that money is made up of a counting unit 
    (physical or digital), ie the \"tech\", and a network of people. You can't have one 
    without the other - that's not money.

    Any copy and/or improvement to bitcoin, which I accept is possible, does not 
    copy the PEOPLE. Also, if there truly was some innovation that solved a problem 
    Bitcoin hasn't, then Bitcoin can just copy the tech. If the tech is secret, then 
    the new competitor can't become money, because open source is non negotiable. 
    The group of people that are driving this revolution are doing so to replace the 
    system, not copy it. Closed source (and all altcoins with their leaders), are 
    more of the same thing.

    Going back to what money is made of, units and people, Bitcoin isn't there yet;
    not enough people use it (yet). But it is the leading contender of free market, 
    open source, digital yet scarce money that cant be stopped/controlled.

    Nothing comes close. And so, as Bitcoiners keep buying cheap bitcoin, and birthing 
    new Bitcoiners, the revolution of money progresses, and the fulfilment of Bitcoin 
    becoming money (universally accepted unit preferred as payment) becomes 
    inevitable. Also, Bitcoiners will be holding all the available bitcoin, as
    weak hands will sell to them as the price goes up or down.

    It's either Bitcoin wins, worldwide tyranny wins, or humans go extinct. There 
    are no other logical possibilities. (Except: AI kills humans and uses bitcoin,
    but it would have to be a multiple competitve AIs, economising resources and 
    trading like humans - I bet against it).

    If you're not accumulating bitcoin because tyranny might win, 51% attack or 
    whatever obscure attack is dreamed up, well fuck you, you pussy. Harden up and 
    fight. It's not like your being asked to put your life on the line; just your 
    wealth/savings. If you've got 0.0 btc shame on you.

    Rant over. 

######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 19 ]] ; then
set_terminal 56 88 ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

     Bitcoin is not meant to destroy banking.

     The purpose of Bitcoin is to remove the control of money out of the hands of
     rulers/CENTRAL_BANKERS. This problem has corrupted regular (retail/commercial)
     banking - a vital service for a prosperous society.

     Banking right now is a monopoly, protected by government regulation. When the 
     power of governments decline, banking will become a FREE MARKET. anyone, but not
     everyone, will be a banker.

     Do you know who will be the bankers of the future? The Bitcoiners of TODAY (YOU).

     The ones who know how to self-custody properly; they will be able to offer 
     custodial services (as banks do now) to normies. They will also be able to 
     connect debtors with creditors (what banks are truly needed for).

     The competition to offer banking services will be fierce, and banking will become
     cheap and of high quality. This is good for everyone.

     Just like how a society with money allows specialisation with little risk to 
     the individual, and not everyone needs to be their own dentist, baker, farmer etc
     ... so too, they won't be their own banker.

     For example, Unchained Capital or Casa can offer custodial/collaborative services
     to anyone, well, so can I, and I do (KYC free).
$bright_blue
     https://armantheparman.com/parmanvault/ $orange        (link is not clickable)

     Or, I teach people the skill of banking...
$bright_blue
     https://armantheparman.com/mentorship/  $orange        (link is not clickable)

     I constantly hear people complaining about Bitcoin being too difficult to 
     self-custody for normies, and things need to improve.
$red
     NO THEY DO NOT.
$green     
     Bitcoin is good enough NOW.
$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 20 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    As long as Bitcoin has a conversion price from dollars, I will continue to move 
    dollars into Bitcoin at ALL prices.

    Why save in the the money others print for free?

    HAVE YOU NO DIGNITY??

######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 21 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

   Why are ALL shitcoins scams?

        1. Do you consider fiat money to be a scam?

        If no, end of conversation, have fun staying poor.

        2. Specifically what part of fiat do you consider makes it a scam? Not 
        something undesirable, but specifically a SCAM.

        3. Now look at your favourite shitcoin.

######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 22 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange
    

    If you love a woman, do you measure her worth by what your ex girlfriend thinks 
    of her?
    
    No. But this is the mindset of measuring your bitcoin value in USD.

######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 23 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange
    

    There is no virtue in being obedient to rulers.

    Language is important: Don't call the 'president', or 'prime minister', or 'king',
    your 'leader'.

    No, they are your$red RULER$orange.

    They don't lead, they rule; they leech.

    Fuck 'em. Long live shit. Rebel with Bitcoin.
    

######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 24 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    Seriously, being a part of spreading adoption & securing the network may be one of
    the most significant things I can do with my life. I ad no bloody idea, I only
    wanted some freedom money, dammit.
    

    -- Anonymous Parman Padawan, you know who you are ;) 


######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 25 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    
    There are 8 billion people on a massive ship that's sinking, and 21 million 
    lifeboats.

    There's room for everyone, but ppl have to share.

    At 52k, you can book an entire lifeboat to yourself, and survive the catastrophe 
    in luxury. 🤣

    Also, you can get some lifeboats for loved ones.
 
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 26 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    Bitcoin math made simple:

    Everyone who has bitcoin wants more bitcoin.

    Everyone who doesn't have bitcoin will one day buy/earn bitcoin, and then they'll 
    want more bitcoin.

    The number of bitcoin available is fixed.

    So, Bitcoin goes up in value for as long as humans exist.
    
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 27 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    You've backed up your Bitcoin mnemonic seed phrase properly, right? You are 
    SURE??

    Here's a hypothetical TEST ...

    Factory reset your hardware wallet, and restore it from seed.

    Nervous?

    Then your procedure wasn't good enough.

    You MUST be confident in your backups such that you can wipe or lose the HWW device, 
    and not panic about restoring it safely.

    Ideally, you should have practiced restoring, from whatever system you used to back 
    up, BEFORE loading up the thing with your life savings.
    
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 28 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

   I love fiat money because it steals from me, and that makes me work harder and 
   spend faster, which helps the economy.

   Bitcoin is bad because people will save for the future, never spend and we'll all 
   starve. 
   
   (sarcasm, ok?)

######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 29 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    Selling bitcoin at the blow off top is like selling your lifeboat to get a better 
    seat on the Titanic. Don't be dumb.

######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 30 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    When Satoshi solved the problem of digital money that 'requires no 3rd party', he 
    was talking about getting rid of the CENTRAL BANKS that keep a ledger to avoid 
    double spending, not retail banking and self custody. A central bank which 
    prevents digital double spending and allows payments across space without the 
    need of a physical P2P item is a problem, not because it holds our wealth like a 
    retail bank does, but because we have to TRUST it as it has power over the entire 
    money supply and can create it out of thin air. What would people with the ability 
    to print money have? UNLIMITED POWER. Power to pillage all the resources of the 
    world, corrupt/own politicians, control the education system (many schools follow 
    the UN curriculum now), own the media, the universities, the publishers, the 
    science, and control what you think. They own economics schools, and make you 
    brainwashed into believing that their theft of 2% inflation is GOOD FOR YOU!!

    THAT is what unlimited power allows. That is what the cypherpunks were fighting 
    against. And they finished the job with the culmination of Bitcoin finally - 
    the last iteration of money they were trying to create. The one that finally 
    worked was the one that could not be stopped. Self custody and 3rd parties have 
    nothing to do with the desire for "electronic cash with no 3rd party". 
    
    For Satoshis's sake, don't be a BCasher, and study this, so you don't fall for 
    their tricks when they misrepresent what Satoshi meant.

    BCashers, GFY.

    CYPHYERPUNKS WRITE CODE (DOCUMENTARY) $cyan
    https://www.youtube.com/watch?v=9vM0oIEhMag
$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 31 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    
    Sure, thinking is great, but the government will just ban it.

    
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 32 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

   The 'ohfuckening' is when Bitcoin is suddenly in such huge demand, it's not 
   available on exchanges, and no one knows what price it is because there isn't one. 

   Oh fuck, indeed, slave. 
    
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 33 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    You may think you 'own' your house, but if your country gets invaded, your new 
    ruler may not see it your way. 

    With Bitcoin, your ownership claim is independent to your ruler.
    
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 34 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    Under a bitcoin standard, those who do the most for the world get the most back, 
    measured and stored as #ƨats.

    Currently, those who exploit the world best get most of the dollars.
    
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 35 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    People don't realise "democracy" is just a socially acceptable form of tyranny, 
    and it's marching relentlessly to towards outright overt tyranny.

    Government ALWAYS gets bigger and more powerful. The individual always loses 
    power... Until revolution. Join us. 
$bright_blue
    https://armantheparman.com/joinus
   $orange 
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 36 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

   'Democracy' has become synonymous with 'freedom'.

    It is anything but that.

    'Anarchy', literally, 'no rulers', is actually synonymous with 'freedom', but has 
    become incorrectly synonymous with 'chaos'.

    You've all been scammed into tyranny. Just take a look at your tax rate. Did you 
    get to vote who taxes you so I guess you're free right? 

    If you actually are looking for a system for society that is based on ethical 
    principles and logic, you need to study libertarianism, the backbone of which is 
    the upholding of the 'non-aggression principle'.

    Libertarianism is not actually a political system it is a 'leave me the fuck 
    alone' system.

######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 37 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


            Bitcoin price psychology...

            \$35,000  - stack it like it's hot
            \$69,000  - we're back baby
            \$74,000  - ok we're going to moon 
            \$70,000  - this is bad
            \$69,000  - this is bad, REAL bad 
            \$74,000  - promising but I don't trust it
            \$71,500  - Fuck, I knew it
            \$69,000  - Oh well, see you in 4 years
            \$110,000 - suspicious 
            \$998,000 - that escalated quickly

######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 38 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    Listening to 10,000 hours of podcasts of people talking about how they got into 
    Bitcoin and their price predictions is not research.

    Research here ... $green
           
    https://armantheparman.com $orange

######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 39 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    If you self-custody your #bitcoin, you would have heard 'don't memorise' - that's 
    fine, but you still need to rely on memory to know where your seed is stored, 
    what your HWW pin is, how many wallets you have etc. 

    If you trust your heirs, you can get them to share this burden while you're 
    still alive

######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 40 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    Sending your kid to a government school, and avoiding homeschooling, mainly 
    because you are worried they won't fit in with society, is like sending your kid 
    to join a gang because you are worried they might not fit in in jail.

    Fuck society. 

######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 41 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    Money does not need utility. Money BUYS utility. That's the point of it.

######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 42 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    If evil people were to ever gain the power to print money, then they could buy the 
    planet's assets and all public companies, buy/influence politicians, groom 
    political puppets, buy retail/commercial banks, buy media to control truth, invest 
    in education/curriculums to control beliefs, and buy/influence/fund academia, 
    control science publications, monopolise supply chains in energy and food, 
    document all people with movement licenses/citizenship, and form supragovernmental
    bodies (WHO, WEF, UN) - and use all of that to manipulate the public into 
    believing that they are free, their vote matters, and that having some people 
    print money to manage the economy is good for them.

    If you agree that's what evil people with such power would do, how do you know 
    they haven't already?     

######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 43 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

   Bankers, and hidden people above them, are enriched not buy *earning* paper/fiat 
   money, but by creating paper that everyone else has to work for, and using it to 
   plunder the planet's assets.

   Bankers are rich in assets not money. This is true power.

   Everyone else is renting, or working to compete for those assets that bankers got 
   for free. It's slavery.

   We end this by opting out of the scam, and stop working for their money. 
   Accumulating Bitcoin helps it become the new world money. Then no one can scam in 
   this way. They lose power. Join us.
$bright_blue
   https://armantheparman.com/joinus/
$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 44 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange
    Don't trade Bitcoin 

    That's not what it's for. 

    Just because you can trade it doesn't mean you should, or are obliged to. 
$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 45 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    Scarcity is not what makes Bitcoin valuable...

    It is simply a MINIMUM REQUIREMENT for a token to be considered a contender as 
    worldwide dominant ubiquitously accepted money.

    There are other minimum requirements, such as SUFFICIENT privacy, and SUFFICIENT
    fungibility, and Bitcoin has them all. 

    Once a token has met the minimum requirements, it is then not a competition of
    which has better features, but instead, which has the best saleability. Whichever
    has a dominant lead, due to how money evolves, increases dominance, until there
    is only one winner.

    It's a moot point, because nothing else has all the minimum requirements, so there 
    is no competition to Bitcoin; "there is no second best".
$bright_blue
    https://armantheparman.com/onemoney/ 
$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 46 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    Regular insta YOLO smash no-look market bitcoin buys without hesitation at every 
    opportunity is good for the soul.
$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 47 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    To those who think Bitcoin security will fall as the block subsidy dwindles...

    Not true, it's not the amount of reward that makes Bitcoin secure, it's the 
    difficulty of getting 51% of the available equipment and energy, and that 
    difficulty is independent to the reward.

    If mining rewards fall, ASIC prices fall to keep them near profitable for most new buyers. 

    This makes it easier for decentralised distribution of ASICS.

    It's just wrong to think the block reward is related to securely linearly, it's 
    just a mechanism to make the incentives work, and the network spam free as block 
    space gets more valuabe.
$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 48 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    Ladies and gentlemen - Bitcoin.

    In other news... nah there's nothing else worth mentioning.
$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 49 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    Just because Bitcoin has so far had 4 year cycles, doesn't mean the dollar will 
    die in 4 year cycles.

    The ohfuckening is coming suddenly out of the orange.
$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 50 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    Price really flies when your telling people to have fun staying poor

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 51 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    You can't love your family enough.

    You can't hate your government enough.

    You can't buy bitcoin enough.
$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 52 ]] ; then
set_terminal 48 88 ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


You like the idea of smart contracts on blockchains?

Smart contracts are essentially for replacing enforcement of ownership through the 
legal system (and the state, and violence) with a digital contract ("code is law").

For those who want to put their property on "the blockchain", when illegal immigrants 
invade and decide to occupy your house, you can throw the Ethereum "smart" contract 
in their face. That'll show them.

Now that you see the contract doesn't enforce ownership, you still need the law and 
the state, what was its initial purpose again? Oh, yeah, to replace the enforcement 
of ownership. LOL.

You see, digital contracts can only enforce digital things. They can never enforce 
real-world things. They can only prove you paid for something, or prove ownership, 
not enforce.

A simple contract on paper will do for that. Or a digital database, eg run by the 
government, the very people you rely on for enforcement of ownership. You don't 
need it to be "smart" and you don't need it to be decentralised - what are you 
trying to overthrow? The people you need to enforce your contract.

It's nonsensical to think you can replace the legal system. It is encoded in mountains 
of text and there are always new exceptions and situations arising. Who are you 
going to appeal to when a smart contract doesn't encode the subtleties of a new 
situation? Replacing the legal system with coding nerds is a stupid thing to hope for.
$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 53 ]] ; then
set_terminal 48 88 ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    A friendly rant about early Bitcoin adoption...

    I've come to accept that bitcoin is going to succeed, and by logical definition, 
    not everyone can be "early" - because being early is relative to other people; it's 
    an ORDER thing, not temporal.

    Whether the whole world adopted it in one year or 10, the order they adopted 
    bitcoin matters to the meaningful advantage of being "early".

    And so, we can't make more people early - that doesn't make sense. All we can 
    do is ...

        1) Affect the order of who is earlier than others, preferably people we care 
           about - so don't spend too much time on idiots, haters, rude people, or 
           socialists. Let natural selection do it's thing, or in other words, use 
           "HFSP" judiciously.

        2) Help Bitcoin adoption along, but maximise your impact, again, with 
           judicious use of HFSP.

        3) Make the world better in some way 🧡 - Bitcoin will be more valuable the 
           better the world is.

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 54 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    Parman's take on Bitcoin ETFs...

    These are SO bad, they're not even on par with IOUs... They are "I don't owe 
    you's" (IDOUs).

    Imagine buying a car online, say a rare antique, but no delivery is permitted - 
    why send dollars for that? Because someone might send you more dollars for it one 
    day?

    What if then, the dollar hyperinflates? You still can't get the car, all you get 
    is a truck full of dollar bills which you can buy nothing with. This is the same 
    with a Bitcoin ETF.

    The essence of why bitcoin has value is because it will be money one day when the 
    dollar dies. On that day, bitcoin will be on the moon but an ETF it will actually 
    be worthless.

    Therefore, "I don't owe you's" are essentially like a Ponzi scam!

    I haven't even begun to discuss the faith required in the system for the ETFs to 
    actually be backed, nor the potential honey pot for governments to forcefully 
    exchange them for printed dollars using an executive order for national security 
    and dollar stability. They did it with gold, they'll do it with Bitcoin ETFs 
    (futule with real bitcoin).

    Do everything you can to get real bitcoin in your own wallet. 

    Bitcoin in self custody is limited to 21M.

    Bitcoin on exchanges and ETFs are infinite in supply.
$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 55 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    Bitcoin is created by MINING (that had an energy cost, it's not free). Not a 
    single person got special treatment. Satoshi created the PROTOCOL, an idea, from 
    nothing, fine, but really it was INVENTED from a collection of existing ideas like 
    proof of work and crytptography, but he SOLVED the Byzantine generals problem, 
    something previously thought to be unsolvable for decades. But then he mined 
    something that everyone thought was worthless, and gave himself no special 
    privilege, and sold none of his coins, and disappeared and gave Bitcoin as a gift 
    to humanity.

    Anyway, the shitcoins then came and COPIED the idea, which is fine, that's not 
    the issue, but ETH was PREMINED, meaning that 80% of the total supply, the fucking 
    TOTAL supply, not just a little bit, was awarded, FOR FREE, no mining, to the 
    founders. WTF. And you people buy it?? Do you even know why Bitcoin was invented?

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 56 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    If someone is planning to sell 5% of their stack in the next Bitcoin bull run, 
    then 95% of their coins represent Bitcoin adoption.

    Adoption has nothing to do with price, and everything to do with how many people 
    and how many coins are not for sale until Bitcoin is adopted as world money. 

    Everything else is just noise and not contributing to the end goal.

    I'm not saying you have to have 100% of your coins adopted, or all your wealth in 
    Bitcoin, people should decide what's best for their life situation - I'm just 
    saying that coins destined to be sold before we win are not adopted coins.

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 57 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    Despite my mission to teach self custody, I accept that holding your own entire 
    wealth is not for everyone -  it's OK, really...

    I always say, expecting everyone to learn the skills of banking and security is 
    unrealistic and goes against the benefits of having money in society. 

    Money helps us escape the inefficiencies of barter, and allows everyone to 
    specialise in what they are good at, rather than doing everything themselves.

    Banking, like baking, dentistry, or building - is just another skillset, and time 
    drainer.

    The existence of Bitcoin banks will not mean that the purpose of Bitcoin has been 
    corrupted or has failed ...

    Bitcoin wasn't created to end banks. It's fixing the money - so they no one can 
    create it for free and scam humanity.

    Yes it means that some will engage in fractional reserve, and yes that has the
    *effect* of increasing the money supply, but it's acceptable...


########################################################################################
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
set_terminal ; echo -e "
########################################################################################

    Whatever the increase, it has an anchor to the real fixed supply, and can't keep 
    growing, because as it does, bankruptcies increase pulling it back to reality. 
    Free markets, baby, accept it.

    This natural market force, with some people fucking around and finding out, 
    doesn't mean there is any sacrifice to the main mission. We would still have 
    sound money, and have ended central banks (yes self custody TODAY helps defeat 
    them, but that is for the "then they fight you" stage, not the "then you win" 
    stage).

    We, the earliest Bitcoiners, have the responsibility to hold our own coins, but 
    also the opportunity to be the custodians of the future, if we so choose. There 
    will be fierce competition, no monopolies, with a myriad of black and white market 
    options that can't be stopped. 

    People will have the choice to use services for convenience, and won't have to 
    rely on a small handful of custodians to hold all their wealth, they can 
    diversify, OR, is their wealth justifies/demands it, can call someone like me 
    to mentor them to learn self banking skills and extreme security (excuse the smol 
    plug). 

    Why should the poorest people with 5 sats to their name be concerned with security 
    or the ability to open their own lightning channels? I hope this part is obvious, 
    not going to elaborate.

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 58 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    Nobody can really tell you what the Bitcoin price will do in the short term. Anyone
    who tries to is full of shit. The only thing we can say with confidence is that
    Bitcoin will become world money and is grossly undervalued now at \$0.087 million
    dollars. People who are selling are forced to due to life situation, or they're
    fools. You can take advantage of them by buying bitcoin at any price - be thankful
    you can. I don't trade or pretend to know if a dip will come. If I have spare
    dollars, I immediately exchange that trash for precious sats.
$green
    My recommendation is to rid yourself of the unrealistic burden that you have to
    time your bitcoin purchase to perfection$orange; just buy it and accept fate. Every single
    Bitcoiner has regrets and it's just not possible to only buy at the bottoms. Buy
    all the tops, middles and bottoms - just regularly buy and be happy. Be at peace
    with it. I hope that helps.

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 59 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    I don't believe I know the future... I know the future possibilities and 
    impossibilities, and in each possibility (Bitcoin wins, or worldwide tyranny wins), 
    I choose the same option -$red no diversification$orange.

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 60 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    If someone is putting all their life energy into something rather than 
    diversifying, you should be suspicious they know something you don't, instead of 
    arrogantly assuming you know better and they must be insanely stupid.

    If they are not alone, AND they're winning, you are obligated to find out.

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 61 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    Always be careful to not use "inflation" interchangeably with "CPI".

    They are not the same thing. CPI is whatever you are told it is, completely 
    disconnected from price inflation, and calculated however they want in a way you 
    CANNOT VERIFY.

    Also, "inflation" means growth in MONEY QUANTITY, nothing to do with prices, so 
    use "price inflation".

    Undoing the scam involves spreading correct information - fixing the language 
    corruption can help somewhat.

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 62 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    When you buy Bitcoin, your break-even price is tyranny.

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 63 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    Dont forget the most important purpose of Bitcoin ...

    Bitcoin ends the ability of anyone (central banks) from creating money for free 
    (fiat), who then use it to plunder the planet's assets (which worsens the wealth 
    gap), and they control peoples' minds (via media, education, scientific 
    publishing, advisory bodies, politicians) to help them maintain control and the 
    belief that their control of money is necessary, reasonable, and good for them. 
    Thinking otherwise becomes "extremism".

    If you place "fuck the banks" higher in priority to "fuck the CENTRAL banks" 
    (very different), then you become susceptible to shitcoiner narratives, and 
    dangerous Bitcoin-upgrade narratives that risk priority 1 in favour of improving 
    priority 2.
$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 64 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    If evil people were to ever gain the power to print money then they could buy the 
    planet's assets and all public companies, buy/influence politicians, groom 
    political puppets, buy retail/commercial banks, buy media to control truth, 
    education/curriculums to control beliefs, and buy/influence/fund academia, control 
    science publications, monopolise supply chains in energy and food, document all 
    people with movement licenses/cirizenship, and form supragovernmental advisory 
    bodies - and use all of that to manipulate the public into believing that they 
    are free, their vote matters, and that having some people print money to manage 
    the economy is good for them.

    If you agree that's what evil people with such power would do, how do you know 
    they haven't already?

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 65 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    The$green ohfuckening$orange is when Bitcoin is suddenly in such huge demand, it's not 
    available on exchanges, and no one knows what price it is because there isn't one. 

    Oh fuck, indeed, slave.

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac

if [[ $motd == 66 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


                           Give me your retarded, your poor,

                    Your subscribed masses yearning to trade charts,

                  The wretched refuse of your teeming engagement farm.

                      Send these, the chairless, tempest-toss to me,

                         I lift my lamp beside the orange door!

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac

if [[ $motd == 67 ]] ; then
set_terminal_high ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

    In 10 years...

    - Bitcoin will not have died for 25 years and be worth many more dollars each

    - 10,000 more shitcoins will have died

    - The top 10 shitcoins will look different and probably won't include the mother 
      arsehole, ETH.

    - Shitcoins will be more numerous

    In that scenario, a smaller percentage of newcomers will be scammed by shitcoins 
    or fall for unit bias. The difference between scams and Bitcoin will be even more 
    obvious.

    Don't hold on to your shitcoins hoping to break even. Let go of your emotional 
    attachment to trash. 

    If you had 100% of your wealth in bitcoin, never having owned a shitcoin, would 
    you actually trade some for the shitcoins you have now? 

    If not, sell that shit today, and be emotionally cleansed. Be at peace with it 
    and ignore any gambling gains you're imagining you deserve.

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 68 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange

   You know what's beautiful? 

   Bitcoin moving from people who don't want it to people who want it. 

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac
if [[ $motd == 69 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    It's not just the fact that fiat money is not sound that's the problem, it's that 
    you're made to accept that it's OK to work for it, while others are legally 
    permitted to counterfeit it... FOR YOUR OWN GOOD!

    Do you understand the humiliation?

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac

if [[ $motd == 70 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    There are people who say I'm buying bitcoin with I hope that I can sell it to 
    someone in the future for a higher price. 

    No, you can't have my bitcoin even if you pay a higher price. 

    I'm gonna need someone to shine my shoes though, interested?

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac

if [[ $motd == 71 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    If you think HODLing is painful, rather than liberating and joyous,  you're 
    missing some critical understanding I suspect.

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac

if [[ $motd == 72 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    I don't buy Bitcoin because tyranny can't win. 

    I buy it because it might.

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac


if [[ $motd == 73 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    There is no such thing as a Bitcoiner with shitcoins, they are shitcoiners with 
    Bitcoin.

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac

if [[ $motd == 74 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    Hot tip: you don't need to learn about NFTs, altcoins, or any other type of scam.

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac

if [[ $motd == 75 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    Democracy is a 51% attack on freedom.

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac

if [[ $motd == 76 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    Bitcoin at 100k might feel like winning for some people, but I'm not satisfied 
    until central banks and the pedophile rings they facilitate are destroyed.

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac

if [[ $motd == 77 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    Countries are not "run". 

    They are ruled. 

    People and businesses do not need a government to operate, they are "petmitted", 
    by rulers, who practice extortion through the threat, ultimately, of violence.

    It is the government that is run, not the country.

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac

if [[ $motd == 78 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    Arguing that shitcoins are a gateway to Bitcoin is like arguing that sexual abuse 
    as a child is a gateway to a loving relationship as an adult.

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac

if [[ $motd == 79 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    Quick reminder that your government is not your country, it's your ruler.

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac

if [[ $motd == 80 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    Bitcoin will help you get rich while simultaneously teaching you that you don't 
    need to be.

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac

if [[ $motd == 81 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    You don't have to explain to another Bitcoiner how unbelievably profound a way 
    Bitcoin has changed them as a person, including their whole outlook on life, not 
    just their own but the whole species.

    A simple nod will do; they know.

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac

if [[ $motd == 82 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    There are an awful lot of people who know nothing about the tech who are in it 
    for the tech.

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac

if [[ $motd == 83 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    Do not load your main Bitcoin stack wallet on your phone as a watching wallet. 
    Delete that immediately.

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac

if [[ $motd == 84 ]] ; then
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Message of the day $orange


    The largest criminal organisation in a region, by DEFINITION, is the government.

    If a crime organisation becomes bigger than the government, it would then BE the 
    government.

    Once you see it you can't unsee it.

$orange
######################################################################################## 
$another
"
enter_continue ; jump $enter_cont ; choice="$enter_cont"
fi ; case $choice in endthefed|EndTheFed|ENDTHEFED|end) hide_messages_add "motd" "1" ; return 0 ;; esac

}

#DON'T FORGET TO CHANGE THE MOD TO THE HIGHEST NUMBERERD MESSAGE + 1