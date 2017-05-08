import queue as q

# read in file and load data into 2D array
fileName = input("Enter file name with encoded maze (include extension): ")
with open(fileName) as f:
    mazeLines = f.readlines()
mazeLines = [i.strip() for i in mazeLines]
maze = []
for line in mazeLines:
    row = []
    for ch in line:
        row.append(int(ch))
    maze.append(row)
mazeRowsCount = len(maze)
mazeColsCount = len(maze[0])

# get the open spaces from the maze and create 2-tuples representing their locations
mazeNodes = []
for i in range(len(maze)):
    for j in range(len(maze[i])):
        if maze[i][j] == 0:
            mazeNodes.append((i, j))

# assume last row has only one entrance, so its position is the last in mazeNodes
mazeEntrance = mazeNodes[len(mazeNodes)-1]

# create an adjacency list to represent edges between nodes
mazeAdjList = {}
for node in mazeNodes:
    mazeAdjList[node] = []
    i,j = node[0],node[1]
    if (i+1,j) in mazeNodes:
        mazeAdjList[node].append((i+1,j))
    if (i-1,j) in mazeNodes:
        mazeAdjList[node].append((i-1,j))
    if (i,j+1) in mazeNodes:
        mazeAdjList[node].append((i,j+1))
    if (i,j-1) in mazeNodes:
        mazeAdjList[node].append((i,j-1))

# define MazeGraph class with navigate method
class MazeGraph(object):
    def __init__(self, adjList, entranceLocation, numRows, numCols):
        self.adjList = adjList
        self.entranceLocation = entranceLocation
        self.numRows = numRows
        self.numCols = numCols

    def isAtGoal(self, node):
        return node[0] == 0 or node[1] == 0 or node[1] == self.numCols-1

    def heuristic(self, node):
        row,col = node[0],node[1]
        minToNorthSide = row
        minToEastOrWestSide = min(col, self.numCols-col-1)
        return min(minToNorthSide, minToEastOrWestSide)

    def navigate(self):
        return self.aStarSearch()

    def aStarSearch(self):
        startNode = self.entranceLocation
        explored = []
        frontierQ = q.PriorityQueue() # ordered by f-hat cost
        frontierQ.put((0, startNode))
        parentMap = {} # to trace back path
        gMap = {} # g-hat costs
        gMap[startNode] = 0
        while not frontierQ.empty():
            current = frontierQ.get()[1] # dequeue to get lowest cost node
            explored.append(current)
            if self.isAtGoal(current): # return the path
                path = [current]
                while current in parentMap.keys():
                    current = parentMap[current]
                    path.append(current)
                return list(reversed(path))
            for v in self.adjList[current]:
                if v in explored: continue
                nextG = gMap[current] + 1
                frontierQNodes = [item[1] for item in frontierQ.queue]
                if v not in frontierQNodes:
                    fHat = nextG + self.heuristic(v)
                    frontierQ.put((fHat, v))
                elif nextG >= gMap[v]: continue

                parentMap[v] = current
                gMap[v] = nextG

        return False

# create the mazeGraph, navigate the maze, and save the result
mazeGraph = MazeGraph(mazeAdjList, mazeEntrance, mazeRowsCount, mazeColsCount)
result = mazeGraph.navigate()

# with the result, print the instructions R uses to navigate the maze
print()
if result != False:
    print("R uses the SHORTEST resulting path to find an exit:")
    print(result)
    print()
    print("R starts at {0} facing North".format(mazeEntrance))
    currentDirection = "North"
    a,b = 0,1 # indices to compare adjacent nodes in result path
    while b < len(result):
        aNode,bNode = result[a],result[b]
        if aNode[0] == bNode[0]: # moving East/West
            direction = aNode[1] - bNode[1]
            if direction == 1:
                if currentDirection != "West":
                    currentDirection = "West"
                    print("R rotates West")
            if direction == -1:
                if currentDirection != "East":
                    currentDirection = "East"
                    print("R rotates East")
        if aNode[1] == bNode[1]: # moving North/South
            direction = aNode[0] - bNode[0]
            if direction == 1:
                if currentDirection != "North":
                    currentDirection = "North"
                    print("R rotates North")
            if direction == -1:
                if currentDirection != "South":
                    currentDirection = "South"
                    print("R rotates South")
        print("R steps to {0}".format(result[b]))
        a = a + 1
        b = b + 1
    print("R has reached the exit !!!")
else:
    print("R could not find an exit to the given maze.")
