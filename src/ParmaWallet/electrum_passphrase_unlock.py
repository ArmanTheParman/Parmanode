import sys
import getpass

from electrum.storage import WalletStorage

##########
# Set the path to your wallet file here.
#
path = "./ATP4"
##########

s = WalletStorage(path)

if not s.file_exists():
    print("No wallet file at path!")
    sys.exit(0)

if not s.is_encrypted():
    print("This wallet is not encrypted!")
    sys.exit(0)


while True:
    password = getpass.getpass("Enter your wallet password:", stream=None)
    try:
        s.decrypt(password)
        with open("cracked_password.txt", 'w') as f:
            f.write(password + '\n')
        break
    except Exception as e:
        print("try again")
        continue


print("Wallet decrypted.")