def read_varint(s):
    '''read_varint reads a variable integer from a stream'''
    i = s.read(1)[0] # byte object returned with read, and value extraced with [0]
    if i == 0xfd:
        return little_endian_to_int(s.read(2))
    elif i == 0xfe:
        return little_endian_it_int(s.read(4))
    elif i == 0xff:
        return little_endian_to_int(s.read(8))
    else:
        #anything else is an integer
        return i

def encode_varint(i):
    '''encodes an integer as a varint'''
    if i < 0xfd:
        return bytes([i])
    elif i <0x10000:
        return b'\xfd' + int_to_little_endian(i, 2)
    elif i <0x100000000:
        return b'\xfe' + int_to_little_endian(i, 4)
    elif i <0x10000000000000000:
        return b'\xff' + int_to_little_endian(i, 8)
    else: 
        raise ValueError('integer too large: {}'.format(i))