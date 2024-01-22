from math import sqrt, ceil, floor

def lol(time, distance):
	i = 0
	x = 0
	while i < distance:
		if i*(time-i) > distance:
			x = x + 1
		i = i+1
	return x


print(lol(49, 298) * lol(78, 1185) * lol(79, 1066) * lol(80, 1181))

#print(lol(49787980, 298118510661181))

time = 49787980    
distance  = 298118510661181

#time = 71530
#distance = 940200

y = time + sqrt((time ** 2) - 4 * distance)
x = time - sqrt((time ** 2) - 4 * distance)

#print(ceil(x/2))
#print(floor(y/2))
print(1+floor(y/2)-ceil(x/2))
