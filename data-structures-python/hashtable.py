# Hash Table

class Hashtable:
	MIN_SIZE = 64
	MIN_LOAD = 0.25
	MAX_LOAD = 1.0
	def __init__(self, d):
		self.table = [None for i in range(self.MIN_SIZE)]
		self.total = 0
		self.load = float(self.total) / float(len(self.table))
		for (k, v) in d.items():
			self.__setitem__(k, v)

	def __getitem__(self, key):
		h = hash(key) % len(self.table)
		chain = self.table[h]
		if chain:
			for slot in chain:
				if (key == slot[0]):
					return slot[1]
		else:
			raise Exception("given key is not valid: " + repr(key))

	def __setitem__(self, key, value, reset=False):
		h = hash(key) % len(self.table)
		if self.table[h]:
			self.table[h].append((key, value))
		else:
			self.table[h] = []
			self.table[h].append((key, value))
		if (not reset):
			self.update(1)

	def __delitem__(self, key):
		h = hash(key) % len(self.table)
		chain = self.table[h]
		if chain:
			chain.remove((key, self.__getitem__(key)))
			if (len(chain) == 0):
				self.table[h] = None
			self.update(-1)
		else:
			raise Exception("given key is not valid: " + repr(key))

	def keys(self):
		result = []
		for chain in self.table:
			if chain:
				for slot in chain:
					result.append(slot[0])
		return result

	def update(self, dt):
		self.total = self.total + dt
		self.load = float(self.total) / float(len(self.table))
		if (self.load >= self.MAX_LOAD):
			self.resize_table(len(self.table)*2)
		elif ((self.load <= self.MIN_LOAD) and (len(self.table) > self.MIN_SIZE)):
			self.resize_table(int(len(self.table)/2))

	def resize_table(self, new_size):
		old_table = self.table
		self.table = [None for i in range(new_size)]
		self.total = 0
		for chain in old_table:
			if chain:
				for slot in chain:
					self.__setitem__(slot[0], slot[1], True)
					self.total = self.total + 1
		self.load = float(self.total) / float(len(self.table))

#========================================
#TESTING

if __name__ == '__main__':
	h = Hashtable({})

	#inserting characters where key == value
	for char in "abcd":
		h[char] = char
	assert(len(h.table) == h.MIN_SIZE)
	assert(h.total == 4)
	for char in "abcd":
		assert(h[char] == char)

	#deleting an item and making sure total decreases by 1
	del h["c"]
	assert(len(h.table) == h.MIN_SIZE)
	assert(h.total == 3)
	h["c"] = "c"

	#inserting integers where key != value
	for i in range(h.MIN_SIZE - 4):
		h[i] = i + 4

	#also making sure the table size doubled
	assert(len(h.table) == h.MIN_SIZE*2)
	assert(h.load == 0.5)
	for i in range(h.MIN_SIZE - 4):
		assert(h[i] == i + 4)

	#testing the keys() method and deleting all items
	all_keys = h.keys()
	for k in all_keys:
		del h[k]

	#making sure the table size is still MIN_SIZE
	#even though the load factor is less than MIN_LOAD
	assert(h.total == 0)
	assert(h.load == 0.0)
	assert(len(h.table) == h.MIN_SIZE)

	#testing exceptions in getitem and delitem
	#temp = h[1]
	#del h[1]
