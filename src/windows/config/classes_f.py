from pathlib import Path

class config:
    def __init__(self, path: Path):
        if path.exists() == False:
           path.touch() 

        self.file = path
        self.data = set()
        with self.file.open('r') as f:
            self.fulldata = f.read()
            for line in self.fulldata.splitlines(True):
                self.data.add(line)

      #members:
          # file 
          # data - one line entries

    def __repr__(self):
        return f"Config {str(self.file)}: \n {self.data}"
          
    def read(self, datatype="set") -> set:
        if datatype == "full":
            return self.fulldata
        elif datatype == "set":
            return self.data    
    
    def write(self): #for adding variable contents to the file.
        with self.file.open('w') as f:
            for line in self.data:
                f.write(line)

    def add(self, toadd: str):
        self.data.add(toadd + '\n')
        self.write()
    
    def remove(self, toremove: str):
        temp = self.data.copy()
        for line in self.data:
            if toremove in line:
                temp.remove(line) 
        self.data = temp
        self.write()

    def grep(self, checkstring: str, returnline=False): 
        for line in self.data:
            if checkstring in line:
                if returnline == True: return line
                return True
        if returnline == True: return "" #match not found
        return False

    def truncate(self):
        self.data.clear()
        self.fulldata = ""
        with self.file.open('w'):
            pass
