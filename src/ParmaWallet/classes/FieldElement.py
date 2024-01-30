class FieldElement:
    def __init__(self, num, prime):

        if num >= prime or num < 0:
            error = 'error, Num of {} not in the range 0 to {}'.format(num, prime -1)
            raise ValueError(error)
        
        self.num = num
        self.prime = prime
    
    #String to print about self

    def __repr__(self):
        return 'FieldElement_prime:{}(num:{})'.format(self.prime, self.num)
    
    #Overloaded operators

    def __add__(self, other):
        #important to check type of "other" first
        if isinstance(other, int):
            raise TypeError("Can't add an integer to a FieldElement")
        if other.prime != self.prime:
            raise TypeError("Adding error; primes don't match")
        if other is None: #i.e. field element is zero
            return self.__class__(self.num, self.prime)
        return self.__class__( (self.num + other.num) % self.prime, self.prime)
   
    def __sub__(self, other):
        if isinstance(other, int):
            raise TypeError("Can't subtract an integer from a FieldElement")
        if other.prime != self.prime:
            raise TypeError("Subtraction error; primes don't match")
        if other is None: #i.e. field element is zero
            return self.__class__(self.num, self.prime) 
        return self.__class__( (self.num - other.num) % self.prime, self.prime)

    def __mul__(self, other):
        if isinstance(other, int):
            return self.__class__(self.num*other%self.prime, self.prime)
        if other.prime != self.prime:
            raise TypeError("Multiplication error; primes don't match")
        return self.__class__( (self.num * other.num) % self.prime, self.prime) 

    def __rmul__(self, other):
        return self.__class__(self.num*other%self.prime, self.prime)
    
    def __pow__(self, exponent):
        n = exponent % (self.prime - 1) # every p-1 can be removed because it results in 1
        num = pow(self.num, n, self.prime)
        return self.__class__(num,self.prime)

    def __truediv__(self, other):
        if isinstance(other, int):
            denominator = other
            new_numerator = pow(denominator, self.prime - 2, self.prime )
            answer = (self.num * new_numerator) % self.prime
        else:
            if other.prime != self.prime:
                raise TypeError("TrueDiv error; primes don't match")
            denominator = other.num
            new_numerator = pow(denominator, self.prime - 2, self.prime)
            # new_numerator_check = (denominator**(221))%223
            answer = (self.num * new_numerator) % self.prime
        return self.__class__(answer, self.prime)
   
    # allows a point to be divided by a scalar, the scalar has to be a field element.
    def __rtruediv__(self, other):
        denominator = other.__class__(other.x, other.y, other.a, other.b)
        new_numerator = pow(denominator, self.prime - 2, self.prime )
        answer = (self.num * new_numerator) % self.prime
        return self.__class__(answer, self.prime)
    
    def __eq__(self, other):
            if isinstance(other, int):
                raise TypeError("Can't compare FieldElement with integer")
            if other is None:
                if self is not None:
                    return False
                if self is None: 
                    return True
            return self.num == other.num and self.prime == other.prime
        
    def __gt__(self, other):
        if isinstance(other, int):
            return self.num > other
        if other.prime != self.prime:
            raise TypeError(" > error; primes don't match") 
        return self.num > other.num 

    def __ge__(self, other):
        if isinstance(other, int):
            return self.num >= other
        if other.prime != self.prime:
            raise TypeError(" > error; primes don't match") 
        return self.num >= other.num 

    def __le__(self, other):
        if isinstance(other, int):
            return self.num <= other
        if other.prime != self.prime:
            raise TypeError(" > error; primes don't match") 
        return self.num <= other.num 

    def __lt__(self, other):
        if isinstance(other, int):
            return self.num < other
        if other.prime != self.prime:
            raise TypeError(" > error; primes don't match") 
        return self.num < other.num 
    
    def __neg__(self):
        return self.__class__((self.num*1)%(self.prime), self.prime)