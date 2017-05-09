# Artificial agent that solves mazes in Python

These Python 3 scripts take in a maze encoded in a text file
(0s are open space, 1s are walls) and returns the steps a robot R
would take to reach the end of the maze. R always starts at the bottom
of the maze, and it can exit out the left, top, or right side.

In `pathfinder1.py` the agent finds any path to reach an exit,
even if it is not the shortest path. In `pathfinder2.py` the agent
uses A* search to find the shortest path. The heuristic predicts
the minimum amount of steps R needs to take to reach any exit,
and it does so by simply counting how far R is from the edges
(therefore, the closer to the center of the maze, the higher the heuristic value).

There are 4 test files. 3 of them have a reachable exit, but `bad.txt` does not,
so the agent prints a message saying R cannot find an exit.
The advantage of the A* search can be seen by comparing the outputs
between `pathfinder1.py` and `pathfinder2.py` on the `hard.txt` maze.
The `pathfinder2.py` agent takes much fewer steps to reach the exit.

This project demonstrates an understanding of pathfinding in AI,
graphs, A* search, and writing a simple heuristic.
