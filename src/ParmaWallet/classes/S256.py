from classes.FieldElement import * 
from classes.point import *
from classes.S256 import * #I don't think I need this

#This stays here as classes below are dependent.
p=(2**256)-(2**32)-977
gx=FieldElement(0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798, p)
gy=FieldElement(0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8, p)
N=0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141 #group order (muliply by N gives infinity point)
#TEST: print (gy**2 % prime == (gx**3 + 7)% prime)  # true


# A secp256k1 field element
class S256Field (FieldElement):

    def __init__(self, num, prime=None):  #No need to require the prime as a user parameter when calling
        super().__init__(num=num, prime=p)  #p set above
    
    def __repr__(self):
        return '{:x}'.format(self.num).zfill(64)   #:x specifies Hex string. zfill pads with zeros
    
    def sqrt(self):
        return self**((p+1)//4)

# defined A and B here as code below is dependent
A=S256Field(0)
B=S256Field(7)

class Signature:
    def __init__(self,r,s):
        self.r = r
        self.s = s

    def __repr__(self):
        return 'Signature({:x},{:x})'.format(self.r,self.s)

    def der(self, output="bytes"):
        rbin=self.r.to_bytes(32,'big')
        rbin=rbin.lstrip(b'\x00')
        if rbin [0] & 0x80:
            rbin=b'\x00'+rbin
        result = bytes([2, len(rbin)]) + rbin
        
        sbin=self.s.to_bytes(32,'big')
        sbin=sbin.lstrip(b'\x00')
        if sbin[0] & 0x80:
            sbin = b'\x00'+sbin
        result += bytes ([2, len(sbin)]) + sbin
        final_result= bytes([0x30, len(result)]) + result
        if output=="bytes":
            return final_result
        if output=="hex":
            return hex(int.from_bytes(final_result,"big"))


class S256Point(Point):
    
    def __init__(self, x, y, a=A, b=B):
       if type(x) == int:
           super().__init__(x=S256Field(x), y=S256Field(y), a=a, b=b) 
       else: #in case x/y is None
           super().__init__(x=x, y=y, a=a, b=b)
    
    def __rmul__(self, coefficient):
        coef = coefficient % N
        return super().__rmul__(coef)
   
    def verify(self, z, sig):
        s_inv = pow(sig.s, N -2 , N) 
        u = z * s_inv % N
        v = sig.r * s_inv % N
        total = u * G + v * self
        return total.x.num == sig.r

    def sec(self, compressed="compressed", format="bytes"):

        if compressed == "uncompressed":

            if format == "bytes":
                return b'\x04' + self.x.num.to_bytes(32, 'big') \
                    + self.y.num.to_bytes(32, 'big')

            if format == "hex":
                return (b'\x04' + self.x.num.to_bytes(32, 'big') \
                    + self.y.num.to_bytes(32, 'big')).hex()
        
        if compressed == "compressed":
            if self.x.num % 2 == 1 and format=="hex":  
                return (b'\x03' + self.x.num.to_bytes(32, 'big')).hex()
            if self.x.num % 2 == 1 and format=="bytes":  
                return b'\x03' + self.x.num.to_bytes(32, 'big')
            if self.x.num % 2 == 0 and format=="hex":  
                return (b'\x02' + self.x.num.to_bytes(32, 'big')).hex()
            if self.x.num % 2 == 0 and format=="bytes":  
                return b'\x02' + self.x.num.to_bytes(32, 'big')

    @classmethod
    def parse(self, sec_bytes):
        #returns Point object
        
        if sec_bytes[0] == 0b00000100: #(4)
            x=int.from_bytes(sec_bytes[1:33], 'big')
            y=int.from_bytes(sec_bytes[33:65], 'big')
            return S256Point(x,y)
        
        x = S256Field(int.from_bytes(sec_bytes[1:], 'big'))

        #y^2 = x^3 + 7
        right=x**3 + B
        y=right.sqrt() #this may return an odd or even number, both valid for the equation, but
                        #we need the odd one only.
        print(type(y))
        if sec_bytes[0] == 3: #if y is odd 
            if y.num % 2 == 0:
                new_y=S256Field(p-y.num)
                return S256Point(x, new_y)
            else:
                return S256Point(x,y)
        else:
            if y.num % 2 == 1:
                new_y=S256Field(p-y.num)
                return S256Point(x, new_y)
            else:
                return S256Point(x,y)

            
# G is defined here as class S256point defined above    
G = S256Point(gx,gy)
