# PURPOSE	Non recursive factorial
# INPUTS	A number

.section .data

.section .text

.globl _start
.globl factorial

_start:
	pushl	$4
	call	factorial
	addl	$4, %esp
	movl	%eax, %ebx
	movl	$1, %eax
	int		$0x80

.type factorial,@function
factorial:
	pushl	%ebp
	movl	%esp,%ebp
	movl	8(%ebp), %eax
	movl	8(%ebp), %ebx
	cmpl	$1, %eax
	je		end_factorial
	jmp		start_loop

start_loop:
	cmpl	$1, %ebx
	je		end_factorial
	decl	%ebx
	imull	%ebx, %eax
	jmp		start_loop

end_factorial:
	movl	%ebp, %esp 
	popl	%ebp
	ret
	
