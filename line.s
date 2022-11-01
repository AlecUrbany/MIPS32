#       Name:       Urbany, Alec 
#       Homework:    #3 
#       Due:        November 1, 2022  
#       Course:     cs-2640-04-f22 
# 
#       Description: 
#               Third Homework - Takes user input for a string, will print out string length and the user's input

        .data
Title:  .asciiz "String by A. Urbany\n\n"
Enter:  .asciiz "Enter text? "
str1:	.space  40
str2:	.space	40
n:	.asciiz	"\n"
colon:	.asciiz	":"

        .text
main:
        li $v0, 4
        la $a0, Title
        syscall
        la $a0, Enter   #Displaying the prompt to enter a string
        syscall
        li $v0, 8       #This is what parses the user's input   
        la $a0,str1     #loading address of string 1
	li $a1,41       #Buffer of 40 characters + 1 extra (for the newline). This also limits the user's input to only 40 chars.
        syscall
        jal strlen
        move $t1, $v0	#after the strlen while loop ends, we come back to our main function. We then store the strlength into $t1
	la $a1, str2    #loading string 2's address into $a1
        la $a0,str1     #reloading string 1 into $a0 so we can copy it
        jal strdup
        li $v0,4	#prepping to print newline
	la $a0,n
        jal length	#now that the string is in str2, we can print the length
	li $v0,4	#prepping to print colon
	la $a0,colon
	syscall
        la $a0,str2
	jal clone
        syscall	
        b end           #That's a wrap, we can now terminate the program
strlen:
	li $v0,0	#initialize register to return value of string
	li $t2,0	#will be used to compare the array and terminate the while loop
	move $t0,$a0    #moves $a0 (our string1) into $t0
whilelength:
	lb $t2, ($t0)   #loads byte into t2 from address of $t0
	beqz $t2, endwhile
	addi $v0, $v0, 1
	addi $t0, $t0, 1
	b whilelength   #while there are still values, the function will loop
strdup:
	li	$t3,0   #initialize our register. This will be the home for our newly duplicated array
	move 	$t4,$a0	#$t4 becomes str1
	move	$t5,$a1	#$t5 becomes str2
whiledup:
	lb $t3,($t4)    #Loading a byte from $t3 (our str1) into $t3 (our str2)
	sb $t3,($t5)    #Storing byte from $t5 into $t3 (our str2)
	beqz $t3,endwhile       #If the string value is 0, that means our job is done
	addi $t4,$t4,1  #increments array value
	addi $t5,$t5,1  #increments array value
	b whiledup      #while there are still array values to duplicate, it loops\
length:
        li $v0,1        #classic command to prep mips to print an int
	move $a0,$t1    #moving our newly stored strlength value into $t1
	syscall
	jr $ra          #snap back to where we should be in the main function
clone:	
	li	$t2,0 
	move	$t6,$a0 #$t6 will be storing str2
whileclone:
        beqz $t2,endwhile
        lb $t2,($t6)
	addi $t6,$t6,1
	li $v0,11       #setting up mips to print chars
	move $a0,$t2
	syscall	
	b whileclone    #so long as we're printing characters, it loops
endwhile:
        jr $ra  #Uses JR to return to wherever $ra is. This makes this section universal. Thanks JAL
end:
        li  $v0, 10
        syscall 