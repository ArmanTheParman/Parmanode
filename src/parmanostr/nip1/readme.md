### Nostr NIP 1

The NIP will be put into python code in this directory.

https://github.com/nostr-protocol/nips/blob/master/01.md


# {


#   "pubkey": <32-bytes lowercase hex-encoded public key of the event creator>,
#   "created_at": <unix timestamp in seconds>,
#   "kind": <integer between 0 and 65535>,
#   "tags": [
#     [<arbitrary string>...],
#     // ...
#   ],
#   "content": <arbitrary string>,
#   "sig": <64-bytes lowercase hex of the signature of the sha256 hash of the serialized event data, which is the same as the "id" field>
# }


# Example:
# {
#   "id": "6c33cf915a93d3f2e3fc8ed3de7e79f48dc37d02d44e72e8f9b8b19e969985bc",
#   "pubkey": "e51ac385186db52f34c935a601c23f4b7f41d33893293dc44a7cf9ee1c204718",
#   "created_at": 1718432659,
#   "kind": 1,
#   "tags": [],
#   "content": "testing",
#   "sig": "e3c258bdbbd5195287c383fa198bbd11bae0690a56995d996841436a8522dcb569f22808ea83a0f02a16ae650149075140f5c2bf86de941ce1739c5ce8db46ee",
# }