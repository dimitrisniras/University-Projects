        .data 
stra:   .asciiz "a("
strb:   .asciiz "b("
strd:   .asciiz "d("
comma:  .asciiz ","
par:    .asciiz ")= "
spaces: .asciiz "                    "
nl:     .asciiz "\n"
        .align 3
lista:  .space 72
listb:  .space 72
listd:  .space 72

        .text
main:   
        la $a1, lista           # address of array A in $a1
		la $a2, listb           # address of array B in $a2   
		la $a3, listd           # address of array D in $a3
		
		li $t7, 0               # $t7=0
		li $t8, 0               # $t8=0
loopa:  li $t9, 0               # $t9=0
loopa1: la $a0, stra            # address of string to print
		li $v0, 4               # system call code for print_str
        syscall           		# print the string
		
		move $a0, $t8           # $a0=$t8
		li $v0, 1               # system call code for print_int
		syscall                 # print the int
		
		la $a0, comma           # address of string to print
		li $v0, 4               # system call code for print_str
        syscall           		# print the string
		
		move $a0, $t9           # $a0=$t9
		li $v0, 1               # system call code for print_int
		syscall                 # print the int
		
		la $a0, par             # address of string to print
		li $v0, 4               # system call code for print_str
        syscall           		# print the string
		
		li $v0, 6               # system call code for read_float
		syscall                 # read the float
        cvt.d.s $f0, $f0        # convert the float number on double precision        
		s.d $f0, lista($t7)     # store the double number in a[i][j]
		
		addi $t7, $t7, 8        # $t7=$t7+8
		addi $t9, $t9, 1        # $t9=$t9+1
		bne $t9, 3, loopa1      # if ($t9!=3) goto loopa1
		addi $t8, $t8, 1        # $t8=$t8+1
		bne $t8, 3, loopa       # if ($t8!=3) goto loopa
		
		li $t7, 0               # $t7=0
		li $t8, 0               # $t8=0               
loopb:  li $t9, 0               # $t9=0
loopb1: la $a0, strb            # address of string to print
		li $v0, 4               # system call code for print_str
        syscall           		# print the string
		
		move $a0, $t8           # $a0=$t8
		li $v0, 1               # system call code for print_int
		syscall                 # print the int
		
		la $a0, comma           # address of string to print
		li $v0, 4               # system call code for print_str
        syscall           		# print the string
		
		move $a0, $t9           # $a0=$t9
		li $v0, 1               # system call code for print_int
		syscall                 # print the int
		
		la $a0, par             # address of string to print
		li $v0, 4               # system call code for print_str
        syscall           		# print the string

		li $v0, 6               # system call code for read_float
		syscall                 # read the float
        cvt.d.s $f0, $f0        # convert the float number in double precision        
		s.d $f0, listb($t7)     # store the double number in b[i][j]
		
		addi $t7, $t7, 8        # $t7=$t7+8
		addi $t9, $t9, 1        # $t9=$t9+1
		bne $t9, 3, loopb1      # if ($t9!=3) goto loopb1
		addi $t8, $t8, 1        # $t8=$t8+1
		bne $t8, 3, loopb       # if ($t8!=3) goto loopb
		
		li $t1, 3               # $t1=3
		li $s0, 0               # i=0		
L1:     li $s1, 0               # j=0
L2:     li $s2, 0               # k=0
        mul $t2, $s0, 3         # $t2=i*3
		addu $t2, $t2, $s1      # $t2=$t2+j
		sll $t2, $t2, 3         # $t2=offset byte from [i][j]
		addu $t2, $a3, $t2      # $t2=address byte of d[i][j]
		l.d $f4, 0($t2)         # $f4=8 byte of d[i][j]
		
L3:     mul $t0, $s2, 3         # $t0=k*3
		addu $t0, $t0, $s1      # $t0=$t0+j
		sll $t0, $t0, 3         # $t0=address offset of [k][j]
		addu $t0, $a2, $t0      # $t0=address byte of b[k][j]
		l.d $f16, 0($t0)        # $f16=8 byte of b[k][j]
		
		mul $t0, $s0, 3         # $t0=i*3
		addu $t0, $t0, $s2      # $t0=$t0+k
		sll $t0, $t0, 3         # $t0=address offset of [i][k]
		addu $t0, $a1, $t0      # $t0=address byte of a[i][k]
		l.d $f18, 0($t0)        # $f16=8 byte of a[i][k]
		
		mul.d $f16, $f18, $f16  # $f16=a[i][k]*b[k][j]
		add.d $f4, $f4, $f16    # $f4=d[i][j]+a[i][k]*b[k][j]
		
		addiu $s2, $s2, 1       # k=k+1
		bne $s2, $t1, L3        # if (k!=3) goto L3
		s.d $f4, 0($t2)         # d[i][j]=$f4
		
		addiu $s1, $s1, 1       # j=j+1
		bne $s1, $t1, L2        # if (j!=3) goto L2
		addiu $s0, $s0, 1       # i=i+1
		bne $s0, $t1, L1        # if (i!=3) goto L1
		
		li $t7, 0               # $t7=0
		li $t8, 1               # $t8=1
loopd:  li $t9, 1               # $t9=1
loopd1: la $a0, strd            # address of string to print
		li $v0, 4               # system call code for print_str
        syscall           		# print the string
		
		move $a0, $t8           # $a0=$t8
		li $v0, 1               # system call code for print_int
		syscall                 # print the int
		
		la $a0, comma           # address of string to print
		li $v0, 4               # system call code for print_str
        syscall           		# print the string
		
		move $a0, $t9           # $a0=$t9
		li $v0, 1               # system call code for print_int
		syscall                 # print the int
		
		la $a0, par             # address of string to print
		li $v0, 4               # system call code for print_str
        syscall           		# print the string
		
		l.d $f12, listd($t7)    # $f12=d[i][j]
		li $v0, 3               # system call code for print_double
		syscall                 # print the double
		
		addi $t7, $t7, 8        # $t7=$t7+8
		addi $t9, $t9, 1        # $t9=$t9+1
		
		la $a0, spaces          # address of string to print
		li $v0, 4               # system call code for print_str
        syscall           		# print the string   
		
		bne $t9, 4, loopd1      # if ($t9!=4) goto loopd1
		
		la $a0, nl              # address of string to print
		li $v0, 4               # system call code for print_str
        syscall           		# print the string  
		
		addi $t8, $t8, 1        # $t8=$t8+1
		bne $t8, 4, loopd       # if ($t8!=4) goto loopd
		
		li $v0, 10              # system call code for exit
		syscall                 # exit