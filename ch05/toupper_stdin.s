#PURPOSE:	Convert an input file to output and 
#			make it all uppercase


.section .data

#### Constants
# system call numbers
.equ SYS_OPEN, 5
.equ SYS_WRITE, 4
.equ SYS_READ, 3
.equ SYS_CLOSE, 6
.equ SYS_EXIT, 1

#options for open
.equ O_RDONLY, 0
.equ O_CREAT_WRONLY_TRUNC, 03101

#std file descriptors
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

#system call interrupt
.equ LINUX_SYSCALL, 0x80

.equ END_OF_FILE, 0

.equ NUMBER_ARGUMENTS, 2

.section .bss
# Buffer
.equ BUFFER_SIZE, 500
.lcomm BUFFER_DATA, BUFFER_SIZE

.section .text

#STACK Positions
.equ ST_SIZE_RESERVE, 8
.equ ST_FD_IN, -4
.equ ST_FD_OUT, -8
.equ ST_ARGC, 0
.equ ST_ARGV_0, 4
.equ ST_ARGV_1, 8
.equ ST_ARGV_2, 12

.globl _start
_start:
# Initialize the program
# Save the stack pointer
	movl	%esp, %ebp

# Allocate space for the file descriptors
	subl	$ST_SIZE_RESERVE, %esp

openfiles:
open_fd_in:
	# open input file
	movl	 $SYS_OPEN, %eax
	# input filename into ebx
	movl	ST_ARGV_1(%ebp), %ebx
	# read-only flag
	movl	$O_RDONLY, %ecx
	# this doesnt really matter for reading
	movl	$0666, %edx
	#call linux
	int		$LINUX_SYSCALL

store_fd_in:
	# save the given file descriptor
	movl	%eax, ST_FD_IN(%ebp)

# NO NEED FOR THIS - Stdout only
#open_fd_out:	
	# open output file
#	movl	$SYS_OPEN, %eax
	# ouput filename into %ebx	
#	movl	ST_ARGV_2(%ebp), %ebx
	# flags for writing to the file
#	movl	$O_CREAT_WRONLY_TRUNC, %ecx
	# mode for new file
#	movl $0666, %edx
	# call Linux
#	int $LINUX_SYSCALL

#store_fd_out:
	# store the file descriptor here
#	movl	%eax, ST_FD_OUT(%ebp)

read_loop_begin:
	## READ IN A BLOCK from the input file
	movl	$SYS_READ, %eax
	# get the input file desciptor
	movl	ST_FD_IN(%ebp), %ebx
	# the location to read into
	movl	$BUFFER_DATA, %ecx
	# the size of the buffer is returned to %eax
	int		$LINUX_SYSCALL

	## Exit if we've reached the end
	cmpl	$END_OF_FILE, %eax
	# if found or on error, go to the end
	jle		end_loop

continue_read_loop:
	#Conver the block to uppercase
	pushl	$BUFFER_DATA
	pushl	%eax
	call	convert_to_upper
	popl	%eax
	addl	$4, %esp
	
	## Write the block out to the output file
	# size of the buffer
	movl	%eax, %edx
	movl	$SYS_WRITE, %eax
	#fileto use
	movl	$STDOUT, %ebx  #use stdin here instead of the file descriptor
	#location of the buffer
	movl	$BUFFER_DATA, %ecx
	int		$LINUX_SYSCALL

	#continue the loop
	jmp		read_loop_begin

end_loop:
	### CLose the files
	movl	$SYS_CLOSE, %eax
	movl	ST_FD_OUT(%ebp), %ebx
	int		$LINUX_SYSCALL

	movl	$SYS_CLOSE, %eax
	movl	ST_FD_IN(%ebp), %ebx
	int		$LINUX_SYSCALL

	#exit
	movl	$SYS_EXIT, %eax
	movl	$0, %ebx
	int		$LINUX_SYSCALL

## PURPOSE:		This fucntion actually does the conversion
#				of lower to upper
#
#  INPUTS:		First param: location of buffer
#				Second param: size of buffer

.equ	LOWERCASE_A, 'a'
.equ	LOWERCASE_Z, 'z'
.equ	UPPER_CONVERSION, 'A' - 'a'

.equ	ST_BUFFER_LEN, 8
.equ	ST_BUFFER, 12

convert_to_upper:
	pushl	%ebp
	movl	%esp, %ebp

	movl	ST_BUFFER(%ebp), %eax
	movl	ST_BUFFER_LEN(%ebp), %ebx
	movl	$0, %edi
	
	cmpl	$0, %ebx
	je		end_convert_loop

convert_loop:
	movb	(%eax,%edi,1), %cl
	
	cmpb	$LOWERCASE_A, %cl
	jl		next_byte
	cmpb	$LOWERCASE_Z, %cl
	jg		next_byte

	addb	$UPPER_CONVERSION, %cl
	movb	%cl, (%eax, %edi, 1)

next_byte:
	incl	%edi
	cmpl	%edi, %ebx
	jne		convert_loop

end_convert_loop:
	movl	%ebp, %esp
	popl	%ebp
	ret
