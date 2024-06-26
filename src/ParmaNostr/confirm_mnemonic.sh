function confirm_mnemonic {

python3 <<END
import sys, copy
sys.path.append("$pn/src/ParmaWallet")
from classes import *
END
}



#print(sys.path)  

# echo "
# sys.path.append("$pn/src/ParmaWallet/classes")

# from FieldElement import *
# #from S256 import * 
# #from privatekey import *
# #from point import * 

# sys.path.append("$pn/src/ParmaWallet/functions")
# from old_functions import *
# from PW_signing import *

# print("tested python from bash")
# "