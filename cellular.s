# COMP1521 20T2 --- assignment 1: a cellular automaton renderer
# Written by Marko Wong (z5309371) 04/July/2020.


# Maximum and minimum values for the 3 parameters.

MIN_WORLD_SIZE	=    1
MAX_WORLD_SIZE	=  128
MIN_GENERATIONS	= -256
MAX_GENERATIONS	=  256
MIN_RULE	=    0
MAX_RULE	=  255

# Characters used to print alive/dead cells.

ALIVE_CHAR	= '#'
DEAD_CHAR	= '.'

# Maximum number of bytes needs to store all generations of cells.

MAX_CELLS_BYTES	= ((MAX_GENERATIONS + 1) * MAX_WORLD_SIZE) * 4

	.data

# `cells' is used to store successive generations.  Each byte will be 1
# if the cell is alive in that generation, and 0 otherwise.

cells:	.space MAX_CELLS_BYTES


# Some strings you'll need to use:

prompt_world_size:	.asciiz "Enter world size: "
error_world_size:	.asciiz "Invalid world size\n"
prompt_rule:		.asciiz "Enter rule: "
error_rule:		.asciiz "Invalid rule\n"
prompt_n_generations:	.asciiz "Enter how many generations: "
error_n_generations:	.asciiz "Invalid number of generations\n"

	.text

# ---------------------------------- Start of Main Function ---------------------------------- #

	# LIST OF THE REGISTERS USED IN `main', AND THE PURPOSES THEY ARE ARE USED FOR

	# $a1 = int world_size
	# $a2 = int g (used to track which row of the array to being modified)
	# $a3 = int rule
	
	# $t0 = address for the first element in the array
	# $t1 = NOT USED
	# $t2 = NOT USED
	# $t3 = NOT USED
	# $t4 = 1 | alive
	# $t5 = the number '2' then middle element address for the 1st row
	# $t6 = floor($s0 / 2) | world_size / 2 (Whole Number)
	# $t7 = NOT USED
	# $t8 = NOT USED
	# $t9 = NOT USED

	# $s0 = int world_size 
	# $s1 = int rule 
	# $s2 = int n_generations 
	# $s3 = int reverse
	# $s4 = int g (used to track which row of the array to being modified)
	# $s5 = NOT USED
	# $s6 = NOT USED
	# $s7 = NOT USED

	# YOU SHOULD ALSO NOTE WHICH REGISTERS DO NOT HAVE THEIR ORIGINAL VALUE WHEN `main' FINISHES
	# None as the original value is defined in the main function.

main:

	la      $a0, prompt_world_size		# printf("Enter world size: ");
	li 	$v0, 4
	syscall

	li 	$v0, 5   			# scanf("%d", &world_size);
	syscall
	move 	$s0, $v0			# int world_size = %d, world_size;

	bge 	$s0, MIN_WORLD_SIZE, world_size_not_to_small	# if (world_size >= MIN_WORLD_SIZE goto valid_world_size;
	la 	$a0, error_world_size		# printf("Invalid world size\n");
    	li 	$v0, 4
    	syscall

    	li	$v0, 10				# return 1;
	syscall	

world_size_not_to_small:

    	ble	$s0, MAX_WORLD_SIZE, vaild_world_size	# if (world_size <= MAX_WORLD_SIZE) goto valid_world_size;
    	la 	$a0, error_world_size		# printf("Invalid world size\n");
    	li 	$v0, 4
    	syscall

    	li	$v0, 10				# return 1;
	syscall	

vaild_world_size:

	la 	$a0, prompt_rule		# printf("Enter rule: ");
    	li 	$v0, 4
    	syscall

    	li 	$v0, 5   			# scanf("%d", &rule);
    	syscall
	move 	$s1, $v0			# int rule = %d, rule;

    	bge	$s1, MIN_RULE, rule_not_to_small	# if (rule >= MIN_RULE) goto rule_not_to_small; 
	la 	$a0, error_rule			# printf("Invalid rule\n");
    	li 	$v0, 4
    	syscall

    	li	$v0, 10				# return 1;
	syscall	

rule_not_to_small:

    	ble	$s1, MAX_RULE, valid_rule	# if (rule <= MAX_RULE) goto valid)_rule;
    	la 	$a0, error_rule			# printf("Invalid rule\n");
    	li 	$v0, 4
    	syscall

    	li	$v0, 10				#return 1;
	syscall	

valid_rule:

	la 	$a0, prompt_n_generations 	# printf("Enter how many generations: ");
    	li 	$v0, 4
    	syscall

    	li 	$v0, 5   			# scanf("%d", &n_generations);
    	syscall
	move 	$s2, $v0			# int n_generations = %d, n_generations;

    	bge	$s2, MIN_GENERATIONS, gen_not_to_small	# if (n_generations >= MIN_GENERATIONS) goto valid_gen;
	la 	$a0, error_n_generations	# printf("Invalid number of generations\n");
    	li 	$v0, 4
    	syscall

    	li	$v0, 10				# return 1;
	syscall	

gen_not_to_small:

    	ble	$s2, MAX_GENERATIONS, valid_gen	# if (n_generations <= MAX_GENERATIONS) goto valid_gen;
    	la 	$a0, error_n_generations	# printf("Invalid number of generations\n");
    	li 	$v0, 4
    	syscall

    	li	$v0, 10				# return 1;
		syscall	

valid_gen:

	li   	$a0, '\n'      			# putchar('\n');
    	li   	$v0, 11
    	syscall

	# negative generations means show the generations in reverse
	li 	$s3, 0				# int reverse = 0;
	bge	$s2, 0, positive_gen		# if (n_generations >= 0) goto positive_gen;
	li 	$s3, 1				# reverse = 1;
	neg 	$s2, $s2			# n_generations = -n_generations;

positive_gen:

    	# the first generation always has a only single cell which is alive this cell is in the middle of the world	
	li	$t5, 2				# $t5 = 2
	div	$s0, $t5			# $s0 / 2
	mflo	$t6				# $t6 = floor($s0 / 2) | world_size / 2 (Whole Number)

	li 	$t4, 1				# $t4 = 1 | alive

	#cells[0][world_size / 2] = 1;
	mul 	$t6, $t6, 4			# assuming there is 4 bytes per cell
    	la 	$t0, cells     			# load up the first address for the element in the array
    	add 	$t5, $t6, $t0   		# $t5 will be the middle element address
    	sw 	$t4, ($t5)       		# make the middle cell '1' aka alive
	
	li 	$s4, 1				# int g = 1;

loop_run_generations:
	bgt	$s4, $s2, end_loop_run_generation	# if (g > n_generations) goto end_run_generation

	# function call: run_generation(world_size, g, rule);
	move	$a1, $s0			# copy $s0 into $a1 because passing agruments need to be in $a registers
	move 	$a2, $s4			# copy $s4 into $a2 because passing agruments need to be in $a registers
	move	$a3, $s1			# copy $s1 into $a3 because passing agruments need to be in $a registers

	sub  	$sp, $sp, 4   			# move stack pointer down to make room
    	sw   	$ra, 0($sp)    			# save $ra on $stack

    	jal  	run_generation			# set $ra to following address

    	lw   	$ra, 0($sp)    			# recover $ra from $stack
    	add  	$sp, $sp, 4    			# move stack pointer back to what it was

	add 	$s4, $s4, 1;
	b	loop_run_generations		# goto loop_run_generations
end_loop_run_generation:

	beq	$s3, 0, not_reverse		# if (reverse == 0) goto not_reverse;
	move 	$s4, $s2 			# int g = n_generations;

loop_reverse_print_generation:
	blt	$s4, 0, end_loop_print_generation	# if (g < 0) goto end_loop_print_generation;

	# function call: print_generation(world_size, g);
	move	$a1, $s0			# copy $s0 into $a1 because passing agruments need to be in $a registers
	move 	$a2, $s4			# copy $s4 into $a2 because passing agruments need to be in $a registers

	sub  	$sp, $sp, 4    			# move stack pointer down to make room
    	sw   	$ra, 0($sp)    			# save $ra on $stack

    	jal  	print_generation		# set $ra to following address

    	lw   	$ra, 0($sp)    			# recover $ra from $stack
    	add  	$sp, $sp, 4    			# move stack pointer back to what it was

	sub	$s4, $s4, 1			# g--;
	b	loop_reverse_print_generation	# goto loop_reverse_print_generation;

not_reverse:

	li 	$s4, 0				# int g = 0;

loop_print_generation:

	move	$a1, $s0			# copy $s0 into $a1 because passing agruments need to be in $a registers
	move 	$a2, $s4			# copy $s4 into $a2 because passing agruments need to be in $a registers

	bgt	$s4, $s2, end_loop_print_generation	# if (g > n_generations) goto end_loop_print_generation;

	# function call: print_generation(world_size, g);
	sub  	$sp, $sp, 4    			# move stack pointer down to make room
    	sw   	$ra, 0($sp)    			# save $ra on $stack

    	jal  	print_generation		# set $ra to following address

    	lw   	$ra, 0($sp)    			# recover $ra from $stack
    	add  	$sp, $sp, 4    			# move stack pointer back to what it was

	add	$s4, $s4, 1			# g++;
	b	loop_print_generation		# goto loop_print_generation:

end_loop_print_generation:

	li	$v0, 0
	jr	$ra

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ End of Main Function ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #

# --------------------------------- Run Generation Function --------------------------------- #

	# Given `world_size', `which_generation', and `rule', calculate
	# a new generation according to `rule' and store it in `cells'.

	# Note that '->' means it transforms into something else.
	# A LIST OF THE REGISTERS USED IN `run_generation', AND THE PURPOSES THEY ARE USED FOR

	# $a1 = int world_size
	# $a2 = int g (used to track which row of the array to being modified)
	# $a3 = int rule

	# $t0 = int x (used to track which column of the array to being modified)
	# $t1 = address of the first element in the array 
	# $t2 = x + 1 					-> 	value in the address of centre -> centre << 1
	# $t3 = value in the address of right
	# $t4 = int y = world_size - 1 			-> 	int state
	# $t5 = which_generation - 1 | aka g - 1 	-> 	int bit
	# $t6 = row Number				-> 	particular element
	# $t7 = x - 1 					->	int set
	# $t8 = the value in the address of left	->  	pointing at the address of new element
	# $t9 = 1 or 0

	# $s0 = int world_size 
	# $s1 = int rule 
	# $s2 = int n_generations 
	# $s3 = int reverse
	# $s4 = int g (used to track which row of the array to being modified)
	# $s5 =	int left
	# $s6 =	int centre
	# $s7 = int right
	
	# REGISTERS THAT DO NOT HAVE THEIR ORIGINAL VALUE WHEN `run_generation' FINISHES
	# All $t registers as they will all be resued in other functions.

run_generation:
	move 	$s0, $a1			# unpacking the agument of world_size into register $s0
	move	$s4, $a2			# unpacking the agument of g into register $s4
	move	$s1, $a3			# unpacking the agument of rule into register $s1
	li 	$t0, 0				# int x = 0;

loop_run_gen:
	bge	$t0, $s0, end_loop_run_gen	# if (x >= world_size) goto end_loop_run_gen;

	li	$s5, 0				# int left = 0;
	sub 	$t5, $s4, 1			# which_generation - 1
	la	$t1, cells			# load up the first address for the element in the array
	ble	$t0, 0, first_time		# if (x <= 0) goto first_time;

	# left = cells[which_generation - 1][x - 1];
	sub	$t7, $t0, 1			# x - 1
	mul	$t6, $t5, $s0			# row_number = which_generation - 1 * world_size
	add	$t6, $t6, $t7			# row_number + (x - 1) = particular element
	mul	$t6, $t6, 4			# assuming there is 4 bytes per cell
	add	$s5, $t6, $t1			# $s5 is pointing at that particular element aka left
	b	not_first_time			# branch to not_first_time

first_time:
	add	$s5, $s5, $t1			# making $s5 an address 

not_first_time:

	# int centre = cells[which_generation - 1][x];
	mul	$t6, $t5, $s0			# row_number = which_generation - 1 * world_size 
	add	$t6, $t6, $t0			# row_number + x = particular element
	mul	$t6, $t6, 4			# assuming there is 4 bytes per cell
	add	$s6, $t6, $t1			# $s6 is pointing at that particular element aka centre

	li	$s7, 0				# int right = 0;
	sub	$t4, $s0, 1			# int y = world_size - 1;
	bge	$t0, $t4, end_of_row		# if (x >= y) goto end_of_row;

	# right = cells[which_generation - 1][x + 1];
	add	$t2, $t0, 1			# x + 1
	mul	$t6, $t5, $s0			# row_number = which_generation - 1 * world_size 
	add	$t6, $t6, $t2			# row_number + (x + 1) = particular element
	mul	$t6, $t6, 4			# assuming there is 4 bytes per cell
	add	$s7, $t6, $t1			# $s7 is pointing at that particular element aka right
	b	not_end_of_row			# branch to not_end_of_row

end_of_row:
	add	$s7, $s7, $t1			# making $s7 an address 

not_end_of_row:

	# Convert the left, centre, and right states into one value.
	lw	$t8, ($s5)			# $t8 = the value in the address of left
	sll	$t8, $t8, 2			# left << 2	

	lw	$t2, ($s6)			# $t2 = the value in the address of centre
	sll	$t2, $t2, 1			# centre << 1

	lw	$t3, ($s7)			# $t3 = the value in the address of right

	or 	$t4, $t8, $t2			# int state = left << 2 | centre << 1 | right << 0;
	or 	$t4, $t4, $t3

	li 	$t5, 1				# int bit = 1
	sllv	$t5, $t5, $t4			# int bit = 1 << state
	and	$t7, $s1, $t5			# int set = rule & bit

	beq	$t7, 0, dead			# if (set == 0) goto dead
	# cells[which_generation][x] = 1
	mul	$t6, $s4, $s0			# row_number = which_generation * world_size 
	add	$t6, $t6, $t0			# row_number + x = particular element
	mul	$t6, $t6, 4			# assuming there is 4 bytes per element
	add	$t8, $t6, $t1			# $t8 is pointing at new element
	li 	$t9, 1				# $t9 = 1
	sw	$t9, ($t8)			# cells[which_generation][x] = 1

	b	cell_determined			# branch to cell_determined
dead:
	# cells[which_generation][x] = 0
	mul	$t6, $s4, $s0			# row_number = which_generation * world_size
	add	$t6, $t6, $t0			# row_number + x = particular element
	mul	$t6, $t6, 4			# assuming there is 4 bytes per element
	add	$t8, $t6, $t1			# $t8 is pointing at that particular element aka centre
	li 	$t9, 0				# $t9 = 0
	sw	$t9, ($t8)			# cells[which_generation][x] = 0

cell_determined:
	
	add	$t0, $t0, 1			# x++;
	b	loop_run_gen
	
end_loop_run_gen:

	# Restoring $s registers to orginal value.
	li	$s5, 0				# Restoring $s5 registers to orginal value.
	li	$s6, 0				# Restoring $s6 registers to orginal value.
	li	$s7, 0				# Restoring $s7 registers to orginal value.

	jr	$ra				# return from function run_generation
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ End of Run Generation Function ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #

# -------------------------------- Print Generation Function -------------------------------- #

	# Given `world_size', and `which_generation', print out the specified generation.

	# LIST OF THE REGISTERS USED IN `print_generation', AND WHAT THEY ARE ARE USED FOR

	# $a1 = int world_size 
	# $a2 = int g 

	# $t0 = int x 
	# $t1 = the address of the first element in the array
	# $t2 = address of cells[which_generation][x]
	# $t3 = the value of cells[which_generation][x]
	# $t4 = NOT USED
	# $t5 = NOT USED
	# $t6 = row Number-> particular element
	# $t7 = NOT USED
	# $t8 = NOT USED
	# $t9 = NOT USED

	# $s0 = int world_size 
	# $s1 = NOT USED
	# $s2 = NOT USED
	# $s3 = NOT USED
	# $s4 = int g
	# $s5 =	NOT USED
	# $s6 =	NOT USED
	# $s7 = NOT USED

	# REGISTERS THAT DO NOT HAVE THEIR ORIGINAL VALUE WHEN `print_generation' FINISHES
	# All $t registers used in this function, as they will all be resued in other functions.

print_generation:
	move 	$s0, $a1			# unpacking the agument of world_size into register $s0
	move	$s4, $a2			# unpacking the agument of g into register $s4

	move 	$a0, $s4       			# load which_generation into $a0
    	li 	$v0, 1           		# printf("%d", which_generation);
    	syscall
	
	li   	$a0, '\t'      			# putchar('\t');
	li   	$v0, 11
    	syscall

	li	$t0, 0				# int x = 0;
print_loop:
	la	$t1, cells			# load up the first address for the element in the array
	bge	$t0, $s0, end_print_loop	# if (x >= world_size) goto end_print_loop
	# cells[which_generation][x]
	mul	$t6, $s4, $s0			# row_number = which_generation * world_size
	add	$t6, $t6, $t0			# row_number + x = particular element
	mul	$t6, $t6, 4			# assuming there is 4 bytes per element
	add	$t2, $t6, $t1			# $t2 is pointing at cells[which_generation][x]
	lw	$t3, ($t2)			# $t3 is the value of cells[which_generation][x]
	beq	$t3, 0, dead_cell		# if (cells[which_generation][x] == 0) goto dead_cell;

	li   	$a0, ALIVE_CHAR      		# putchar(ALIVE_CHAR);
	li   	$v0, 11
    	syscall
	b	cell_printed			# branch to cell_printed
	
dead_cell:

	li   	$a0, DEAD_CHAR      		# putchar(DEAD_CHAR);
	li   	$v0, 11
    	syscall

cell_printed:

	add	$t0, $t0, 1			# x++;
	b	print_loop			# branch to print_loop

end_print_loop:
	li   	$a0, '\n'      			# putchar('\n');
	li   	$v0, 11
    	syscall

	jr	$ra              		# return from function print_generation

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ End of Print Generation Function ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #