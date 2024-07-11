
class config:
    def __init__(self, path: Path):
        if path.exists() == False:
           path.touch() 

        self.file = path
        self.data = set()
        with self.file.open('r') as f:
            for line in f.readlines():
                self.data.add(line.strip() + '\n')
      
      #members:
          # file 
          # data - one line entries

    def __repr__(self):
        return f"Config {str(self.file)}: \n {self.data}"
          
    def read(self) -> set:
        return self.data    
    
    def write(self):
        with self.file.open('w') as f:
            for line in self.data:
                f.write(line)
