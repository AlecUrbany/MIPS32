#       Name:       Urbany, Alec 
#       Project:    #5 
#       Due:        December 8, 2022  
#       Course:     cs-2640-04-f22 
# 
#       Description: 
#               Fifth project - Gets input from user, will output a solution discriminant = b^2 - 4ac

	.data
Title:	.asciiz "Quadratic equation solver v0.1 by A. Urbany\n\n"
useOne:	.asciiz	"Enter value for a? "
useTwo:	.asciiz	"Enter value for b? "
useThr:	.asciiz	"Enter value for c? "
inOne:	.float	0.0
inTwo:	.float	0.0
inThr:	.float	0.0
rtnNeg:	.asciiz	"Roots are imaginary."
rtnZer:	.asciiz	"Not a quadratic equation."
rtnOne:	.asciiz	"x = "
rtnTwo:	.asciiz	"x1 = "
rtnXTwo:	.asciiz	"\nx2 = "
exTwo:	.asciiz	" x^2 + "
exOne:	.asciiz	" x + "
zer:	.asciiz	" = 0\n"
line:	.asciiz	"\n"

        .text

main:
	la	$a0, Title	#Standard affair of loading the title
	li	$v0, 4
	syscall 
	la	$a0, useOne	#print first prompt
	syscall
	li	$v0, 6		#parses first user input, answer stored in $f0
	syscall
	mov.s	$f4, $f0	#stores parsed input into $f4 from $f0
	la	$a0, useTwo	#print second prompt
	li	$v0, 4
	syscall
	li	$v0, 6		#parses second user input, answer stored in $f0
	syscall
	mov.s	$f5, $f0	#stores parsed input into $f5 from $f0
	la	$a0, useThr	#print third prompt
	li	$v0, 4
	syscall
	li	$v0, 6		#parses third user input, answer stored in $f0
	syscall
	mov.s	$f6, $f0	#stores parsed input into $f6 from $f0
	mov.s	$f12, $f4	#Moving from temp val register to f12 so we can print it
	li	$v0, 4
	la	$a0, line
	syscall
	li	$v0, 2		#Command to print out float
	syscall
	li	$v0, 4
	la	$a0, exTwo	#Print out x^2
	syscall
	mov.s	$f12, $f5	#Moving from temp val register to f12 so we can print it
	li	$v0, 2		#Command to print out float
	syscall
	li	$v0, 4
	la	$a0, exOne	#Print out x
	syscall
	mov.s	$f12, $f6	#Moving from temp val register to f12 so we can print it
	li	$v0, 2		#Command to print out float
	syscall
	li	$v0, 4
	la	$a0, zer	#Print out = 0
	syscall
	mov.s	$f12, $f4	#Storing our parsed inputs to the f registers hadnling arguments
	mov.s	$f13, $f5
	mov.s	$f14, $f6
	la	$a0, line
	syscall
				#Below will be setting up our return values used in quadreg
	jal	quadreg		#jump to quadreg and save position to $ra
				#v0 will be storing our return value for quadreg. This will then get compared and sent to the appropriate function
	beq	$v0, 0, quadNo
	beq	$v0, -1, imagCheck
	beq	$v0, 1, linearCheck
	beq	$v0, 2, quadCheck
quadNo:
	la	$a0, rtnZer	#Will print out that its not quadratic
	li	$v0, 4
	syscall
	la	$a0, line
	syscall
	b	end
imagCheck:
	la	$a0, rtnNeg	#Will print out that its imaginary
	li	$v0, 4
	syscall
	la	$a0, line
	syscall
	b	end
linearCheck:
	la	$a0, rtnOne	#Will print out that its linear
	li	$v0, 4
	syscall
	mov.s	$f12, $f0	#Move our argument into $f12 for printing
	li	$v0, 2
	syscall
	la	$a0, line
	li	$v0, 4
	syscall
	b	end
quadCheck:
	la	$a0, rtnTwo	#Will print out that its quadratic
	li	$v0, 4
	syscall
	mov.s	$f12, $f0	#Move our argument into $f12 for printing
	abs.s	$f12, $f12
	li	$v0, 2
	syscall
	la	$a0, rtnXTwo
	li	$v0, 4
	syscall
	mov.s	$f12, $f1	#Move our other argument into $f12 for printing
	abs.s	$f12, $f12
	li	$v0, 2
	syscall
	la	$a0, line
	li	$v0, 4
	syscall
	b 	end		#Terminate this garbo
          

#quadreg(float a, float b, float c)
#	Will solve for solutions, returns a status of 
#	-1: imaginary, 0: not quadratic, 1: one solution, and 2: two solutions
#float a =	$f12
#float b =	$f13
#float c =	$f14
#return status value = $v0
#return solution value = $f0, $f1
quadreg:
	addiu	$sp, $sp, -20	#Create room on stack
	sw	$ra, ($sp)	#save up all of our lovely values onto the stack
	swc1	$f20, 4($sp)
	swc1	$f21, 8($sp)
	swc1	$f22, 12($sp)
	swc1	$f23, 16($sp)
	mov.s	$f20, $f12	#Moving arguments to their new home
	mov.s	$f21, $f13
	mov.s	$f22, $f14
	li.s	$f23, 0.0	#put 0 into $f23. Will be used to compare a flag later
	li.s	$f9, 4.0	#put 4 into $f9. Will be used for multiplication later
	li.s	$f18, 2.0	#put 2 into $f18. Will be used later for multiplication
	c.eq.s	$f20, $f23	#setting to true if a is 0
	bc1t	ifA		#If it's true we branch to ifA
	mul.s	$f8, $f21, $f21	#Otherwise, we put b ^2 into f8
	mul.s	$f9, $f9, $f20	#multiply 4 and a, store into $f9
	mul.s	$f9, $f9, $f22	#multiply $f9 by c, store in $f9
	sub.s	$f8, $f8, $f9	#subtract our $f9 from b^2
	c.lt.s	$f8, $f23	#setting to true if a is less than 0
	bc1t	imaginary	#if it's true then it's imaginary
	mov.s	$f12, $f8	#Putting our answer into the argument address
	jal	sqrts		#jump to our homebrewed square root function
	mov.s	$f16, $f0
	neg.s	$f17, $f21	#set our b to be negative, store in $f17
	add.s	$f0, $f17, $f16	#negative b plus the sqrt of our equation
	sub.s	$f1, $f17, $f16	#negative b minus the sqrt of our equation
	mul.s	$f18, $f18, $f20#Take our 2 and multiply it by a
	div.s	$f0, $f0, $f18	#divide by our new product
	div.s	$f1, $f1, $f18
	li	$v0, 2		#return val 2
	b	endquadreg
imaginary:
	li	$v0, -1		#return val -1
	b	endquadreg
ifA:
	c.eq.s	$f21, $f23	#create flag if b is 0
	bc1t	ifB
	neg.s	$f10, $f22	#make c negative
	div.s	$f10, $f10, $f21#divide c and b
	li	$v0, 1		#return val 1
	mov.s	$f0, $f10	#load out x into $f0
	b	endquadreg
ifB:
	li	$v0, 0		#return val 0
endquadreg:
	lw	$ra, ($sp)	#Saving our registers
	lwc1	$f20, 4($sp)
	lwc1	$f21, 8($sp)
	lwc1	$f22, 12($sp)
	lwc1	$f23, 16($sp)
	addiu	$sp, $sp, 20	#Destory the stack
	jr	$ra		#Return from whence we came

#sqrts(float x)
#	Will find the square root of float x. Returns the answer
#float x =	$f12
#Storing 0 in	$f10
#Storing 2 in	$f9
#error value 	$f4
#root storage	$f0
sqrts:
	li.s	$f9, 2.0	#loading up 2, which we'll use later for division
	li.s	$f10, 0.0	#loading up 0
	li.s	$f4, 0.0000001	#loading our error value
	mov.s	$f5, $f12	#setting t to be x
	c.eq.s	$f5, $f10	#setting a flag. If x is 0, terminate and return 0
	bc1t	endW
while:
	div.s	$f6, $f12, $f5	#x divided by t
	sub.s	$f6, $f5, $f6	#t minus the quotient of x and t
	abs.s	$f6, $f6	#the absolute value of our minuend
	mul.s	$f7, $f4, $f5	#error value times t
	c.le.s	$f6, $f7	#if our value from that is less that error*t, we terminate the loop
	bc1t	endW
	div.s	$f8, $f12, $f5	#x divided by t
	add.s	$f8, $f8, $f5	#adding t to the quotient of x and t
	li.s	$f9, 2.0
	div.s	$f5, $f8, $f9	#Dividing that garbage by 2
	b	while
endW:
	mov.s	$f0, $f5	#Storing our answer into $f0
	jr	$ra		#Return from whence we came
end:
	li	$v0, 10		#syscall 10 to terminate program
	syscall