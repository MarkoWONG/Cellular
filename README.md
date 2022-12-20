COMP1521 20T2

Aims
to give you experience writing MIPS assembly code
to give you experience with data and control structures in MIPS
Getting Started
Create a new directory for this assignment called cellular, change to this directory, and fetch the provided code by running these commands:

mkdir cellular
cd cellular
1521 fetch cellular
This will add the following files into the directory:

cellular.c: a cellular automaton renderer
cellular.s: a stub assembly file to complete
cellular.c: A Cellular Automaton Renderer
cellular.c is an implementation of a one-dimensional, three-neighbour cellular automaton. It examines its neighbours and its value in the previous generation to derive the value for the next generation.

.	.	.	.	#	.	.	.	.
.	.	.	#	#	#	.	.	.
.	.	#	#	.	.	#	.	.
.	#	#	.	#	#	#	#	.
#	#	.	.	#	.	.	.	#
Here, we using '#' to indicate a cell that's alive; and '.' to indicate a cell that is not.

Given we examine three neighbours, there are eight states that the prior cells could be in. They are:

.	.	.
0	
.	.	#
1	
.	#	.
2	
.	#	#
3	
#	.	.
4	
#	.	#
5	
#	#	.
6	
#	#	#
7	
For each one, we decide what action to take. For example, we might choose to have the following 'rule':

.	.	.
.	
.	.	#
#	
.	#	.
#	
.	#	#
#	
#	.	.
#	
#	.	#
.	
#	#	.
.	
#	#	#
.	
We apply this rule to every cell, to determine whether the next state is alive or dead; and this forms the next generation. If we print these generations, one after the other, we can get some interesting patterns.

The description of the rule above — by example, showing each case and how it should be handled — is inefficient. We can abbreviate this rule by reading it in binary, considering live cells as 1's and dead cells as 0s; and if we consider the prior states to be a binary value too — the above rule could be 0b00011110, or 30.

To use that rule, we would mix together the previous states we're interested in — left, middle, and right — which tells us which bit of the rule value gives our next state.

The size of a generation, the rule number, and the number of generations are supplied on standard input. For example:

./cellular
Enter world size: 60
Enter rule: 30
Enter how many generations: 10

0   ..............................#.............................
1   .............................###............................
2   ............................##..#...........................
3   ...........................##.####..........................
4   ..........................##..#...#.........................
5   .........................##.####.###........................
6   ........................##..#....#..#.......................
7   .......................##.####..######......................
8   ......................##..#...###.....#.....................
9   .....................##.####.##..#...###....................
10  ....................##..#....#.####.##..#...................
If generations is a negative number, the generations should be printed in reverse.

./cellular
Enter world size: 60
Enter rule: 30
Enter how many generations: -10

10  ....................##..#....#.####.##..#...................
9   .....................##.####.##..#...###....................
8   ......................##..#...###.....#.....................
7   .......................##.####..######......................
6   ........................##..#....#..#.......................
5   .........................##.####.###........................
4   ..........................##..#...#.........................
3   ...........................##.####..........................
2   ............................##..#...........................
1   .............................###............................
0   ..............................#.............................
cellular.s: The Assignment
Your task in this assignment is to implement cellular.s in MIPS assembler.

You have been given some assembly and helpful information in cellular.s. Read through the provided code carefully, then add MIPS assembly so it executes exactly the same as cellular.c.

1521 spim -f cellular.s
Loaded: /home/cs1521/share/spim/exceptions.s
Enter world size: 60
Enter rule: 30
Enter how many generations: 10

0   ..............................#.............................
1   .............................###............................
2   ............................##..#...........................
3   ...........................##.####..........................
4   ..........................##..#...#.........................
5   .........................##.####.###........................
6   ........................##..#....#..#.......................
7   .......................##.####..######......................
8   ......................##..#...###.....#.....................
9   .....................##.####.##..#...###....................
10  ....................##..#....#.####.##..#...................
To test your implementation, you can compile the provided C implementation, run it to collect the expected output, run your assembly implementation to collect observed output, and then compare them — for example:

dcc cellular.c -o cellular
parameters="20 15 5"
echo $parameters|./cellular|tee c.out
0   ..........#.........
1   ###########.########
2   #...........#.......
3   #.###########.######
4   #.#...........#.....
5   #.#.###########.####
echo $parameters|1521 spim -f cellular.s|sed 1d|tee mips.out
0   ..........#.........
1   ###########.########
2   #...........#.......
3   #.###########.######
4   #.#...........#.....
5   #.#.###########.####
diff -s c.out mips.out
Files c.out and mips.out are identical
Try this for different values of the parameters.
