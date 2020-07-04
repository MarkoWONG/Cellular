########################################################################
# COMP1521 20T2 --- assignment 1: a cellular automaton renderer
#
# Written by <<YOU>>, July 2020.


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

MAX_CELLS_BYTES	= (MAX_GENERATIONS + 1) * MAX_WORLD_SIZE

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

	#
	# LIST OF THE REGISTERS USED IN `main', AND THE PURPOSES THEY ARE ARE USED FOR
	#
	# $s0 = int world_size 
	# $s1 = int rule 
	# $s2 = int n_generations 

	# YOU SHOULD ALSO NOTE WHICH REGISTERS DO NOT HAVE THEIR
	# ORIGINAL VALUE WHEN `run_generation' FINISHES
	#

main:
	#
	# REPLACE THIS COMMENT WITH YOUR CODE FOR `main'.
	la $a0, prompt_world_size     #printf("Enter world size: ");
    li $v0, 4
    syscall

    li $v0, 5   # scanf("%d", &world_size);
    syscall
	move $s0, $v0	#int world_size = %d, world_size;
	move $t0, $v0

	bge $s0, MIN_WORLD_SIZE, world_size_not_to_small	#if (world_size >= MIN_WORLD_SIZE goto valid_world_size;
	    la $a0, error_world_size	#printf("Invalid world size\n");
    	li $v0, 4
    	syscall

    	li	$v0, 10		#return 1;
		syscall	

	world_size_not_to_small:
		
    ble	$s0, MAX_WORLD_SIZE, valid_world_size	#if (world_size <= MAX_WORLD_SIZE) goto valid_world_size;
    	la $a0, error_world_size	#printf("Invalid world size\n");
    	li $v0, 4
    	syscall

    	li	$v0, 10		#return 1;
		syscall	

vaild_world_size:

	la $a0, prompt_rule		#printf("Enter rule: ");
    li $v0, 4
    syscall

    li $v0, 5   # scanf("%d", &rule);
    syscall
	move $s1, $v0	#int rule = %d, rule;

    bge	$s1, MIN_RULE, rule_not_to_small	#if (rule >= MIN_RULE) goto rule_not_to_small; 
		la $a0, error_rule	#printf("Invalid rule\n");
    	li $v0, 4
    	syscall

    	li	$v0, 10		#return 1;
		syscall	

	rule_not_to_small:

    ble	$s1, MAX_RULE, valid_rule	#if (rule <= MAX_RULE) goto valid)_rule;
    	la $a0, error_rule	#printf("Invalid rule\n");
    	li $v0, 4
    	syscall

    	li	$v0, 10		#return 1;
		syscall	

valid_rule:

	la $a0, prompt_n_generations 	#printf("Enter how many generations: ");
    li $v0, 4
    syscall

    li $v0, 5   #scanf("%d", &n_generations);
    syscall
	move $s2, $v0	#int n_generations = %d, n_generations;

    bge	$s2, MIN_GENERATIONS, gen_not_to_small		#if (n_generations >= MIN_GENERATIONS) goto valid_gen;
	    la $a0, error_n_generations	#printf("Invalid number of generations\n");
    	li $v0, 4
    	syscall

    	li	$v0, 10		#return 1;
		syscall	

	gen_not_to_small:

    ble	$s2, MAX_GENERATIONS, valid_gen		#if (n_generations <= MAX_GENERATIONS) goto valid_gen;
    	la $a0, error_n_generations	#printf("Invalid number of generations\n");
    	li $v0, 4
    	syscall

    	li	$v0, 10		#return 1;
		syscall	

valid_gen:

	li   $a0, '\n'      #putchar('\n');
    li   $v0, 11
    syscall


	# replace the syscall below with
	#
	# li	$v0, 0
	# jr	$ra
	#
	# if your code for `main' preserves $ra by saving it on the
	# stack, and restoring it after calling `print_world' and
	# `run_generation'.  [ there are style marks for this ]

	li	$v0, 10
	syscall



	#
	# Given `world_size', `which_generation', and `rule', calculate
	# a new generation according to `rule' and store it in `cells'.
	#

	#
	# REPLACE THIS COMMENT WITH A LIST OF THE REGISTERS USED IN
	# `run_generation', AND THE PURPOSES THEY ARE ARE USED FOR
	#
	# YOU SHOULD ALSO NOTE WHICH REGISTERS DO NOT HAVE THEIR
	# ORIGINAL VALUE WHEN `run_generation' FINISHES
	#

run_generation:

	#
	# REPLACE THIS COMMENT WITH YOUR CODE FOR `run_generation'.
	#

	jr	$ra


	#
	# Given `world_size', and `which_generation', print out the
	# specified generation.
	#

	#
	# REPLACE THIS COMMENT WITH A LIST OF THE REGISTERS USED IN
	# `print_generation', AND THE PURPOSES THEY ARE ARE USED FOR
	#
	# YOU SHOULD ALSO NOTE WHICH REGISTERS DO NOT HAVE THEIR
	# ORIGINAL VALUE WHEN `print_generation' FINISHES
	#

print_generation:

	#
	# REPLACE THIS COMMENT WITH YOUR CODE FOR `print_generation'.
	#

	jr	$ra
