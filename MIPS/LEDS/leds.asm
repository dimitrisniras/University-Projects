        .data
mes:    .asciiz "   Please insert the state of the three switches   \n\n"
s1:     .asciiz "Switch 1: "
s2:     .asciiz "Switch 2: "
s3:     .asciiz "Switch 3: "
run:    .asciiz "Run the program <you must press the K button> : "
l1:     .asciiz "\nLED1 is "
l2:     .asciiz ", LED2 is "
l3:     .asciiz ", LED3 is "
on:     .asciiz "ON"
off:    .asciiz "OFF"

		.text
main:
        la $a0, mes             # address of string to print
		li $v0, 4               # system call code for print_str
        syscall           		# print the string
		
		la $a0, s1              # address of string to print
		li $v0, 4               # system call code for print_str
		syscall                 # print the string
		
		li $v0, 5               # system call code for read_int
		syscall                 # read the int
		sb $v0, 0($gp)          # int to gp[0]
		
		la $a0, s2              # address of string to print
		li $v0, 4               # system call code for print_str
		syscall                 # print the string
		
		li $v0, 5               # system call code for read_int
		syscall                 # read the int
		sb $v0, 1($gp)          # int to gp[1]
		
		la $a0, s3              # address of string to print
		li $v0, 4               # system call code for print_str
		syscall                 # print the string
		
		li $v0, 5               # system call code for read_int
		syscall                 # read the int
		sb $v0, 2($gp)          # int to gp[2]
		
		la $a0, run             # address of string to print
		li $v0, 4               # system call code for print_str
		syscall          		# print the string
		
		la $t4, 75              # $t4='K'
loop:	li $v0, 12              # system call code for read_char
		syscall                 # read the char
	    bne $v0, $t4, loop	    # if ($v0!=$t4) goto loop	
		
L1:		la $a0, l1              # address of string to print
		li $v0, 4               # system call code for print_str
		syscall                 # print the string
		lb $t0, 0($gp)          # $t0=gp[0]
		beq $t0, $zero, if1     # if $t0==0 go to if1
		la $a0, on              # address of string to print
		li $v0, 4               # system call code for print_str
		syscall                 # print the string	
		j L2

if1:    la $a0, off             # address of string to print
		li $v0, 4               # system call code for print_str
		syscall	             	# print the string
		
L2:		la $a0, l2              # address of string to print
		li $v0, 4               # system call code for print_str
		syscall                 # print the string
		lb $t0, 1($gp)          # $t0=gp[1]
		beq $t0, $zero, if2     # if $t0==0 go to if2
		la $a0, on              # address of string to print
		li $v0, 4               # system call code for print_str
		syscall                 # print the string
        j L3
		
if2:    la $a0, off             # address of string to print
		li $v0, 4               # system call code for print_str
		syscall	             	# print the string
		
L3:		la $a0, l3              # address of string to print
		li $v0, 4               # system call code for print_str
		syscall                 # print the string
		lb $t0, 2($gp)          # $t0=gp[2]
		beq $t0, $zero, if3     # if $t0==0 go to if3
		la $a0, on              # address of string to print
		li $v0, 4               # system call code for print_str
		syscall	             	# print the string
		
		li $v0, 10              # system call code for exit
		syscall                 # exit

if3:    la $a0, off             # address of string to print
		li $v0, 4               # system call code for print_str
		syscall	             	# print the string

		li $v0, 10              # system call code for exit
		syscall                 # exit