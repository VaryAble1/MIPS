.data
	same:		.asciiz		"same.."
	bigger:		.asciiz		"bigger.."
	smaller:		.asciiz		"smaller.."
	numIs:		.asciiz		"The largest number is "
	numInc:		.asciiz		"the largest number is included "
	times:		.asciiz		" times. "
	comma:		.asciiz		", "
	i:		.word 0		#int i
	j:		.word 0		#int j
	num:		.word 12		#int num = 13;
	largest:		.word 0		#int largest = 0;
	count:		.word 0		#int count = 0;

	#int a[13] = {5, 2, 15, 3, 7, 15, 8, 9, 5, 2, 15, 3, 7};
	arr:		.word 5, 2, 15, 3, 7, 15, 8, 9, 5, 2, 15, 3, 7

.text
.globl main

#int main(void) {
main:

	la	$s0, num			# initalizing register
	lw	$s1, 0($s0)		# $s1 = size
	ori	$s2, $0, 0		# $s2 = largest
	ori	$s3, $0, 0		# $s3 = j
	ori	$s4, $0, 0		# $s4 = comparator
	ori	$s5, $0, 0		# $s5 = i
	ori	$s7, $0, 0		# $s7 = counter
	la	$s6, arr			# $s6 = &arr
#for(i = 0; i < num; i ++) {
L1:	
	bgt $s5, $s1, Done			# if i > num jump to Done
# printf(“%d ”, a[i]);
	li	$v0, 1			#print $s6
	lw	$a0, 0($s6)		# $a0 = arr[i]
	syscall
	addi	$s5, $s5, 1		# i++
	bgt	$s5, $s1, Done		# if i > num jump to Done
	li	$v0, 4			# Code
	la	$a0, comma		# Comma
	syscall				# Print
	addi	$s6, $s6, 4		# Move array pointer to next
	j L1				# Loop
	
#};
Done:

#printf(“\n”);
	li	$v0, 11			# Code
	addi	$a0, $zero, 0		# zero out reg
	addi	$a0, $zero, 10		# Ascii code code for nl
	syscall				# Print
	
#for(i = 0; i < num; i ++) {
	addi	$s5, $zero, 0		# i = 0
	subi	$s6, $s6, 48		# a[0]
L2:	
	lw	$a1, 0($s6)		# $a1 = arr[i]
	bgt 	$s5, $s1, Continue		# if i > num jump to Continue

	
# j = compare (largest, a[i]);
	jal Compare
	
	add 	$s3, $zero, $s4		# $s3 = j $s4 comparitor
# switch (j) {				
# case 0: 				# if j = 0
	addi	$s4, $zero, 0		# $s4 = 0 to compare
	bne	$s3, $s4, C1_Cond		# j = 0 else jump to Case 1

# largest = a[i];
	add 	$s2,$zero, $zero		# Zero out reg
	add 	$s2, $zero, $a1 		# Add largest to reg

# count = 1;
	addi	$s7, $zero, 1		# count = 0 + 1
# printf(“bigger.. \n”);
	li	$v0, 4
	la	$a0, bigger
	syscall
#printf(“\n”);
	li	$v0, 11			# Code
	addi	$a0, $zero, 0		# zero out reg
	addi	$a0, $zero, 10		# Ascii code code for nl
	syscall				# Print
	
# break;
	j Break

# case 1: 				# if j = 1
C1_Cond:
	addi	$s4, $zero, 0		# $s4 = 0 
	addi	$s4, $zero, 1		# $s4 = 1 to compare
	bne	$s3, $s4, C2_Cond		# if not 1 then jump to 2

# count ++;
	addi	$s7,$s7, 1		# count++

# printf(“same.. \n”);
	li	$v0, 4
	la	$a0, same
	syscall
	#printf(“\n”);
	li	$v0, 11			# Code
	addi	$a0, $zero, 0		# zero out reg
	addi	$a0, $zero, 10		# Ascii code code for nl
	syscall				# Print
	
# break;
	j Break

# case 2: 				# if j = 2
C2_Cond:
	addi	$s4, $zero, 0		# $s4 = 0 
	addi	$s4, $zero, 2		# $s4 = 2
	bne	$s3, $s4, Break		# if not 2 then Break

# printf(“smaller.. \n”);
	li	$v0, 4
	la	$a0, smaller
	syscall
	#printf(“\n”);
	li	$v0, 11			# Code
	addi	$a0, $zero, 0		# zero out reg
	addi	$a0, $zero, 10		# Ascii code code for nl
	syscall				# Print

# break;
	j Break


# }; End Switch
Break:
	addi	$s5, $s5, 1		# i++
	addi	$s6, $s6, 4		# move array pointer to next
# }; End For loop
j L2
	
Continue:				# Fall out
	li	$v0, 11
	addi	$a0, $zero, 0
	addi	$a0, $zero, 10
	syscall
#printf(“The largest number is %d. \n”, largest);
	li	$v0, 4
	la	$a0, numIs
	syscall
	li	$v0, 1
	add	$a0, $zero, $s2
	syscall
	li	$v0, 11
	addi	$a0, $zero, 0
	addi	$a0, $zero, 10
	syscall
#printf(“the largest number is included %d times. \n”, count);
	li	$v0, 4
	la	$a0, numInc
	syscall
	li	$v0, 1
	add	$a0, $zero, $s7
	syscall
	li	$v0, 4
	la	$a0, times
	syscall
	j Exit
					# Fall out

#int compare(int a, int b) {
Compare:

# if (sub(a, b) > 0) {
	add	$t1, $zero, $ra		#L2 Address
	jal Sub
	add	$ra, $zero, $t1		# Restore Address
	beq	$v1, $zero, ElseIf		# if $s4 == 0 jump to ElseIf
	bltz	$v1, Else			# if $s4  < 0 jump to Else

# return 2;
	addi	$s4, $zero, 0		# $s4 = 0
	addi	$s4, $zero, 2		# $s4 = 2
#}
	jr $ra				# Jump back to caller	

#else if (sub(a, b) == 0) {
ElseIf:

# return 1;
	addi	$s4, $zero, 0		# $s4 = 0
	addi	$s4, $zero, 1		# $s4 = 1
#}
	jr $ra				# Jump back to caller	
# else {
Else:
# return 0;
	addi	$s4, $zero, 0		# $s4 = 0
	jr $ra				# Jump back to caller	

# };
#}

#int sub(int a, int b) {
Sub:

# return (a – b);
	sub	$v1, $s2, $a1	# $s4 = Largest - a[i]	
	jr $ra

#} 
Exit:
#Thanks for looking