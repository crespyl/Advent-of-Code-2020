import random
rand = random.Random(0)
with open("bigboy.txt", "w") as f:
	n = 0
	for _ in range(100_000):
		n += 1 + rand.randint(0, 1) * 2
		f.write(str(n) + "\n")
