from pathlib import Path
from config.variables_f import *
from tools.debugging_f import *
from tools.files_f import *
from tools.screen_f import *
from tools.system_f import *

def motd():

    motd_header=f"""{orange}
########################################################################################{cyan}

                                Message of the Day

{orange}"""

    motd_base=f"""{orange}########################################################################################
"""

    motd_text = [f"""{cyan}
    People have DIED fighting for freedom.

    All you have to do is "risk" your fiat savings and buy bitcoin.

    Don't be a pussy. It's Bitcoin or lick the boot.                                
""", f"""
   A Bitcoin node is the ultimate way to say{red} "Fuck off"{cyan}.

   "These are my rules; you can't change them. If your payment doesn't register on 
   MY node, the invoice isn't paid."

   That's freaking powerful.
""" , f"""
    Every time you withdraw bitcoin from the exchange to your own wallet, a child 
    escapes from a central banker's basement.
""", f"""
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
""", f"""
    My suggestion for the Sat symbol is the dollar sign but upside down.
    It looks like a 2, and the vertical line like a 1, which gives us symbolism of 21.                               

    Everytime someone writes that sats symbol, they are writing 2 and 1. Glorious.

    Bitcoin was designed to end central banking, so flipping the $ sign is also 
    nice symbolism for the anit-dollar.
""", f"""
    The number of bitcoin that can be bought and taken into self custody is limited to 
    21 MILLION. The number of "bitcoin" that can be bought and left on an exchange is 
    INFINITE.

    Only bitcoin in self custody is scarce.
""", f"""
    The goal is not to buy bitcoin with the best timing, it's to buy bitcoin all 
    the time, LIKE A BOSS, and HODL until The Federal Reserve is tried for crimes 
    against humanity. 
""", f"""
    All bitcoin, without exception, flow from miners to HODLers, sometimes passing 
    through traders or weak hands first (and sometimes the miner and the HODLer are 
    the same person).

    Combine this fact with a fixed supply, and you can CALCULATE the future.
""", f"""
    Why on Earth would you want to accumulate a token that a group of people control 
    and create for themselves for free, while you trade your time, effort, and 
    skill for it?

    i.e. ALL government money, and ALL altcoins (euphemism for shitcoins) and CBDCs.
""", f"""
    Bitcoin is stoppable by worldwide tyranny or human extinction.

    If worldwide tyranny wins, we're fucked anyway, and you'll be poor and "happy"
    whether you buy bitcoin or not. Bitcoin is the ONLY defense against this.

    If someone was invading your country, you don't surrender because "they might
    win", or "winning isn't inevitable". You defend yourself with what you have at
    your disposal.

    It's Bitcoin or tyranny - make your choice.
""", f"""
   Gold made possible, or caused, fiat. It certainly can't be the solution to it.

    Bitcoin is here to clean up gold's mess.
""", f"""
    "There is no worst tyranny than to force a man to pay for what he does not want 
    merely because you think it will be good for him."

    -- The Moon is a Harsh Mistress, Robert A. Heinlein, on involuntary taxation.
""", f"""
   The more bitcoin you get, the more right you're going to be when you're right.
""", f"""
    Don't stress that people aren't getting into Bitcoin early. By definition, not
    all can. Only the early people can be early. Not everyone will accumulate a
    meaningful amount - it's not possible because of the scarce supply; But precisely
    because it is scarce, and the richest can't produce more (no proof-of-stake), the
    distribution of coins will even out over time.
""", f"""
    In 2023, with a hash rate of 420 million TH/s worldwide, the total amount of 
    energy to produce just 1 bitcoin was 1 trillion Joules.

    Meanwhile, the total number of Joules to produce 1 trillion USD was 5 Joules,
    equivalent to charging your phone for less than 1 second.

    Which is more valuable to exchange your labour for?
""", f"""
   True Bitcoiners, the ones that stack because they want to opt out of slavery and 
   monetary oppression, aren't planning to sell, so the price going down doesn't phase
   them and doesn't make them want to be slaves. With a low enough price, and with 
   time, they will accumulate all the bitcoin. 
""", f"""
   True Bitcoiners, the ones that stack because they want to opt out of slavery and 
   monetary oppression, aren't planning to sell, so the price going down doesn't phase
   them and doesn't make them want to be slaves. With a low enough price, and with 
   time, they will accumulate all the bitcoin. 
""", f"""
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
""", f"""
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
{bright_blue}
     https://armantheparman.com/parmanvault/ {cyan}        (link is not clickable)

     Or, I teach people the skill of banking...
{bright_blue}
     https://armantheparman.com/mentorship/  {cyan}        (link is not clickable)

     I constantly hear people complaining about Bitcoin being too difficult to 
     self-custody for normies, and things need to improve.
{red}
     NO THEY DO NOT.
{green}     
     Bitcoin is good enough NOW.  {cyan}
""", f"""
    As long as Bitcoin has a conversion price from dollars, I will continue to move 
    dollars into Bitcoin at ALL prices.

    Why save in the the money others print for free?

    HAVE YOU NO DIGNITY??
""", f"""
   Why are ALL shitcoins scams?

        1. Do you consider fiat money to be a scam?

        If no, end of conversation, have fun staying poor.

        2. Specifically what part of fiat do you consider makes it a scam? Not 
        something undesirable, but specifically a SCAM.

        3. Now look at your favourite shitcoin.
""", f"""
    If you love a woman, do you measure her worth by what your ex girlfriend thinks 
    of her?
    
    No. But this is the mindset of measuring your bitcoin value in USD.
""", f"""
    There is no virtue in being obedient to rulers.

    Language is important: Don't call the 'president', or 'prime minister', or 'king',
    your 'leader'.

    No, they are your{red} RULER{cyan}.

    They don't lead, they rule; they leech.

    Fuck 'em. Long live shit. Rebel with Bitcoin.
""", f"""
    Seriously, being a part of spreading adoption & securing the network may be one of
    the most significant things I can do with my life. I ad no bloody idea, I only
    wanted some freedom money, dammit.
    

    -- Anonymous Parman Padawan, you know who you are ;) 
""", f"""
    There are 8 billion people on a massive ship that's sinking, and 21 million 
    lifeboats.

    There's room for everyone, but ppl have to share.

    At 52k, you can book an entire lifeboat to yourself, and survive the catastrophe 
    in luxury. 🤣

    Also, you can get some lifeboats for loved ones.
""", f"""
    Bitcoin math made simple:

    Everyone who has bitcoin wants more bitcoin.

    Everyone who doesn't have bitcoin will one day buy/earn bitcoin, and then they'll 
    want more bitcoin.

    The number of bitcoin available is fixed.

    So, Bitcoin goes up in value for as long as humans exist.
""", f"""
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
""", f"""
   I love fiat money because it steals from me, and that makes me work harder and 
   spend faster, which helps the economy.

   Bitcoin is bad because people will save for the future, never spend and we'll all 
   starve. 
   
   (sarcasm, ok?)
""", f"""
    Selling bitcoin at the blow off top is like selling your lifeboat to get a better 
    seat on the Titanic. Don't be dumb.
""", f"""
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

    CYPHYERPUNKS WRITE CODE (DOCUMENTARY) {bright_blue}
    https://www.youtube.com/watch?v=9vM0oIEhMag
{cyan}
""", f"""
    Sure, thinking is great, but the government will just ban it.
""", f"""
   The 'ohfuckening' is when Bitcoin is suddenly in such huge demand, it's not 
   available on exchanges, and no one knows what price it is because there isn't one. 

   Oh fuck, indeed, slave.
""", f"""
    You may think you 'own' your house, but if your country gets invaded, your new 
    ruler may not see it your way. 

    With Bitcoin, your ownership claim is independent to your ruler.
""", f"""
    Under a bitcoin standard, those who do the most for the world get the most back, 
    measured and stored as #ƨats.

    Currently, those who exploit the world best get most of the dollars.
""", f"""
    People don't realise "democracy" is just a socially acceptable form of tyranny, 
    and it's marching relentlessly to towards outright overt tyranny.

    Government ALWAYS gets bigger and more powerful. The individual always loses 
    power... Until revolution. Join us. 
{bright_blue}
    https://armantheparman.com/joinus
   {cyan}
""",f"""
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
""", f"""
            Bitcoin price psychology...

            $35,000  - stack it like it's hot
            $69,000  - we're back baby
            $74,000  - ok we're going to moon 
            $70,000  - this is bad
            $69,000  - this is bad, REAL bad 
            $74,000  - promising but I don't trust it
            $71,500  - Fuck, I knew it
            $69,000  - Oh well, see you in 4 years
            $110,000 - suspicious 
            $998,000 - that escalated quickly
""", f"""
    Listening to 10,000 hours of podcasts of people talking about how they got into 
    Bitcoin and their price predictions is not research.

    Research here ... {green}
           
    https://armantheparman.com {cyan}
""", f"""
    If you self-custody your #bitcoin, you would have heard 'don't memorise' - that's 
    fine, but you still need to rely on memory to know where your seed is stored, 
    what your HWW pin is, how many wallets you have etc. 

    If you trust your heirs, you can get them to share this burden while you're 
    still alive
""", f"""
    Sending your kid to a government school, and avoiding homeschooling, mainly 
    because you are worried they won't fit in with society, is like sending your kid 
    to join a gang because you are worried they might not fit in in jail.

    Fuck society.
""", f"""
    Money does not need utility. Money BUYS utility. That's the point of it.
"""]
     
    if pco.grep("motd_off"):
        return True
    with motd_counter.open('r') as f:
        value = int(f.read().strip())
    print("value is", value)
    set_terminal() 
    print(motd_header)
    print(motd_text[value % len(motd_text)])
    print(motd_base)
    choice = enter_continue()
    if choice in {"free ross", "Free Ross"}:
        pco.add("motd_off=True")

    counter("motd")
    return True