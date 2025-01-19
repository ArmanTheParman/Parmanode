function get_parmans_help {
while true ; do
set_terminal_high ; echo -e "
########################################################################################$cyan
                             Parman has your back :)$orange
########################################################################################


$cyan
                 s)$orange         System Review (Free)
$cyan
                 v)$orange         Video Call - 2 hour session
$cyan
                 mm) $orange       Mentorship info
$cyan
                 bsr) $orange      Bitcoin Security Review
$cyan
                 ep) $orange       Parman's Bitcoin Estate Planning
$cyan
                 pv) $orange       Parman Vault (collaberative/self custody)
$cyan
                 lost)$orange      Lost coin recovery
$cyan
                 pp)$orange        Privacy course
$cyan                
                 btcp) $orange     BTC ParmanPay
$cyan
                 pag)$orange       Buy a ParmAirGap - Airgapped Laptop
$cyan
                 pz)$orange        Buy a ParmaZero - Airgapped Pi Zero
$cyan 
                 pn)$orange        Buy a ParmanodL Laptop - A Node and Wallet in one
                 
$bright_blue
    Email:         armantheparman@protonmail.com
    Twitter/X:     @parman_the
$orange
########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
q|Q) exit ;; p|P) return ;; m|M) back2main ;;
s)
     system_review
     ;;
v)
     video_call
     ;;
mm|MM)
     mentorship
     ;;
bsr)
     bsr
     ;;
ep)
     estate_planning
     ;;
pv)
     parman_vault
     ;;
lost)
     lost_coins
     ;;
pp)
     privacy_course
     ;;
btcp)
     btcpp
     ;; 
pag)
     parmairgap
     ;;
pz)
     parmazero
     ;;
pn)
     parmanodl_laptop
     ;;
*)
     invalid
     ;;

esac
done
}
function system_review {
set_terminal ; echo -e "
########################################################################################

    If you're having issues with your Parmanode machine you can...

 $cyan     1)$orange   Ask for help by email
 $cyan     2)$orange   Ask for help in the Telegram Parmanode group chat
 $cyan     3)$orange   Send a system report (from tools menu) to Parman by email
 $cyan     4)$orange   Have Parman fix it remotely (requires you to trust Parman with access to
           your computer)

########################################################################################
"
enter_continue ; jump $enter_cont 
}

function video_call {
set_terminal ; echo -e "
########################################################################################$cyan
                             Video Call with Parman$orange
########################################################################################

    You can book a video call with Parman for 2 hours. Write down your Bitcoin-related
    questions to make best use of your time.
    
    Contact Parman for more information.

########################################################################################
"
enter_continue ; jump $enter_cont 
}


function bsr {
set_terminal ; echo -e "
########################################################################################$cyan
                           Bitcoin Security Review$orange
########################################################################################

    You've made a considerable stack and you've done all you can to take every 
    precaution to protect it. It's safe. But have you thought of everything? Do you 
    want someone to go over your setup and give an opinion, or look for holes?

    Contact me to book a review.

########################################################################################
"
enter_continue ; jump $enter_cont 
}


function estate_planning {
set_terminal ; echo -e "
########################################################################################$cyan
          Collaborative (Parman Vault) or Independent Bitcoin Custody $orange
########################################################################################        

    Organising your inheritance structure, with or without the involvement of the 
    state, on your own terms, with privacy, is not easy. There are many factors to 
    consider, including:

    - If you can trust your heirs to not steal while you are alive (and ways to adjust 
      your strategy)
    - How to prevent loss (eg increasing redundancy) without increasing the risk of 
      theft (a trade-off)
    - Proper storage of wallet recovery information
    - How to ensure your heirs are not left helpless not knowing what to do (and 
      potentially getting scammed when asking for help)
    - How to resist/minimise the state from taking a cut, particularly any KYC-free 
      coins
    - Future-proofing your storage
    - Education of heirs while you are still alive
    - Playing out the disaster scenarios and adjusting strategy accordingly to risks 
      that apply to you
    - Contingency planning for the simultaneous death of you and all heirs
    - Whether to incorporate the strategy into the execution of a will, or shall it 
      be in parallel to a will?
    - Tax minimisation

########################################################################################    
"
enter_continue ; jump $enter_cont
set_terminal ; echo -e "
########################################################################################

    Parman’s Estate Planning service helps you in two steps:

    STEP 1: A thorough consultation with Parman to discuss your situation and 
            design a strategy that works for you.

    STEP 2: (optional) Learn with Parman how to set up DIY wallets safely and 
            privately (single signature or multisignature, depending on step 1), 
            or create a collaborative multisignature wallet, with or without Parman 
            as a key-holder.

    Please contact Parman for more information.

########################################################################################
"
enter_continue ; jump $enter_cont 
}

function parman_vault {
set_terminal_high ; echo -e "
########################################################################################$cyan
                        Collaborative Custody - KYC free
           Collaborative (Parman Vault) or Independent Bitcoin Custody$orange
########################################################################################

    Get the benefits of storing your bitcoin off the exchange and in a secure 
    multisignature NON-KYC wallet, using only OPEN SOURCE software.

    This is tricky to do on your own for newcomers and can be tricky even for those who 
    are experienced too.

    With this service, you’ll be introduced to safe Bitcoin storage practices and 
    multisignature wallets, with step-by-step guidance along the way.

    A 2 of 3 multisignature wallet will be made (or another combination if 
    required/requested). The keys will be held in self-custody or shared custody, 
    which is completely the choice of the customer. Eg:

    SELF-CUSTODY OPTION: 2 of 3 multisignature wallet (or other), customer has all 
    3 keys. Set up guided by Parman.

    SHARED CUSTODY OPTION: 2 of 3 multisignature wallet (or other), customer has 2 
    keys (in hardware wallets), Parman holds 1 key as a backup.

    Software options: Only open-source software will be used. Electrum, Sparrow, or 
    Specter are all options. To be determined together.

    Hardware options: A different brand of hardware wallet for each private key is 
    optimal. I have tested and can recommend ColdCard, BitBox2, and Trezor T.

########################################################################################
"
enter_continue ; jump $enter_cont 
}

function lost_coins {
set_terminal ; echo -e "
########################################################################################$cyan
                           Lost Coins Recovery Service$orange
########################################################################################
    
    Messing up self custody and losing your keys to your wealth is sickening.

    Hang in there, there may be hope.

    Sometimes, people do not understand what is possible, so it may be worth 
    discussing your situation and seeing if recovery is possible.
    
    Contact Parman for help.

########################################################################################
"
enter_continue ; jump $enter_cont 
}
function privacy_course {
set_terminal ; echo -e "
########################################################################################$cyan
                             Bitcoin Privacy Course$orange
########################################################################################
    
    There are many things you can do to improve your privacy while using Bitcoin, and 
    for many reasons. None of them are illegal, and being private is not illegal. 
    Privacy is for everyone. It is a human right.

    Most people have KYC coins. Even if they are in self custody, they are subject 
    to government attack.

    Mixing coins on its own does not do enough to prevent this, as your KYC exchange 
    data exposes how much you own, so hiding the location of the coins on the 
    blockchain is not enough.

    If private non-KYC coins are managed poorly, that will undo any privacy, and 
    cause them to be linked to your identity, effectively making them KYC coins. 
    Great care needs to be taken.

    This detailed course will teach you the skills you need.

    Similar to the self-custody mentorship service, classes are one to one, via 
    video calls.

    Contact for more info.

########################################################################################
"
enter_continue ; jump $enter_cont 
}

function btcpp {
set_terminal_high ; echo -e "
########################################################################################$cyan
                                 BTC Parman Pay$orange
########################################################################################
    
    BTC Parman Pay is a service to help Bitcoiners accept bitcoin payments online or 
    in a physical store.

    Publishing a Bitcoin address online is terrible for privacy. There is a better way.

    In addition, individual Bitcoin addresses don’t allow Lightning payments, which 
    is essential if you anticipate multiple small payments. Lightning requires i
    nvoices, and generating them yourself manually for each individual is not workable 
    if you want to scale.

    To solve these problems, you can run a Bitcoin node, BTCPay Server, a Lightning 
    node, and a Lightning wallet.

    There 3 main steps involved:

      - A BTCPay Server PoS app on a virtual private server (VPS), or your home computer 
        (with a reverse proxy to a VPS to keep your IP address private).

      - A customised point-of-sale app on your website, or at the physical store on 
        a touchpad device like an iPad. Similar to the one you’ll see when you click 
        the green donate button below, powered by Parman’s node.

      - Optional access over Tor (for you and customers)

    
    Contact Parman for more info.

########################################################################################
"
enter_continue ; jump $enter_cont 
}


function parmairgap {
set_terminal ; echo -e "
########################################################################################$cyan
                                   ParmAirGap $orange
########################################################################################

    A ParmAirGap is a Linux Air-gapped laptop that can be used for…

    - Safe key generation.
    - Key testing/verification: check the seed you use on your hardware wallet is 
      correctly generating addresses and not using a secret parallel seed to trick you.
    - Writing encrypted letters: Useful with Parman's Inheritance Planning Service.
    - Key storage (but you should encrypt if you do that, eg password protected wallet 
      files)
    - Stateless wallet access (don't save seeds and enter them each time)
    - Signing device (Use the camera to capture QR codes from your ParmandL Laptop 
      which has your watching wallet connected on the same machine to your node).
    - Unencrypted key storage: Consider it the same level of security as writing 
      seeds on paper, but with extra defence (password to access encrypted drive).
    - OPTIONAL: Tails OS USB drive, a mobile and easy to hide enctryped drive/OS with 
      Electrum Wallet that can attach to your ParmAirGap. Add your wallet files here, 
      and import transactions to sign via QR codes.
$bright_blue
    Go to: 
        https://parmanode.com/parmairgap/ 
    for more info and purchase options.
$orange

########################################################################################
"
enter_continue ; jump $enter_cont 
}


function parmazero {
set_terminal ; echo -e "
########################################################################################$cyan
                                   ParmaZero $orange
########################################################################################

    A ParmaZero is a low powered Pi Zero single board computer that has no Wifi or
    BlueTooth capability, with necessary software to function as an AirGapped Bitcoin 
    computer - Similar to a SeedSigner but with more functionality. Similar to a
    ParmAirGap but much less powerful, slower, and cheaper.
$bright_blue
    More info and purchase options...
    https://armantheparman.com/buy-pi-zero/
$orange
########################################################################################
"
enter_continue ; jump $enter_cont 
}


function parmanodl_laptop {
set_terminal ; echo -e "
########################################################################################

    If you want another Parmanode machine, you can get a ready made, fully synced,
    ParmanodL Laptop (or Pi4/5) build and tested by Parman, shipped to anywhere.
$bright_blue
    More info and purchase options...
    https://armantheparman.com/buyparmanodl/
$orange
########################################################################################
"
enter_continue ; jump $enter_cont 
}
