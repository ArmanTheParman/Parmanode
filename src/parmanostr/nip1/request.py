class Request:
    def __init__(self, subscription_id=None, filter=None)



# ["REQ", <subscription_id>, <filters1>, <filters2>, ...], used to request events and subscribe to new updates.

# <filtersX> is a JSON object that determines what events will be sent in that subscription, it can have the following attributes:

# {
#   "ids": <a list of event ids>,
#   "authors": <a list of lowercase pubkeys, the pubkey of an event must be one of these>,
#   "kinds": <a list of a kind numbers>,
#   "#<single-letter (a-zA-Z)>": <a list of tag values, for #e — a list of event ids, for #p — a list of pubkeys, etc.>,
#   "since": <an integer unix timestamp in seconds, events must be newer than this to pass>,
#   "until": <an integer unix timestamp in seconds, events must be older than this to pass>,
#   "limit": <maximum number of events relays SHOULD return in the initial query>
# }

class Client:
    def __init__(self):
        self.message=None
    
class Message:
    def __init__(self):
        self.Event=None
        self.Request=None
        self.Close=None

    