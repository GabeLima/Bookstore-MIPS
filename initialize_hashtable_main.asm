# Hashtable of Book objects
.data
.align 2
capacity: .word 5
element_size: .word 68
hashtable:
.word 71033136 # capacity
.word 93363139 # size
.word 56496418 # element_size
.byte 137 83 120 69 185 21 60 110 72 54 141 136 64 238 171 95 213 172 152 180 237 100 114 26 40 144 40 71 48 142 10 139 235 94 205 176 79 192 189 11 111 194 39 245 89 53 160 151 184 77 75 63 59 182 78 49 199 11 61 160 244 5 108 195 140 139 161 210 
.byte 105 128 241 145 186 79 34 253 237 129 3 103 98 49 61 70 255 144 235 255 8 17 10 108 37 233 133 185 206 228 44 13 130 244 125 22 55 250 251 81 89 150 234 50 72 191 53 244 87 93 119 48 146 229 4 7 184 86 96 143 88 99 202 179 187 25 34 122 
.byte 88 193 11 31 215 76 223 160 180 90 93 61 46 169 105 163 42 203 207 3 100 92 92 98 101 181 5 127 233 157 96 101 161 241 106 242 207 133 66 175 4 156 3 169 150 243 242 76 223 48 226 213 26 147 254 105 105 96 230 115 215 150 151 196 209 95 93 234 
.byte 81 233 84 195 154 140 48 144 233 1 209 80 210 60 158 149 54 131 170 43 222 135 102 158 228 36 33 174 249 82 210 104 68 144 109 56 176 251 127 137 221 113 89 168 145 10 11 181 118 39 90 51 203 32 60 29 138 149 154 166 23 180 90 2 168 130 114 102 
.byte 232 123 167 53 183 139 215 59 3 23 223 102 175 135 241 77 156 250 139 120 190 154 140 200 251 105 66 134 79 84 84 143 145 52 157 138 81 254 13 176 199 35 177 251 5 112 200 36 108 161 112 192 122 143 23 140 32 237 141 198 126 21 184 32 143 78 212 208 

.text
.globl main
main:
la $a0, hashtable
				la $s5, hashtable
lw $a1, capacity
lw $a2, element_size
jal initialize_hashtable

# Write code to check the correctness of your code!
	move $a0, $v0
	li $v0, 1
	syscall
	lw $a0, 0($s5)
	li $v0, 1
	syscall
	lw $a0, 4($s5)
	li $v0, 1
	syscall
	lw $a0, 8($s5)
	li $v0, 1
	syscall

li $v0, 10
syscall

.include "hwk4.asm"