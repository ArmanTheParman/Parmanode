import json
import hashlib
from  sign import *

class Event:
    def __init__(self, id=None, pubkey=None, created_at=None, kind=None, tags=None, content=None, sig=None, sec=None): #note: tags is a mutable object and re-called each time the contructor is used. So, should not directly set it.
        self.pubkey = pubkey #use ""
        self.created_at = created_at #number, not string
        self.kind = kind #number, not string
        self.tags = tags or []
        self.content = content #use ""
        self.sig = sig #use ""
       
        self.data = [0,self.pubkey,self.created_at,self.kind,self.tags,self.content] 
        self.json_string = json.dumps(self.data, ensure_ascii=False, separators=(',', ':'))
        self.json_bytes = self.json_string.encode('utf-8')
        self.id = hashlib.sha256(self.json_bytes).hexdigest() #<32-bytes lowercase hex-encoded sha256 of the serialized event data>, use ""
        self.id_bytes = hashlib.sha256(self.json_bytes)


        if sec is not None and isinstance(sec, bytes):
            self.sig = schnorr_sign(msg=self.id_bytes, seckey=sec, aux_rand=int.from_bytes(os.urandom(32), byteorder='big'))

    def __repr__(self):
        return "{\n" \
        + "    " + f"\"id\"={self.id},"                 + "\n"  \
        + "    " + f"\"pubkey\"={self.pubkey},"         + "\n"  \
        + "    " + f"\"created_at\"={self.created_at}," + "\n"  \
        + "    " + f"\"kind\"={self.kind},"             + "\n"  \
        + "    " + f"\"tags\"={self.tags},"             + "\n"  \
        + "    " + f"\"content\"={self.content},"       + "\n"  \
        + "    " + f"\"sig\"={self.sig}"                + '\n' + "}"

    def serialise (self):
        print ("["+str(self.id)+"]")



  