function mentorship {

set_terminal_bit_higher ; echo -e "
########################################################################################
$cyan
                           Mentorship with Parman$orange
                                
                                
    Need help with Bitcoin security, self-custody, and inheritance?

    Bitcoin self-sovereignty, while maintaining high security, safety, and privacy. 
    
    Few people will take the time to build their technical skills. It can be daunting.
    It is crucial to get your coins off the exchange (safely!), as the bare minimum, 
    but progressing beyond that is also important.

    This is a one-to-one mentorship course (not a group/class), at your own pace, 
    involving multiple video call meetings - it could take weeks, or if you want to 
    take your time, months.

    The program includes …

            Bitcoin knowledge (understanding private keys, blockchain, mining etc)
            Running a node
            Using a hardware wallet
            Verifying Bitcoin software using gpg (public/private key cryptography 
                    verification and hashes)
            Making a watching-only wallet
            Making an air-gapped computer
            Safe key generation
            Safe key storage
            Multisignature wallet generation
            How to hide your coins on the blockchain
            How to remove KYC tainting of coins
            UTXO management
            Using the Lightning Network
            Inheritance planning

########################################################################################
"
choose "epmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;; 
esac

set_terminal ; echo -e "
########################################################################################

    Reference #1: Identity is hidden for privacy, but available on request, on a 
    case-by-case basis.

    Subject: Re: Reference for Parman (BTC mentorship program)

    Hi ZZZZ,

    Thank you for your email. A few months ago I completed my mentorship with Parman. 
    I already had a relatively high level of knowledge both in theory and in practice, 
    but I had reached the maximum I could learn by myself and I realised that I needed a 
    more complete, structural approach with particular focus on privacy and security.

    Parman’s site was by far the best one I ever found, therefore I did not hesitate 
    one moment to apply for a mentorship. It turned out to be the money best spent in 
    years. Thanks to Parman I learned everything I needed to and more. Parman is an 
    absolutely great teacher (being myself a university professor, I know something 
    about it): he’s patient, focused on the essential, he manages to make complicated 
    things very simple. In addition, he’s an extremely kind person. His in-depth 
    technical knowledge about Bitcoin and his privacy/security standards in how to use 
    Bitcoin are, I believe, the maximum that you can get on the market. Therefore, my 
    answer to your first question is that I was extremely happy with his services.

    The Zoom sessions worked great for me because they were flexible (which was exactly 
    what I needed): they lasted the time needed for the topic discussed (no more and 
    no less); we fixed the appointments when we were both available. Without this 
    flexibility I probably would not have managed to complete the mentorship and 
    certainly I would have enjoyed it much less. The membership process lasted 
    approximately two months, give or take (more intense at the beginning, spontaneously 
    less intense towards the end)…. My level of privacy and security (and therefore my 
    confidence) in my use of Bitcoin increased enormously after this mentorship: even 
    more than I expected. I warmly recommend him.

    Kind regards,

    YYYY

########################################################################################
"
choose "epmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;; 
esac

set_terminal ; echo -e "
########################################################################################

    Reference #2: Identity is hidden for privacy, but available on request, on a 
    case-by-case basis.

    Subject: Reference for Parman (BTC Mentorship Program)

    Hi ZZZZ,

    Glad to answer your questions regarding our experience with Parman. We had a 
    unique situation that Parman helped navigate us through. He was very patient and 
    kind as he helped us secure our bitcoin and he gave us sound advice on how to 
    proceed with our situation. The Zoom sessions were easy, no problems. I can’t 
    really answer your questions on how long the mentorship program took as our 
    situation was unique, although we are going to send our son through his 
    mentorship program this summer. Parman was very careful with our private 
    information, often reminding us not to reveal too much.

    All that being said, I can wholeheartedly recommend Parman’s mentorship program. 
    He is a rare man of intellect and integrity. He is also very patient and 
    understanding. We had a great experience and learned quite a bit.

    Hope this helps, if I can answer any more questions, let me know.

    Kind regards,

    WWWW

########################################################################################                                
"
choose "epmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;; 
esac

set_terminal ; echo -e "
########################################################################################                            

                        Contact Arman The Parman for more info:

                        armantheparman@protonmail.com

########################################################################################
" ; previous_menu ; return 0                           
}
