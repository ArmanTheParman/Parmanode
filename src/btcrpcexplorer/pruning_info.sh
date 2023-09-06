# function pruning_info {
    
# echo "
# ########################################################################################

# Note about pruning and indexing configurations (by BTCRPCexplorer developers)
# k
# This tool is designed to work best with full transaction indexing enabled 
# (txindex=1) and pruning disabled. However, if you're running Bitcoin Core v0.21+ you 
# can run without txindex enabled and/or with pruning enabled and this tool will 
# continue to function, but some data will be incomplete or missing. Also note that 
# such Bitcoin Core configurations receive less thorough testing.

# In particular, with pruning enabled and/or txindex disabled, the following 
# functionality is altered:

# You will only be able to search for mempool, recently confirmed, and wallet 
# transactions by their txid. Searching for non-wallet transactions that were 
# confirmed over 3 blocks ago is only possible if you provide the confirmed block 
# height in addition to the txid. Pruned blocks will display basic header information, 
# without the list of transactions. Transactions in pruned blocks will not be available, 
# unless they're wallet-related. Block stats will only work for unpruned blocks. 
# The address and amount of previous transaction outputs will not be shown, only 
# the txid:vout. The mining fee will only be available for unconfirmed transactions.

# ########################################################################################
# "
# enter_continue
# }