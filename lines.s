#       Name:       Urbany, Alec 
#       Project:    #3 
#       Due:        November 3, 2022  
#       Course:     cs-2640-04-f22 
# 
#       Description: 
#               Third project - Takes 8 user inputs for strings, will print the user's input

        .data
Title:	.asciiz "Lines by A. Urbany\n\n"
Enter:	.asciiz "Enter text? "
MAXLINES: .word 8
LINELEN:.word   40
lines:	.space  40
inbuf:	.space  42 
n:		.asciiz	"\n"

        .text
main:
        li $v0, 4	 #Standard affair of loading the title
        la $a0, Title
        syscall
	li $t0, 0 	 #keeps track of loop iterations. Initializing it to zero
	lw $t1, MAXLINES #Setting up $t1 to be the max number of lines
	la $t2, lines 	 #Setting up $t2 to be lines
prompt:
        beq $t0, $t1, printSetup #Escape the loop once everything is finished
        la $a0, Enter
        li $v0,4         #Prints out the prompt
        syscall
        la $a0, inbuf    #Setting $a0 to be inbuf
        lw $a1, LINELEN  #Setting $a1 to be INELEN
        li $v0, 8        #li syscall 8, reads $a1 and puts it in $a0
        syscall
        jal strlen       #We now go to strlen to get the length
        beqz $v0, printSetup #once $v0 is zero, we move to setup the printing
        la $a0, inbuf    #Loading $a0 as inbuf
        jal strdup       #call strdup function. Uses strln and malloc to duplicate the string
        sw $v0, 0($t2)   #save returned duped string into $v0
        addi $t0, $t0, 1 #increment loop count by 1
        addi $t2, $t2, 4 #move to next address of lines array
        b prompt         #loop this baddie for how ever many lines we wish to copy
printSetup:
        la $t2, lines     #setting up $t2 to be lines
print:
        beqz $t0, end    #If $t0 = 0, then that's a wrap, we can now terminate the program
        lw $a0,0($t2)    #Load the string
        li $v0,4         #Print the string (classic MIPS maneuver)
        syscall
        la $a0, n        
        li $v0, 4        #Print the new line (whys is this so tedious)
        syscall
        addi $t0, $t0, -1 #decrease the counter
        addi $t2, $t2, 4 #cycle through the array
        b print          #Loop it!

strlen:
	li $v0,0		    #initialize register to return value of string
	move $a1,$a0        #moves $a0 (our string) into $a1
whilelength:
        lb $v1,0($a1)       #loads byte into t2 from address of $a1
        beqz $v1, endwhile  #End this once the counter is 0
        beq $v1, 10, endwhile #Prevents printing of newline characters
        addi $a1,$a1,1      #Incrementing the counter
        addi $v0,$v0,1
        b whilelength       #while there are still values, the function will loop

strdup:
        addiu $sp,$sp,-8    #making room in the stack
        sw $ra,0($sp)       #Storing our jump register for later use
        sw $a0,4($sp)       #Storing our string for later use
        jal strlen          #call strlen function
        addi $a0,$v0,1      #setting $a0 to be strlen + 1
        jal malloc          #calling malloc function
        addiu $v1,$v0,0     #setting $v1 to have the address of the string
        lw $a0,4($sp)       #pop the stack, get our string back
whiledup:
        lb $a1,0($a0)           #loading $a1 to be duped string element i
        sb $a1,0($v1)           #storing element i of the string
        beqz $a1, endWhileDup   #If we reach the end of $a1, function terminates
        beq $a1, 10, endWhileDup #This line will remove the printing of newline characters
        addi $a0,$a0,1          #incrementing through string
        addi $v1,$v1,1          #incrementing through duped string
        b whiledup              #loop it

malloc:
        li $v0,9    	#syscall 9 to allocate memory
        syscall
        jr $ra      	#Return to whence we came

endWhileDup:
        sb $0,0($v1)    #erasing last location of the string. This also prevents the printing of a newline
        lw $ra,0($sp)   #get back value of ra from stack
        addiu $sp,$sp,8 #reset the address of stack
endwhile:
        jr $ra      #Uses JR to return to wherever $ra is. This makes this section universal. Thanks JAL

end:
	li $v0,10   #syscall 10 to terminate program
	syscall