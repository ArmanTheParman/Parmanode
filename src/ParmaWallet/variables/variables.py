import binascii
xprv_prefix = binascii.unhexlify("0488ADE4") # codes for "xprv" string (version prefix)
xpub_prefix = binascii.unhexlify("0488B21E") # codes for "xpub" string (version prefix)

#default values
depth = b"\x00"     #the derivation depth is coded using 1 byte
fp = b"\0\0\0\0"     # 4 bytes for the fingerprint of the parent's key, but zero if this is the master key
                     # hash 33 byte compressed pubkey, then ripemed160 hash, then take first 4 bytes.
child = b'\0\0\0\0'  # Default child value to use for making master node extended keys
                     # "index" a better name, but it is what it is
