# Min-Heap and Priority Queue

def swap(A, i, j):
    tmp = A[i]
    A[i] = A[j]
    A[j] = tmp

def less(x, y):
	return x < y

def less_key(x, y):
	return x.key < y.key

def left(i):
	return 2 * i + 1

def right(i):
	return 2 * (i + 1)

def parent(i):
	return int((i-1) / 2)

class Heap:
	def __init__(self, data, less=less):
		self.data = data #an array
		self.less = less #comparison function
		self.build_min_heap() #rearrange self.data into min-heap

	def __repr__(self):
		return repr(self.data)

	def minimum(self):
		return self.data[0]

	#helper function for insert
	def decrease_key(self, i, key):
		self.data[i] = key
		while ((i > 0) and (self.less(self.data[i], self.data[parent(i)]))):
			swap(self.data, i, parent(i))
			i = parent(i)

	def insert(self, obj):
		self.data.append(None)
		self.decrease_key(len(self.data)-1, obj)

	def extract_min(self):
		result = self.data[0]
		self.data[0] = self.data[len(self.data)-1]
		self.data.pop()
		self.min_heapify(0)
		return result

	def min_heapify(self, i):
		l = left(i)
		r = right(i)
		s = i
		if (l < len(self.data)):
			if (self.less(self.data[l], self.data[s])):
				s = l
		if (r < len(self.data)):
			if (self.less(self.data[r], self.data[s])):
				s = r
		if (s != i):
			swap(self.data, i, s)
			self.min_heapify(s)

	def build_min_heap(self):
		i = int((len(self.data)-1)/2)
		while (i >= 0):
			self.min_heapify(i)
			i = i - 1

class PriorityQueue:
	def __init__(self, less=less_key):
		self.heap = Heap([], less)

	def __repr__(self):
		return repr(self.heap)

	def push(self, obj):
		self.heap.insert(obj)

	def pop(self):
		return self.heap.extract_min()

#========================================
#TESTING

if __name__ == "__main__":
	h = Heap([2, 3, 1, 5, 4, 7], less)
	assert(h.data == [1, 3, 2, 5, 4, 7])
	assert(h.minimum() == 1)
	assert(h.data == [1, 3, 2, 5, 4, 7])
	assert(h.extract_min() == 1)
	assert(h.data == [2, 3, 7, 5, 4])
	h.insert(6)
	assert(h.data == [2, 3, 6, 5, 4, 7])
