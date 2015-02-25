# PURPOSE:	I'm not sure if this is actually what the exercise intends
#			but I am going to push a bunch of values on the stack and 
#			calculate the maximum

.section .data

.section .text

.globl _start
.globl maximum

_start:
	pushl	$0
	pushl	$5
	pushl	$44
	pushl	$32
	pushl	$102
	pushl	$3
	call	maximum
	movl	%eax, %ebx
	movl	$1, %eax
	int		$0x80

.type maximum,@function
maximum:
	pushl	%ebp
	movl	%esp, %ebp
	movl	$1, %edi
	movl	4(%ebp), %ecx
	jmp		start_loop

start_loop:
	addl	$4, %ecx
	cmpl	$0, %eax
	je		end_loop
	cmpl	%eax, %ebx
	jle		start_loop
	movl	%eax,%ebx
	jmp		start_loop


end_loop:
	movl	%ebp, %esp
	popl	%ebp
	ret	
	
