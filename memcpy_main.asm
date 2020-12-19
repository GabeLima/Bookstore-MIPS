.data
.align 2
n: .word 3
.align 2
src: .ascii "ABCDEFGHIJ"
.align 2
dest: .ascii "XXXXXXX"

.text
.globl main
main:
la $a0,  dest
move $s0, $a0
la $a1,  src
lw $a2,  n
jal memcpy

# Write code to check the correctness of your code!
lb $a0, 0($s0)
li $v0, 11
syscall
lb $a0, 1($s0)
li $v0, 11
syscall
lb $a0, 2($s0)
li $v0, 11
syscall
lb $a0, 3($s0)
li $v0, 11
syscall
lb $a0, 4($s0)
li $v0, 11
syscall

li $v0, 10
syscall

.include "hwk4.asm"
