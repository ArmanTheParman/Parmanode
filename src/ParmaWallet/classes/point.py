from classes.FieldElement import *

class Point:
    
    def __init__(self, x, y, a, b):
        self.x = x
        self.y = y
        self.a = a
        self.b = b

        if self.x is None and self.y is None:
            return
        if self.x is None and self.y is not None:
            raise ValueError ("Can't have a point where only x is None and y isn't None.")
        if self.y is None and self.x is not None:
            raise ValueError ("Can't have a point where only y is None and x isn't None.")

        try: 
            if self.y**2 != self.x**3 + (self.a * self.x) + self.b:
                print('({},{}) is not on the curve'.format(self.x,self.y))
                raise ValueError('({},{}) is not on the curve'.format(self.x,self.y))
        except:
            input("Hit <enter> to continue")
    
        if not isinstance(self.x, FieldElement):
            raise TypeError("x is not a Field Element")
        if not isinstance(self.y, FieldElement):
            raise TypeError("y is not a Field Element")
        if not isinstance(self.a, FieldElement):
            raise TypeError("a is not a Field Element")
        if not isinstance(self.b, FieldElement):
            raise TypeError("b is not a Field Element")

    def __repr__(self):
        return "Object is a point: x={}, y={}, a={}, b={}".format(self.x, self.y, self.a, self.b)

    def __eq__(self, other):
            return self.x == other.x and self.y == other.y and self.a == other.a and self.b == other.b
    
    def __add__(self, other):
        
        if self.a != other.a or self.b != other.b:
            raise TypeError('Pointer {}, {} are not on the same curve'.format(self, other))

        if self.x is None:
            return other

        if other.x is None:
            return self

        # Two points make a verticle line - returns None point.
        if self.x == other.x and self.y != other.y:
            return self.__class__(None, None, self.a, self.b)

        # Two points make a non-verticle line 
        # y3 = s(x1 -x3) -y1
        # x3 = s^2 - x1 - x2
        if self.x != other.x:
            slope = (other.y - self.y)/(other.x - self.x)
            x =  (slope * slope) - self.x - other.x 
            y = slope * (self.x - x) - self.y
            return self.__class__(x, -y, self.a, self.b)

        # Two points are the same, need to add. Need tangent.
        # Slope = (3x1^2 + a)/(2y1) 
        # x= s^2 - 2x1
        # y = s(x1-x3)-y1

        if self.x == other.x and self.y == other.y:
            slope1 = (3*(self.x*self.x) + self.a)
            slope2 = (2*self.y) 
            slope = slope1/slope2
            x3 = (slope * slope) - 2*(self.x)
            y3 = slope*(self.x - x3) - self.y
            return self.__class__(x3, -y3, self.a, self.b)

       # if the two points are the same, and are sitting on the x-axis, then return infinity 

        if self == other and self.y == 0 * self.x:
            return self.__class__(None, None, self.a, self.b)
    
    def __OLD_rmul__(self, other):
        if isinstance(other, int):
            if other == 0:
                print('returning other, as integer = 0')
                return self.__class__(None, None, self.a, self.b)

            new=self.__class__(self.x, self.y, self.a, self.b)

            for i in range(other):
                if i == 0:
                    continue
                new = new + self
                
            return new

    def __rmul__(self, coefficient):
        coef = coefficient
        current = self
        result = self.__class__(None, None, self.a, self.b)
        while coef:                        # Eventually, all 1 bits from coeff will be removed
            if coef & 1:                   # 1111 & 0001 becomes 0001, and True. Basically checking right digit of coef is 1
                result += current          # This adds the current growing number to the result (only when there's a 1 on the right)
            current += current             # this doubles, which is the same as adding a zero to the right
            coef >>= 1                     # removes the right digit
                                            
                                           # The pattern is:
                                           #     There are two numbers. One is growing with each loop (current), and the other
                                           #     is the answer (result). Only when there is a 1, the current number is added
                                           #     to the answer.
        return result
            
    
    #end of def _init__
    
    