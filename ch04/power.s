# Purpose:	Program to illustrate how functions work
#			This program will compute the value of
#			2^3 + 5^2

#Everything in the main program is stored in registers,
#so the data section doesn't have anything

.section .data

.section .text

.globl _start
_start:
	pushl	$0			# push second argument
	pushl	$2			# push first atgument
	call	power		# call power function
	addl	$8, %esp	# move the stack pointer back
	pushl	%eax		# save the answer before
						# the next function call
	pushl	$0			# push the second argument
	pushl	$5			# push the first argument
	call	power		# call the power function
	addl	$8, %esp	# move the stack pointer back
	
	popl	%ebx		# the second answer is already 
						# in %eax. We saved the 
						# first answer onto the stack,
						# so now we can just pop it
						# out to %ebx
	addl	%eax,%ebx	# add the results together
						# the result is in %ebx
	movl	$1, %eax	# exit, %ebx is returned
	int		$0x80 

# PURPOSE:	This function is used to compute
#			the value of a number raised to
#			a power

# VARIABLES:
#		%ebx - holds the umber
#		%eax - hold the power
#		-4(%ebp) - holds the result
#		%eax is used for temporary storage

.type power,@function
power:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$4, %esp

	movl	8(%ebp), %ebx
	movl	12(%ebp), %ecx
	cmpl	12(%ebp), %ecx
	jle		power_zero
	movl	%ebx, -4(%ebp)

power_loop_start:
	cmpl	$1, %ecx
	je		end_power
	movl	-4(%ebp), %eax
	imull	%ebx, %eax
	
	movl	%eax, -4(%ebp)

	decl	%ecx
	jmp		power_loop_start

end_power:
	movl	-4(%ebp), %eax
	movl	%ebp, %esp
	popl	%ebp
	ret

power_zero:
	movl	$1, %eax
	movl	%ebp, %esp
	popl	%ebp
	ret
