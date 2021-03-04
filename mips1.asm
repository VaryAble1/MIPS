# Homework #2
# File: mips1.asm 
# Author: Branden Lawrence
# Date: 02/9/2021
# About: Displays a countdown from 49 to 0.
# Course: CS 3375 Section: 001
# Texas Tech University

.data    
limit:     .word 50 
space:     .asciiz  " " 
newline:   .asciiz  "\n" 
tab_space: .asciiz  "\t" 
msg_01:    .asciiz  "A Sample MIPS Code\n" 
msg_02:    .asciiz  "This program displays the count from 49 down to 0 \n" 
msg_03:    .asciiz  "\nEnd of program! \n" 
 
.text     
.globl main   
main:	la $a0, msg_01 
	li $v0, 4  
	syscall  
	la $a0, msg_02 
	li $v0, 4 
	syscall  
	lw $a0, limit 
	la $a1, space 
	loop: beq $0, $a0, exit 
	addi $a0, $a0, -1 
	li $v0, 1 
	syscall  
	move $t0, $a0
	move $a0, $a1 
	li $v0, 4 
	syscall  
	move $a0, $t0
	j loop  
	exit: 
	la $a0, msg_03 
	li $v0, 4 
	syscall  
	li $v0, 10  
	syscall  