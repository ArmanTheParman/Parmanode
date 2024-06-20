import json
import hashlib


class Event:
    def __init__(self, id=None, pubkey=None, created_at=None, kind=None, tags=None, content=None, sig=None): #note: tags is a mutable object and re-called each time the contructor is used. So, should not directly set it.
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


        
    def __repr__(self):
        return f"{{\n  \"id\"={self.id}, \"pubkey\"={self.pubkey}, \"created_at\"={self.created_at}, \"kind\"={self.kind}, \"tags\"={self.tags}, \"content\"={self.content}, \"sig\"={self.sig}"

    def serialise (self):
        print ("["+str(self.id)+"]")

  
e=Event(pubkey="fad6540c8f2fd2a16a25d0d82dd95d3bad7890d435d1690848a0a77d2883a447", created_at=1718421481, kind=1, content="\"Tax is ok, I'm happy to pay tax\".\n\n=\n\n\"I think people getting raped is ok, I like sex\".")
e.serialise()

  