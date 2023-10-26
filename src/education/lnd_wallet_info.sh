function lnd_wallet_info {

set_terminal ; echo -e "
########################################################################################
$cyan
                                  Lightning Wallet
$orange

    Be aware, when you make a lightning wallet, you'll be given a 24 word mnemonic
    "seed". It's important to know that this is$green not a BIP39 seed$orange and cannot be 
    recovered with a hardware wallet or software wallet like Electrum or Sparrow, 
    unless you do some "hardcore computerisation". It's possible, I've done it, but
    it creates a new set of problems, so don't go there.

    Lightning "seeds" are Aezeed standard seeds. They can be recovered with lightning
    wallet software like LND - not regular wallets.

    Write down the seed, keep it safe, make a duplicate and keep the copies in
    different locations (the way you of course do with your regular bitcoin wallet
    seeds). Separating the location of backups guards against disasters like fire in
    one location.

    Don't put too much in your lightning wallet - it's a hot wallet after all, with
    private keys on a computer connected to the internet, potentially exposed to
    malware.

    Of interest is that LND wallets will use taproot addresses - they start with
    bc1p.

########################################################################################
"
enter_continue
}