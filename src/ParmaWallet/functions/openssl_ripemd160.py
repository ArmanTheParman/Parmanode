import ctypes
import ctypes.util

# Load the OpenSSL library
libcrypto = ctypes.CDLL(ctypes.util.find_library('crypto'))

class RIPEMD160:
    class EVP_MD_CTX(ctypes.Structure):
        pass

    EVP_MD_CTX_p = ctypes.POINTER(EVP_MD_CTX)

    # Define the function prototypes
    libcrypto.EVP_MD_CTX_new.restype = EVP_MD_CTX_p
    libcrypto.EVP_get_digestbyname.argtypes = [ctypes.c_char_p]
    libcrypto.EVP_get_digestbyname.restype = ctypes.c_void_p
    libcrypto.EVP_DigestInit_ex.argtypes = [EVP_MD_CTX_p, ctypes.c_void_p, ctypes.c_void_p]
    libcrypto.EVP_DigestUpdate.argtypes = [EVP_MD_CTX_p, ctypes.c_void_p, ctypes.c_size_t]
    libcrypto.EVP_DigestFinal_ex.argtypes = [EVP_MD_CTX_p, ctypes.POINTER(ctypes.c_ubyte), ctypes.POINTER(ctypes.c_uint)]
    libcrypto.EVP_MD_CTX_free.argtypes = [EVP_MD_CTX_p]

    def __init__(self):
        self.md_ctx = libcrypto.EVP_MD_CTX_new()
        md_type = libcrypto.EVP_get_digestbyname(b"RIPEMD160")
        libcrypto.EVP_DigestInit_ex(self.md_ctx, md_type, None)

    def update(self, data):
        libcrypto.EVP_DigestUpdate(self.md_ctx, data, len(data))

    def digest(self):
        digest = (ctypes.c_ubyte * 20)()  # RIPEMD-160 digest size
        digest_len = ctypes.c_uint()
        libcrypto.EVP_DigestFinal_ex(self.md_ctx, digest, ctypes.byref(digest_len))
        libcrypto.EVP_MD_CTX_free(self.md_ctx)
        return bytes(digest)

# Example usage
# hasher = RIPEMD160()
# hasher.update(b"Hello, world!")
# hashed_data = hasher.digest()
# print("RIPEMD-160 Hash:", hashed_data.hex())