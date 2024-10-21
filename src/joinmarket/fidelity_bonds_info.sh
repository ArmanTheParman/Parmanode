function fidelity_bonds_info {
set_terminal ; echo -e "
########################################################################################
$cyan
    Fidelity bonds$orange in JoinMarket are a privacy-enhancing feature that works by 
    proving ownership of coins that are time-locked. By locking up coins for a set 
    period, participants can provide a stronger signal of long-term commitment to the 
    network, which makes it more difficult for observers to link transactions and 
    reduces the risk of Sybil attacks in coinjoins.

    When you choose 'yes' for fidelity bonds during wallet creation, JoinMarket 
    enables the wallet to support this feature. This means that, if you wish to 
    participate in coinjoins as a maker, you can lock up some of your coins for a 
    fixed period. The longer you lock your coins, the more weight or "fidelity" your 
    bonds have, making you a more attractive coinjoin partner. Fidelity bonds 
    improve the privacy of both makers and takers in the JoinMarket system.

    If you're planning to use JoinMarket frequently as a maker, enabling 
    fidelity bonds can increase your chances of being selected for coinjoin rounds. 
    However, it requires locking up coins, so it's a feature meant for more 
    advanced users who are okay with having some funds time-locked for privacy 
    benefits.

########################################################################################
"
enter_continue
return 0
}