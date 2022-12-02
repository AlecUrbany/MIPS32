#       Name:       Urbany, Alec 
#       Project:    #4 
#       Due:        December 1, 2022  
#       Course:     cs-2640-04-f22 
# 
#       Description: 
#               Fourth project - Prints contents of a periodic table file

        .data
Title:	.asciiz "Elements by A. Urbany\n\n"
ptfname:    .asciiz "C:/Users/Pops/Desktop/enames.dat"
buf:    .space  64
head:   .word   0
elements: .asciiz " Elements. \n"
line:   .asciiz	"\n"

        .text

main:
	la      $a0, Title      #Standard affair of loading the title
	li      $v0, 4
	syscall 
	la	$a0, ptfname
	jal	open		#jump to open function, will open the file.
	move	$s0, $v0		# save fd in s0
	lw	$s1, head   	#use head to initialize $s1
loop:	# to read a string
	move    $a0, $s0	#File stored in $a0
	la	$a1, buf	#load the buffer into $a1
	jal fgetln		#Get the line
	lb	$s2,($a1)	#now we store our buffer into $s2
	beq	$s2, '\n', endloop	#Once we reach a newline, we terminate the loop
	addi	$s4,$s4,1	#counter, will increment by 1 each loop
	move    $a0, $a1	#buffer value is moved into $a0
	jal strdup	#duplicate the string
	move    $a0, $v0	#storage is now put into $a0
	move    $a1, $s1	#linked list head is put into the next function
	jal     getnode		#Get the node
	move    $s1, $v0	#take address of our array, move it into $s1's array
	b	loop 		#loop it!

strlen:
	li	$v0, 0
	move    $a1, $a0
while:
	lb 	$v1, ($a1)  	#loads value from array to $a1
	beqz    $v1, endwhile
	addi    $a1, $a1, 1
	addi    $v0, $v0, 1
	b   while

strdup:
	addiu 	$sp, $sp,-12	#Allocate stack 
	sw 	$ra, 0($sp)  	#Saving position of RA
	sw 	$s3, 4($sp)	#saving the s registers
	sw 	$s4, 8($sp)	#saving the s registers
	move	$s3, $a0	
	jal 	strlen 
	addi 	$a0, $v0, 1	#return vlaue of string length. Increments by 1
	jal 	malloc
	move 	$s4, $v0 	#address of the new memory
	move	$a0, $s3
whiledup:
    lb	$a1,0($a0)           	#loading $a1 to be duped string element i
    beqz	$a1, endWhileDup	#If we reach the end of $a1, function terminates
    beq	$a1, 10, endWhileDup 	#This line will remove the printing of newline characters
    sb 	$a1,0($s4)
    addiu	$a0,$a0,1       #incrementing through string
    addiu	$s4,$s4,1       #incrementing through duped string
    b	whiledup              	#loop it

print: 
	li 	$v0,4		#load argument to print
	syscall
	la	$a0, line	#Print out a new line
	syscall
	jr	$ra

traverse: 
	addi	$sp,$sp, -8	#allocate space on stack
	sw	$ra, 0($sp)	#Save $ra for later
	sw	$a0, 4($sp)	#save $a0 as the head of our list
	beqz	$a0, endtrav	#once we reach zero, we will end our traversal
	lw	$a0,4($a0)	#loads up value and increments 
	jal	traverse
	lw	$a0, 4($sp)	#load up our new node from the stack. Will be our head node
	lw	$a0, 0($a0)
	jalr    $a1		#links address in $a1 - the print function. 
endtrav:
	lw	$ra, 0($sp)	#load return for the previous nonleaf node.
	addi	$sp,$sp,8	#Close out the stack
	jr	$ra		#Return from whence we came


malloc:
	addiu	$a0, $a0, 3
	srl	$a0, $a0, 2
	sll	$a0, $a0, 2	#These 3 functions just cleaned up malloc to make sure it works with words	
	li	$v0,9    	#syscall 9 to allocate memory
	syscall
	jr	$ra      	#Return to whence we came


fgetln:	move	$t0, $a1	# save a1
	li	$a2, 1		# 1 byte at a time

do1:	li	$v0, 14
	syscall
	lb 	$t1, ($a1)
	addiu 	$a1, $a1, 1
	bne 	$t1, '\n', do1
	sb 	$zero, ($a1)	# null byte
	move	$a1, $t0	# restore a1
	jr	$ra

open:	li	$a1, 0
	li	$a2, 0
	li	$v0, 13
	syscall
	jr	$ra

close:
	li 	$v0, 16
	syscall
	jr	$ra

getnode:
	addiu	$sp, $sp, -12	#make room on the stack
	sw	$a0, 0($sp)	#the string is stored at 0
	sw	$a1, 4($sp)	#the head is stored at 4
	sw	$ra, 8($sp)	#the return register is storaed at 8

	li	$a0, 8		#load arg 8 for malloc
	jal	malloc		#call malloc

	lw	$a0, 0($sp)	#begin restoring things from our stack
	lw	$a1, 4($sp)

	sw	$a0, 0($v0)	#begin storing the information into the v registers
	sw	$a1, 4($v0)

	lw	$ra, 8($sp)
	addiu	$sp, $sp, 12

	jr	$ra		#return from where we came

endloop:
	move    $a0, $s0	
	jal	close   	#For the sake of being tidy, we close the file
	move	$a0,$s4
	li	$v0,1 
	syscall
	la	$a0, elements  	#Load up the elements' addresses
	li 	$v0,4		#print 'em
	syscall
	la	$a0, line	#print a new line
	syscall
	move    $a0, $s1
	la	$a1, print  	#loading address of print so we can call it without having to jal to print
	jal	traverse	#jump to traverse
	b	end		#After all is said and done, we can terminate our program
    
endwhile:
	addi	$v0,$v0,-1
	jr	$ra

endWhileDup:
	lw 	$ra, 0($sp)	#loading ra
	lw 	$s3, 4($sp) 	#loading s registers
	lw 	$s4, 8($sp) 	#loading s registers
	addiu 	$sp,$sp, 12 	#cleaning up the stack
	jr 	$ra 

end:
	li	$v0,10   	#syscall 10 to terminate program
	syscall
