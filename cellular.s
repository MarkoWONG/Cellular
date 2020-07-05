########################################################################
# COMP1521 20T2 --- assignment 1: a cellular automaton renderer
#
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

	# LIST OF THE REGISTERS USED IN `main', AND THE PURPOSES THEY ARE ARE USED FOR
	# $t0 = address for the first element in the array
	# $t1 = 
	# $t2 =
	# $t3 = 
	# $t4 = 1 | alive
	# $t5 = the number '2' then middle element address for the 1st row
	# $t6 = floor($s0 / 2) | world_size / 2 (Whole Number)
	# $t7 = $s0 mod 2 | World_size / 2 (MOD 2)

	# $s0 = int world_size 
	# $s1 = int rule 
	# $s2 = int n_generations 
	# $s3 = int reverse

	# YOU SHOULD ALSO NOTE WHICH REGISTERS DO NOT HAVE THEIR
	# ORIGINAL VALUE WHEN `run_generation' FINISHES
	#

main:
	#
	# REPLACE THIS COMMENT WITH YOUR CODE FOR `main'.
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

    	bge	$s1, MIN_RULE, rule_not_to_small	#if (rule >= MIN_RULE) goto rule_not_to_small; 
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
	move 	$s2, $v0				# int n_generations = %d, n_generations;

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
	neg 	$s2, $s2				# n_generations = -n_generations;

positive_gen:

    #the first generation always has a only single cell which is alive
    #this cell is in the middle of the world	
	li	$t5, 2				# $t5 = 2
	div	$s0, $t5			# $s0 / 2
	mflo	$t6				# $t6 = floor($s0 / 2) | world_size / 2 (Whole Number)
	mfhi	$t7				# $t7 = $s0 mod 2 | World_size / 2 (MOD 2)
	beq	$t7, 0, even			# if $7 == 0 then even
	add 	$t6, $t6, 1
even:
	li 	$t4, 1				# $t4 = 1 | alive

	#cells[0][world_size / 2] = 1;
	mul 	$t6, $t6, 4			# assuming there is 4 bytes per cell
    	la 	$t0, cells     			# load up the first address for the element in the array
    	add 	$t5, $t6, $t0   		# $t4 will be the middle element address
    	sw 	$t4, ($t5)       		# make the middle cell '1' aka alive
	
	li 	$t1, 1				# int g = 1;

loop_run_generations:
	bgt	$t1, $s2, end_run_generation	# if (g > n_generations) goto end_run_generation

	# function call: run_generation(world_size, g, rule);
	sub  	$sp, $sp, 4   			# move stack pointer down to make room
    	sw   	$ra, 0($sp)    			# save $ra on $stack

    	jal  	run_generation			# set $ra to following address

    	lw   	$ra, 0($sp)    			# recover $ra from $stack
    	add  	$sp, $sp, 4    			# move stack pointer back to what it was

    	li   	$v0, 0         			# return 0 from function main
    	jr   	$ra            			#

	add 	$t1, $t1, 1;
	b	loop_run_generations		# goto loop_run_generations
end_run_generation:

	beq	$s3, 0, not_reverse		# if (reverse == 0) goto not_reverse;
	move 	$t1, $s2 			# int g = n_generations;

loop_reverse_print_generation:
	blt	$t1, 0, end_loop_print_generation	# if (g < 0) goto end_loop_print_generation;

	# function call: print_generation(world_size, g);
	sub  	$sp, $sp, 4    			# move stack pointer down to make room
    	sw   	$ra, 0($sp)    			# save $ra on $stack

    	jal  	print_generation		# set $ra to following address

    	lw   	$ra, 0($sp)    			# recover $ra from $stack
    	add  	$sp, $sp, 4    			# move stack pointer back to what it was

    	li   	$v0, 0         			# return 0 from function main
    	jr   	$ra            			#

	sub	$t1, $t1, 1			# g--;
	b	loop_reverse_print_generation	# goto loop_reverse_print_generation;

not_reverse:

	li 	$t1, 0				# int g = 0;

loop_print_generation:
	ble	$t1, $s2, end_loop_print_generation	# if (g <= n_generations) goto end_loop_print_generation;

	# function call: print_generation(world_size, g);
	sub  	$sp, $sp, 4    			# move stack pointer down to make room
    	sw   	$ra, 0($sp)    			# save $ra on $stack

    	jal  	print_generation		# set $ra to following address

    	lw   	$ra, 0($sp)    			# recover $ra from $stack
    	add  	$sp, $sp, 4    			# move stack pointer back to what it was

    	li   	$v0, 0         			# return 0 from function main
    	jr   	$ra            			#

	add	$t1, $t1, 1			# g++;
	b	loop_print_generation		# goto loop_print_generation:

end_loop_print_generation:


	
	# replace the syscall below with
	#
	li	$v0, 0
	jr	$ra
	#
	# if your code for `main' preserves $ra by saving it on the
	# stack, and restoring it after calling `print_world' and
	# `run_generation'.  [ there are style marks for this ]

	#li	$v0, 10
	#syscall

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

	jr	$ra				# return from function run_generation


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

	jr	$ra              		# return from function print_generation
