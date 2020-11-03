# [8*8+5:-1]:

threshold = 190

# raw_data = bytearray() 
with open(filename, 'rb') as f:
    data = f.read()

for i in range(ysize):
    for j in range(xsize):
        if data[nchannels*(-xsize*ysize + (i*xsize + j))] < threshold:
            print("1",end="")
        else:
            print("0",end="")
    print()

