# erase this line and type your first and last name here in a comment
# erase this line and type your Net ID here in a comment (e.g., jmsmith)
# erase this line and type your SBU ID number here in a comment (e.g., 111234567)

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

.text
memcpy:
   	#save on stack
	addi $sp, $sp, -12 #save 4 s registers on stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)

	move $s0, $a0 #destination array
	move $s1, $a1 #source array
	move $s2, $a2 #number of things to copy from the source
	bltz $s2, invalid_number_copy
	li $t0, 0 #will be used to keep track of the number of items we've copied
	memcpy_main_loop:
		lbu $t1, 0($s1) #loads  a byte from memory
		sb $t1, 0($s0) #stores the byte we loaded
		addi $s1, $s1, 1 #increment postition
		addi $s0, $s0, 1 #increment pos
		addi $t0, $t0, 1 #increment number we copied
		blt $t0, $s2, memcpy_main_loop #as long as the number we've copied is less than the number we have to copy, we keep copying
		move $v0, $s2
		j deallocate_stack_memcpy
	invalid_number_copy:
		li $v0, -1
		j deallocate_stack_memcpy
	deallocate_stack_memcpy:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		addi $sp, $sp, 12 #save 4 s registers on stack
		jr $ra
strcmp:
	addi $sp, $sp, -8 #save 4 s registers on stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	
	move $s0, $a0 #string 1
	move $s1, $a1 #string 2
	li $t3, '\0'
	check_if_strings_empty:
		lb $t0, 0($s0) #character  from string 1
		lb $t1, 0($s1) #character from string 2
		li $t4, 0 #counting purposes incase they're empty...
		
		beq $t0, $t3, string1_empty
		beq $t1, $t3, string2_empty
		
		
	strcmp_main_loop:
		lb $t0, 0($s0) #character  from string 1
		lb $t1, 0($s1) #character from string 2
		sub $t4, $t0, $t1 #subtract the two store it in t4
		addi $s0, $s0, 1
		addi $s1, $s1, 1
		beq $t0, $t3, end_of_string_length
		beq $t1, $t3, end_of_string_length
		beqz $t4, strcmp_main_loop #as long as it's zero keep going
		j end_of_string_length
	string1_empty:
		#get length of str2
		lb $t1, 0($s1) #character from string 2
		beq $t1, $t3, end_of_string_length
		addi $t4, $t4, -1 #increment length
		addi $s1, $s1, 1
		j string1_empty
	string2_empty:
		#get length of str1
		lb $t0, 0($s0) #character from string 1
		beq $t0, $t3, end_of_string_length
		addi $t4, $t4, 1 #increment length
		addi $s0, $s0, 1
		j string2_empty
	end_of_string_length:
		# t4 holds the value
		move $v0, $t4
		j deallocate_stack_strcmp
		
	deallocate_stack_strcmp:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		addi $sp, $sp, 8
		jr $ra
		
initialize_hashtable:
		move $t0, $a0 #hashtable
		move $t1, $a1 #int capacity
		move $t2, $a2 #int element size
		
		li $t5, 1
		blt $t1, $t5, invalid_input_initialize_hashtable
		blt $t2, $t5, invalid_input_initialize_hashtable
		
		sw $t1, 0($t0) #updates the capacity
		li $t3, 0
		sw $t3, 4($t0) #sets the size filed to 0
		sw $t2, 8($t0) #sets the element size to the given
		
		mul $t5, $t1, $t2 #t5 stores the value of capaitcity * element sizwe
		
		li $t6, 0
		addi $t0, $t0, 12 #get to the start of object[] elements
		main_initialize_hastable_loop: #fill elements field with zeros
			sb $t3, 0($t0) #stores 0
			addi $t0, $t0, 1
			addi $t6, $t6, 1
			blt $t6, $t5, main_initialize_hastable_loop
			
			li $v0, 0
			j finished_everything_initialize_hashtable
			
			
			
		
		
		invalid_input_initialize_hashtable:
			li $v0, -1
			j finished_everything_initialize_hashtable
		finished_everything_initialize_hashtable:
			jr $ra

hash_book:
	move $t0, $a0 #hashtable
	move $t1, $a1 #ISBN
	
	li $t2, '\0'
	li $t3, 0 #for adding purposes
	add_ISBN_loop:
		lb $t4, 0($t1) #loads a byte
		beq $t4, $t2, done_adding_ISBN
		add $t3, $t3, $t4
		addi $t1, $t1, 1 #increment the characher we grab
		j add_ISBN_loop
	done_adding_ISBN: #t3 holds the ascii value of ISBN
		lw $t5, 0($t0) #gets the capacity
		div $t3, $t5
		mfhi $v0
		jr $ra

	
get_book:
	addi $sp, $sp, -36 #save s registers on stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	
	
	move $s0, $a0 #hashtable
	move $s1, $a1 #ISBN
	lw $s2, 0($s0) #MAX capacity
	lw $s3, 4($s0) #current size
	lw $s4, 8($s0) #element size
	#quick check to see if its the book I want
	# i have s5, s6, and s7 left to work with...
	
	
	#get the expected postion GIVEN the ISBN
	jal hash_book
	move $t2, $v0 #holds the expected postion
	
	#store stuff on the stack
	addi $sp, $sp, -8
	sw $t2, 0($sp) #store the expected position							
	sw $s0, 4($sp) #store the base address of the hashtable on the stack				
	
	

	
	move $t0, $s0
	addi $t0, $t0, 12
	mul $t1, $s4, $t2 #element size * expected position
	add $t0, $t0, $t1 #gets the starting byte of the exptected ISBN
	move $s5, $t0 #we're gonna start the loop here. Go to capacity, loop back around

	
	li $s7, 0
	move $s6, $t2 #expected position
	expected_to_end_loop:
		move $a0, $s5 #string1
		move $a1, $s1 #string 2
		jal strcmp
												
		lb $t0, 0($s5) #if its empty aka = 0, then USE S7 TO DETERMINE
		bgtz $s7, found_empty_already 
		addi $s7, $s7, -1
		beqz $t0, found_empty_linear
		found_empty_already: #have to worry about counting position, s6 will track this for us
		beqz $v0, found_ISBN									
		addi $s6, $s6, 1
		add $s5, $s5, $s4 #next element
		blt $s6, $s2, expected_to_end_loop
		j beginning_to_expected_loop
	found_empty_linear:
		neg $s7, $s7
		j found_empty_already
	found_ISBN:
		move $v0, $s6
		#lw $t8, 36($sp) #load the expected position
		#sub $s6, $s6, $t8 #current pos - expected we started at
		#move $v1, $s6
		abs $v1, $s7
		
		
		j finished_looping_book
	
	beginning_to_expected_loop:
		lw $s6, 0($sp) #load the expected position							
		lw $s5, 4($sp) #load hashtable off stack							
		addi $s5, $s5, 12 #beginning of the elements
		actual_start_of_loop:
			move $a0, $s5 #string1
			move $a1, $s1 #string 2
			jal strcmp
														
			lb $t0, 0($s5) #if its empty aka = 0, then USE S7 TO DETERMINE
			bgtz $s7, found_empty_already_part2 
			addi $s7, $s7, -1
			beqz $t0, found_empty_linear_part2
			found_empty_already_part2: #have to worry about counting position, s6 will track this for us
			beqz $v0, found_ISBN_part2
			addi $s6, $s6, -1
			add $s5, $s5, $s4 #next element
			bgtz $s6, actual_start_of_loop
			j invalid_finish_book
			found_empty_linear_part2:
				neg $s7, $s7
				j found_empty_already
			found_ISBN_part2:
				lw $t8, 36($sp) #load the expected position
				sub $v0, $t8, $s6 #expected - (expected - i) yields i aka current pos
				abs $v1, $s7
				j finished_looping_book
				#move $v0, $s6
				
	finished_looping_book:
		addi $sp, $sp, 8 #deallocate the mini stack we made
		j deallocate_stack_get_book
	invalid_finish_book:
		li $v0, -1
		abs $v1, $s7
		j finished_looping_book
	deallocate_stack_get_book:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $s6, 24($sp)
		lw $s7, 28($sp)
		lw $ra, 32($sp)
		addi $sp, $sp, 36 #save s registers on stack
		jr $ra
add_book:
	addi $sp, $sp, -36 #save s registers on stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	
	
	move $s0, $a0 #hashtable books
	move $s1, $a1 #ISBN
	move $s2, $a2 #title
	move $s3, $a3 #author
	
	lb $t0, 0($s0)
	lb $t1, 4($s0)
	beq $t0, $t1, hash_table_full 
	#check if its in the table
	move $a0, $s0 #hashtable
	move $a1, $s1 #ISBN
	jal get_book
	li $t0, -1
	beq $v0, $t0, not_in_hashtable_yet
	j found_in_hashtable #else its in the hashtable
	
	
	not_in_hashtable_yet:
		move $a0, $s0 #hashtable
		move $a1, $s1 #ISBN
		jal hash_book
		move $s4, $v0 #s4 holds the expected place it should go
		#s5 will keep track of position
		move $s5, $s0
		addi $s5, $s5, 12
		lb $t2, 8($s0)
		mul $t1, $s4, $t2 #element size * expected position
		add $s5, $s5, $t1 #gets the starting byte of the exptected ISBN
		#s6 will keep track of the current position
		#li $s6, 0
		move $s6, $s4
		li $s7, 0 #keeps track of how many we've actually looked at
		check_from_expected_to_end_add_book:				
			lb $t0, 0($s5) #if its empty aka = 0, then USE S7 TO DETERMINE
			addi $s7, $s7, 1
			beqz $t0, found_empty_spot
			li $t1, -1
			beq $t0, $t1, found_empty_spot
			#else increment until we hit capacity
			addi $s6, $s6, 1
			lb $t3, 8($s0)
			add $s5, $s5, $t3 #increment by elements size
			lb $t2, 0($s0)
			blt $s6, $t2, check_from_expected_to_end_add_book
			j check_from_beginning_to_expected_add_book
	
	
	
		check_from_beginning_to_expected_add_book: #until s4
			li $s6, 0
			move $s5, $s0											
			addi $s5, $s5, 12												
			check_from_beginning_to_end_add_book_actual_loop:
			lb $t0, 0($s5) #if its empty aka = 0, then USE S7 TO DETERMINE
			addi $s7, $s7, 1
			beqz $t0, found_empty_spot
			li $t1, -1
			beq $t0, $t1, found_empty_spot
			addi $s6, $s6, 1
			lb $t3, 8($s0)
			add $s5, $s5, $t3 #increment by elements size
			blt $s6, $s4, check_from_beginning_to_end_add_book_actual_loop
			j hash_table_full

		found_empty_spot:
			lw $t9, 4($s0)
			addi $t9, $t9, 1
			sw $t9, 4($s0) #increments size by one
			li $t3, 14
			li $t2, 0
			#WRITES ISBN
			move $a0, $s5
			move $a1, $s1
			li $a2, 14
			jal memcpy
			move $v0, $s6 #where the structure is inserted
			move $v1, $s7 #how many elements we had to iterate through
			addi $s5, $s5, 14
			j write_title
			write_title:
				li $t3, 24
				li $t2, 0
				li $t4, '\0'
				
				write_title_loop:
					lb $t0, 0($s2)
					beq $t0, $t4, title_null_padding
					sb $t0, 0($s5)
					addi $s2, $s2, 1
					addi $s5, $s5, 1
					addi $t2, $t2, 1
					blt $t2, $t3, write_title_loop
					j write_author
				title_null_padding:
					sb $t0, 0($s5)
					addi $s5, $s5, 1
					addi $t2, $t2, 1
					blt $t2, $t3, title_null_padding
					j write_author
			write_author:
				sb $t4, 0($s5) #null terminate title
				addi $s5, $s5, 1
				li $t3, 24
				li $t2, 0
				li $t4, '\0'
				write_author_loop:
					lb $t0, 0($s2)
					beq $t0, $t4, author_null_padding
					sb $t0, 0($s5)
					addi $s2, $s2, 1
					addi $s5, $s5, 1
					addi $t2, $t2, 1
					blt $t2, $t3, write_author_loop
					j finished_writing_add_book
				author_null_padding:
					sb $t0, 0($s5)
					addi $s5, $s5, 1
					addi $t2, $t2, 1
					blt $t2, $t3, author_null_padding
					j finished_writing_add_book
	finished_writing_add_book:
		sb $t4, 0($s5) #null terminate author
		addi $s5, $s5, 1
		li $t0, 0
		sw $t0, 0($s5) #num times sold = 0
		j deallocate_stack_add_book
	found_in_hashtable:
		#v0 and v1 already hold the proper values
		j deallocate_stack_add_book
	hash_table_full:
		li $v0, -1
		li $v1, -1
		j deallocate_stack_add_book
	deallocate_stack_add_book:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $s6, 24($sp)
		lw $s7, 28($sp)
		lw $ra, 32($sp)
		addi $sp, $sp, 36 #save s registers on stack
		jr $ra

delete_book:
	addi $sp, $sp, -28 #save s registers on stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $ra, 24($sp)
	move $s0, $a0 #books
	move $s1, $a1 #isbn
	
	jal get_book
	bltz $v0, cannot_find_ISBN
	move $s2, $s0 #copy of books
	addi $s2, $s2, 12 
	lw $s3, 8($s0) #elements size
	li $s4, 0
	lw $s5, 0($s0) #max capacity
	find_book_loop:
		move $a0, $s2 #string 1
		move $a1, $s1 #string 2 (given)
		jal strcmp
		beqz $v0, found_book_to_delete
		addi $s4, $s4, 1
		add $s2, $s2, $s3 #increase by elements size each time
		blt $s4, $s5, find_book_loop
		j cannot_find_ISBN
	found_book_to_delete:
		move $v0, $s4
		#the next elements_size bytes must become -1. $s3
		delete_book_loop:
			li $t0, -1
			sb $t0, 0($s2)
			addi $s2, $s2, 1
			addi $s3, $s3, -1
			bgtz $s3, delete_book_loop
			j deallocate_stack_delete_book

	cannot_find_ISBN:
		li $v0, -1
		j deallocate_stack_delete_book
	
	deallocate_stack_delete_book:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $ra, 24($sp)
		addi $sp, $sp, 28 #save s registers on stack
		jr $ra
hash_booksale:
	move $t0, $a0 #hashtable
	move $t1, $a1 #ISBN
	move $t2, $a2 #customer ID
	li $t7, '\0'
	li $t5, 0 #for adding purposes
	add_ISBN_loop_booksale:
		lb $t4, 0($t1) #loads a byte
		beq $t4, $t7, done_adding_ISBN_booksale
		add $t5, $t5, $t4
		addi $t1, $t1, 1 #increment the characher we grab
		j add_ISBN_loop_booksale
	done_adding_ISBN_booksale: #t3 holds the ascii value of ISBN
		add_digit_loop:
		li $t9, 10
		div $t2, $t9
		mflo $t2 #quotient
		mfhi $t6
		add $t5, $t5, $t6
		bnez $t2, add_digit_loop
		
		#add $t5, $t5, $t2 #ISBN + customer ID
		lw $t3, 0($t0) #gets the capacity
		div $t5, $t3
		mfhi $v0
		jr $ra

	
    jr $ra

is_leap_year:
	move $t0, $a0 #year given
	li $t1, 1582
	ble $t0, $t1, before_1582
	li $t6, 0 #used to count how many years till leap year
	j check_is_leap_year_mod4
	
	check_is_leap_year_mod4:
		li $t1, 400
		li $t2, 100
		li $t3, 4
		div $t0, $t1
		mfhi $t5
		beqz $t5, is_leap_year1
		div $t0, $t2
		mfhi $t5
		beqz $t5, find_next_leap_year
		div $t0, $t3
		mfhi $t5
		beqz $t5, is_leap_year1
		j find_next_leap_year
	find_next_leap_year:	
		addi $t0, $t0, 1
		addi $t6, $t6, -1
		li $t2, 100
		div $t0, $t2
		mfhi $t5
		beqz $t5, find_next_leap_year
		li $t3, 4
		div $t0, $t3
		mfhi $t5
		bnez $t5, find_next_leap_year
		j found_leap_year
	is_leap_year1:
		li $v0, 1
		j exit_leap
	found_leap_year:
		move $v0, $t6
		j exit_leap
	before_1582:
		li $v0, 0
		j exit_leap
	exit_leap:
		jr $ra

datestring_to_num_days:
	addi $sp, $sp, -36 #save s registers on stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	
	
	move $t0, $a0 #string1 with begin date
	move $t1, $a1 #string2 with end date
	#year of string1
	li $t2, 1000
	lb $t3 0($t0)
	addi $t3, $t3, -48
	mul $t4, $t2, $t3 
	li $t5, 0
	add $t5, $t5, $t4 #t5 will store the end result of YEAR S1 (temp)
	li $t2, 100
	lb $t3 1($t0)
	addi $t3, $t3, -48
	mul $t4, $t2, $t3 
	add $t5, $t5, $t4
	li $t2, 10
	lb $t3 2($t0)
	addi $t3, $t3, -48
	mul $t4, $t2, $t3 
	add $t5, $t5, $t4
	li $t2, 1
	lb $t3 3($t0)
	addi $t3, $t3, -48
	mul $t4, $t2, $t3 
	add $t5, $t5, $t4
	move $s0, $t5 # S0 = YEAR OF STRING 1
	#month of string 1
	li $t5, 0
	li $t2, 10
	lb $t3 5($t0)
	addi $t3, $t3, -48
	mul $t4, $t2, $t3 
	add $t5, $t5, $t4
	li $t2, 1
	lb $t3 6($t0)
	addi $t3, $t3, -48
	mul $t4, $t2, $t3 
	add $t5, $t5, $t4
	move $s1, $t5 # S1 = MONTH OF STRING 1
	#day of string 1
	li $t5, 0
	li $t2, 10
	lb $t3 8($t0)
	addi $t3, $t3, -48
	mul $t4, $t2, $t3 
	add $t5, $t5, $t4
	li $t2, 1
	lb $t3 9($t0)
	addi $t3, $t3, -48
	mul $t4, $t2, $t3 
	add $t5, $t5, $t4
	move $s2, $t5 #S2 = DAY OF STRING 1
	
	#year of string2
	li $t2, 1000
	lb $t3 0($t1)
	addi $t3, $t3, -48
	mul $t4, $t2, $t3 
	li $t5, 0
	add $t5, $t5, $t4 #t5 will store the end result of YEAR S1 (temp)
	li $t2, 100
	lb $t3 1($t1)
	addi $t3, $t3, -48
	mul $t4, $t2, $t3 
	add $t5, $t5, $t4
	li $t2, 10
	lb $t3 2($t1)
	addi $t3, $t3, -48
	mul $t4, $t2, $t3 
	add $t5, $t5, $t4
	li $t2, 1
	lb $t3 3($t1)
	addi $t3, $t3, -48
	mul $t4, $t2, $t3 
	add $t5, $t5, $t4
	move $s3, $t5 # S3 = YEAR OF STRING 2
	#month of string 1
	li $t5, 0
	li $t2, 10
	lb $t3 5($t1)
	addi $t3, $t3, -48
	mul $t4, $t2, $t3 
	add $t5, $t5, $t4
	li $t2, 1
	lb $t3 6($t1)
	addi $t3, $t3, -48
	mul $t4, $t2, $t3 
	add $t5, $t5, $t4
	move $s4, $t5 # S4 = MONTH OF STRING 2
	#day of string 1
	li $t5, 0
	li $t2, 10
	lb $t3 8($t1)
	addi $t3, $t3, -48
	mul $t4, $t2, $t3 
	add $t5, $t5, $t4
	li $t2, 1
	lb $t3 9($t1)
	addi $t3, $t3, -48
	mul $t4, $t2, $t3 
	add $t5, $t5, $t4
	move $s5, $t5 #S5 = DAY OF STRING 2
	
	#check dates
	blt $s3, $s0, invalid_entry_date
	beq $s3, $s0, check_months
	j calculate_day_difference
	check_months:
		blt $s4, $s1, invalid_entry_date
		beq $s4, $s1, check_days
		j calculate_day_difference
	check_days:
		blt $s5, $s2, invalid_entry_date
		j calculate_day_difference
		#beq $s2, $s5, 
	calculate_day_difference:
		move $s6, $s0 #year1
		li $s7, 0
		count_number_leap_years:
			move $a0, $s6
			jal is_leap_year
			bgtz $v0, increment_number_leap_years
			return_here_mid_count:
			addi $s6, $s6, 1
			ble $s6, $s3, count_number_leap_years
			j check_this_years_year
			
		increment_number_leap_years:
			addi $s7, $s7, 1
			j return_here_mid_count
			
		check_this_years_year: #check if its a leap year first, then do the arithmetic
			move $a0, $s3
			jal is_leap_year
			bgtz $v0, check_this_years_month
			j done_counting_leap_years
		check_this_years_month:
			li $t0, 2
			blt $s4, $t0, decrement_number_leap_years
			beq $s4, $t0, check_this_years_date
			j check_previous_years_year
		check_this_years_date:
			li $t0, 29
			blt $s5, $t0, decrement_number_leap_years
			j check_previous_years_year
		decrement_number_leap_years:
			addi $s7, $s7, -1
			j done_counting_leap_years
		check_previous_years_year:
			beq $s0, $s3, check_previous_years_month
			j done_counting_leap_years
		check_previous_years_month:
			li $t0, 2
			bgt $s1, $t0, decrement_number_leap_years
			j done_counting_leap_years

		done_counting_leap_years:
			sub $t0, $s3, $s0 #year2 - year1
			sub $t1, $s4, $s1 #month2 - month1
			sub $t2, $s5, $s2 #day2 - day1
			li $t3, 365
			mul $s6, $t0, $t3 #year difference * 364
			sub $s2, $s5, $s2 #S2 = DATE DIFFERENCE
			add $s6, $s6, $s2 #YEAR (AMT) + DATE AMOUNT
			add $s6, $s6, $s7 #YEAR AMT + DATE AMT + LEAP YEAR AMT
			#missing monthly count now
			li $t9, 0 #WILL KEEP TRACK OF MONTH DAYS
			blt $s1, $s4, count_month_days
			bgt $s1, $s4, count_month_days_inverse
			j finish_adding_days
			count_month_days: #all we need to preserve now is s6, s1, s4
				#beq $s1, $s4, finish_adding_days
				li $t0, 2
				beq $t0, $s1, increment_28_days
				li $t0, 4
				beq $t0, $s1, increment_30_days
				li $t0, 6
				beq $t0, $s1, increment_30_days
				li $t0, 9
				beq $t0, $s1, increment_30_days
				j increment_31_days
				
				increment_31_days:
					addi $t9, $t9, 31
					j increment_month_count
				increment_30_days:
					addi $t9, $t9, 30
					j increment_month_count
				increment_28_days:
					addi $t9, $t9, 28
					j increment_month_count
				increment_month_count:
					addi $s1, $s1, 1
					blt $s1, $s4, count_month_days
					j finish_adding_days
				
				count_month_days_inverse: #all we need to preserve now is s6, s1, s4
				li $t0, 2
				beq $t0, $s1, decrement_28_days
				li $t0, 4
				beq $t0, $s1, decrement_30_days
				li $t0, 6
				beq $t0, $s1, decrement_30_days
				li $t0, 9
				beq $t0, $s1, decrement_30_days
				j decrement_31_days
				
				decrement_31_days:
					addi $t9, $t9, -31
					j decrement_month_count
				decrement_30_days:
					addi $t9, $t9, -30
					j decrement_month_count
				decrement_28_days:
					addi $t9, $t9, -28
					j decrement_month_count
				decrement_month_count:
					addi $s1, $s1, -1
					bgt $s1, $s4, count_month_days_inverse
					j finish_adding_days
		finish_adding_days:
			add $s6, $s6, $t9 #FINAL COUNT
			move $v0, $s6
			j deallocate_stack_datestring_to_num_days	
	invalid_entry_date:
		li $v0, -1
		j deallocate_stack_datestring_to_num_days
	deallocate_stack_datestring_to_num_days:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $s6, 24($sp)
		lw $s7, 28($sp)
		lw $ra, 32($sp)
		addi $sp, $sp, 36 #save s registers on stack
		jr $ra

sell_book:
	addi $sp, $sp, -36 #save s registers on stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	
	move $s0, $a0 #sales strucutre
	move $s1, $a1 #books structure
	move $s2, $a2 #ISBN
	move $s3, $a3 #customer ID
	#lw $s4, 0($sp) #sale date								
	#lw $s5, 4($sp) #sale price 								
	
	lw $t0, 0($s0) #capacity
	lw $t1, 4($s0) #current size
	beq $t0, $t1, sales_table_full
	#check if ISBN exists in the hashtable books?
	move $a0, $s1 #books
	move $a1, $s2 #ISBN
	jal get_book
	bltz $v0, doesnt_exist_in_hashtable_books
	j insert_in_sales_hashtable #the ISBN exists
	
	insert_in_sales_hashtable:
		#get the expected element
		move $a0, $s0 #sales
		move $a1, $s2 #ISBN
		move $a2, $s3 #customer ID
		jal hash_booksale
		move $s4, $v0 #EXPECTED ELEMENT
		move $s5, $s0 #beginning of sales structure
		addi $s5, $s5, 12 #actual start of data sales structure
		lb $t0 8($s0) #element size
		mul $t1, $t0, $s4 #element size * expected element
		add $s5, $s5, $t1 #positition of the expected element
		move $s6, $s4
			li $s7, 0 #keeps track of how many we've actually looked at
		check_from_expected_to_end_sell_book:				
			lb $t0, 0($s5) #if its empty aka = 0, then USE S7 TO DETERMINE
			addi $s7, $s7, 1
			beqz $t0, found_empty_spot_sell_book
			#else increment until we hit capacity
			addi $s6, $s6, 1
			lb $t3, 8($s0)
			add $s5, $s5, $t3 #increment by elements size
			lb $t2, 0($s0)
			blt $s6, $t2, check_from_expected_to_end_sell_book
			j check_from_beginning_to_expected_sell_book
	

		check_from_beginning_to_expected_sell_book: #until s4
			li $s6, 0
			move $s5, $s0											
			addi $s5, $s5, 12												
			check_from_beginning_to_end_sell_book_actual_loop:
			lb $t0, 0($s5) #if its empty aka = 0, then USE S7 TO DETERMINE
			addi $s7, $s7, 1
			beqz $t0, found_empty_spot_sell_book
			addi $s6, $s6, 1
			lb $t3, 8($s0)
			add $s5, $s5, $t3 #increment by elements size
			blt $s6, $s4, check_from_beginning_to_end_sell_book_actual_loop
			j sales_table_full

		found_empty_spot_sell_book:
			lw $t9, 4($s0)
			addi $t9, $t9, 1
			sw $t9, 4($s0) #increments size by one
			li $t3, 14
			li $t2, 0
			#WRITES ISBN
			move $a0, $s5 #location
			move $a1, $s2 #ISBN
			li $a2, 14
			jal memcpy
			addi $s5, $s5, 14
			
			#write to memory 1600-01-01
			li $t0, '1'
			sb $t0, 0($s5)
			li $t0, '6'
			sb $t0, 1($s5)
			li $t0, '0'
			sb $t0, 2($s5)
			li $t0, '0'
			sb $t0, 3($s5)
			li $t0, '-'
			sb $t0, 4($s5)
			li $t0, '0'
			sb $t0, 5($s5)
			li $t0, '1'
			sb $t0, 6($s5)
			li $t0, '-'
			sb $t0, 7($s5)
			li $t0, '0'
			sb $t0, 8($s5)
			li $t0, '1'
			sb $t0, 9($s5)
			move $a0, $s5 #starting date
			lw $a1, 36($sp) #sale date
			jal datestring_to_num_days
			move $t8, $v0 #save date days on s4
			
			#two byte buffer after ISBN 
			li $t0, '\0'
			sb $t0, 0($s5)
			sb $t0, 1($s5)
			addi $s5, $s5, 2
			#write the 4 byte customer id into memory
			#move $a0, $s5 #location
			#move $a1, $s3 #customer id
			#li $a2, 4 # 4 bytes copying
			#jal memcpy
			sw $s3, 0($s5)				
			#date days
			
			
			
			addi $s5, $s5, 4
			#move $a0, $s5
			sw $t8, 0($s5)
			addi $s5, $s5, 4
			#move $a1, $s4 #date days							
			#li $a2, 4
			#jal memcpy
			#addi $s5, $s5, 4
			
			
			
			
			#price
			lw $t5, 40($sp) #sale price 
			#move $a0, $s5
			#move $a1, $t5 #sale price
			#li $a2, 4
			#jal memcpy
			sw $t5, 0($s5)
			
			#2 things left... Increment sales hash table size by 1 and times sold in the books hashtable must be updated by one
			lw $t0, 4($s0)
			addi $t0, $t0, 1
			sw $t0, 4($s0) #size has been incremeted by one...
			
			#s4 still has the expected element
			move $t1, $s1 #books structure
			addi $t1, $t1, 12
			lw $t2, 8($s1) #elements size
			mul $t3, $s4, $t2 #expected elemenet * elements size
			add $t3, $t3, $t2 #go to the next one over
			addi $t3, $t3, -4 #get the time sold 4 bytes
			add $t2, $t1, $t3 #t2 stores the location of times sold
			lw $t4, 0($t2) # t4 = times solds
			addi $t4, $t4, 1 #increments time ssold by one
			sw $t4, 0($t2)
			#done with the 2 random things
			
			move $v0, $s6 #where the structure is inserted
			move $v1, $s7 #how many elements we had to iterate through
			j deallocate_stack_sell_book
	
	
	
	
	sales_table_full:
		li $v0, -1
		li $v1, -1
		j deallocate_stack_sell_book
	doesnt_exist_in_hashtable_books:
		li $v0, -2
		li $v1, -2
		j deallocate_stack_sell_book
	deallocate_stack_sell_book:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $s6, 24($sp)
		lw $s7, 28($sp)
		lw $ra, 32($sp)
		addi $sp, $sp, 36 #save s registers on stack
		jr $ra
    jr $ra

compute_scenario_revenue:
	addi $sp, $sp, -16 #save 4 s registers on stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	
	
	move $s0, $a0 #Sale[]
	move $s1, $a1 #number sales, array size
	move $s2, $a2 #sale order (32 length max)
	move $t3, $s1 #right most book
	addi $t3, $t3, -1
	#scenario's we want
		#li $t0, 32
		#sub $t0, $t0, $s1 # 32- num we want
		#add $s2, $s2, $t0 #gets the 0th scenario we want
	li $t0, 1
	addi $s1, $s1, -1
	sllv $s1, $t0, $s1 #sales is now a 
	
	li $t1, 0 #coutner for which scenario we're on
	li $t2, 0 #will keep track of the left most book
	#move $t3, $s1 #right most book
	li $t4, 0 #will keep track of the sale multiplier we're on
	li $t5, 28 #28 bytes per sale
	li $s3, 0 #keep track of total sale price
	get_scenario_loop:
		and $t0, $s1, $s2 #the bitwise and of each.
		#lb $t0, 0($s2) #gets the scenario
		#addi $t1, $t1, 1
		#addi $s2, $s2, 1
		beqz $t0, left_most_book
		j right_most_book
		
		return_here_scenario_loop:
		srl $s1, $s1, 1
		bnez $s1, get_scenario_loop
		#blt $t1, $s1, get_scenario_loop
		j done_running_scenarios
		
		left_most_book: #remember each sale is 28 bytes
			addi $t4, $t4, 1
			mul $t6, $t2, $t5 #left most book counter * 28
			addi $t6, $t6, 24 #the sale price is the last 4 bytes
			move $t7, $s0 #base of the sale[]
			add $t7, $t7, $t6 #get the sale price address
			lw $t8, 0($t7) #sale price
			mul $t8, $t8, $t4 #sale price times multiplier
			add $s3, $s3, $t8 #total
			addi $t2, $t2, 1
			j return_here_scenario_loop
		right_most_book:
			addi $t4, $t4, 1
			mul $t6, $t3, $t5 #right most book counter * 28
			addi $t6, $t6, 24 #the sale price is the last 4 bytes
			move $t7, $s0 #base of the sale[]
			add $t7, $t7, $t6 #get the sale price address
			lw $t8, 0($t7) #sale price
			mul $t8, $t8, $t4 #sale price times multiplier
			add $s3, $s3, $t8 #total
			addi $t3, $t3, -1
			j return_here_scenario_loop
		
		
	done_running_scenarios:
		move $v0, $s3
		j deallocate_stack_compute_scenario_revenue
	deallocate_stack_compute_scenario_revenue:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		addi $sp, $sp, 16 #save 4 s registers on stack
    		jr $ra

maximize_revenue:
	addi $sp, $sp, -24 #save 4 s registers on stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $ra, 20($sp)
	
	move $s0, $a0 #sales list
	move $s1, $a1 #num sales
	li $s2, 0 #number to iterate by
	li $t0, 1
	sllv $s3, $t0, $s1 #s3 = 2^n
	li $s4, 0 #max
	for_loop_maximize:
		move $a0, $s0 #sales[]
		move $a1, $s1 #num sales
		move $a2, $s2 #scenario
		jal compute_scenario_revenue
		bgt $v0, $s4, new_max_found
		return_here_max:
		addi $s2, $s2, 1
		blt $s2, $s3, for_loop_maximize
		j deallocate_stack_maximize_revenue
	new_max_found:
		move $s4, $v0
		j return_here_max
	deallocate_stack_maximize_revenue:
		move $v0, $s4
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $ra, 20($sp)
		addi $sp, $sp, 24 #save 4 s registers on stack
    jr $ra

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
