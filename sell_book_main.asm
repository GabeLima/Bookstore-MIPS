# sales hash table is empty
.data
isbn: .asciiz "9780670032080"
customer_id: .word 12345
sale_date: .asciiz "2020-09-14"
sale_price: .word 50
books:
.align 2
.word 7 6 68
# Book struct start
.align 2
.ascii "9780345501330\0"
.ascii "Fairy Tail, Vol. 1 (Fair\0"
.ascii "Hiro Mashima, William Fl\0"
.word 0
# empty or deleted entry starts here
.align 2
.byte 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
# Book struct start
.align 2
.ascii "9780060855900\0"
.ascii "Equal Rites (Discworld, \0"
.ascii "Terry Pratchett\0\0\0\0\0\0\0\0\0\0"
.word 0
# Book struct start
.align 2
.ascii "9780670032080\0"
.ascii "Financial Peace Revisite\0"
.ascii "Dave Ramsey\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
.word 0
# Book struct start
.align 2
.ascii "9780064408330\0"
.ascii "Joey Pigza Swallowed the\0"
.ascii "Jack Gantos\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
.word 0
# Book struct start
.align 2
.ascii "9780312577220\0"
.ascii "Fly Away (Firefly Lane, \0"
.ascii "Kristin Hannah\0\0\0\0\0\0\0\0\0\0\0"
.word 0
# Book struct start
.align 2
.ascii "9781416971700\0"
.ascii "Out of My Mind\0\0\0\0\0\0\0\0\0\0\0"
.ascii "Sharon M. Draper\0\0\0\0\0\0\0\0\0"
.word 0


sales:
.align 2
.word 9 0 28
# empty or deleted entry starts here
.align 2
.byte 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
# empty or deleted entry starts here
.align 2
.byte 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
# empty or deleted entry starts here
.align 2
.byte 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
# empty or deleted entry starts here
.align 2
.byte 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
# empty or deleted entry starts here
.align 2
.byte 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
# empty or deleted entry starts here
.align 2
.byte 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
# empty or deleted entry starts here
.align 2
.byte 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
# empty or deleted entry starts here
.align 2
.byte 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
# empty or deleted entry starts here
.align 2
.byte 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 



.text
.globl main
main:
la $a0,  sales
la $a1,  books
la $a2,  isbn
lw $a3,  customer_id
la $t0,  sale_date
lw $t1,  sale_price
addi $sp, $sp, -8
sw $t0, 0($sp)
sw $t1, 4($sp)
li $t0, 929402 # garbage
li $t1, 6322233 # garbage
move $s0, $a0
jal sell_book

# Write code to check the correctness of your code!
	#move $a0, $v0
	#li $v0, 1
	#syscall
	#move $a0, $v1
	#li $v0, 1
	#syscall
	
	addi $s0, $s0, 12
	addi $s0, $s0, 140
	li $t0, 14
	li $t2, 0
	while_loop_test:
		lb $t1, 0($s0)
		addi $t2, $t2, 1
		addi $s0, $s0, 1
		move $a0, $t1
		li $v0, 11
		syscall
		blt $t2, $t0, while_loop_test
	li $a0, '_'
	li $v0, 11
	syscall
	addi $s0, $s0, 2
	li $t0, 12
	li $t2, 0
	while_loop_test_2:
		lw $t1, 0($s0)
		addi $t2, $t2, 4
		addi $s0, $s0, 4
		move $a0, $t1
		li $v0, 11
		syscall
		blt $t2, $t0, while_loop_test_2
li $v0, 10
syscall

.include "hwk4.asm"
