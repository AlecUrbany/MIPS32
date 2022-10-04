#       Name:       Urbany, Alec 
#       Project:    #1 
#       Due:        October 6, 2022  
#       Course:     cs-2640-04-f22 
# 
#       Description: 
#               First project - converts a number into a specified amount of coins

        .data
Title:  .asciiz "Change by A. Urbany\n\n"
Enter:  .asciiz "Enter the change\n\n"
Q:      .asciiz "Quater: "
D:      .asciiz "\nDime: "
N:      .asciiz "\nNickel: "
P:      .asciiz "\nPenny: "

        .text
main:
        li  $v0, 4
        la  $a0, Title
        syscall
        li  $v0, 4
        la  $a0, Enter  #Displaying the prompt to enter the amount of change for the user
        syscall
        li  $v0, 5      #This is what parses the user's input for change    
        syscall
        move $t0, $v0
        jal Quarter
        
Quarter:
                        #Start of the quarter section. We divide the user input by 25.
                        #The remainder is sent to the next section to be Mod by the next coin
        li $s1, 25
        div $t0, $s1
        mfhi $t1
        mflo $t2
        beqz $t2, Dime
                        #if the qotient is 0, then we move to dime without printing quarter
        li  $v0, 4
        la $a0, Q
        syscall
        li  $v0, 1
        move $a0, $t2   #As we have no use for the user's starting number, it gets replaced with the remainder
        syscall
        beqz $t1, end
        jal Dime
Dime:
                        #Start of the dime section. Same logic applies here.
                        #Mod by 10 and send the remainder down a step
        li $s2, 10 
        div $t1, $s2
        mfhi $t1
        mflo $t2
        beqz $t2, Nickel
                        #if the qotient isn't 0, then we print out quater before moving to Dime
        li  $v0, 4
        la $a0, D
        syscall
        li  $v0, 1
        move $a0, $t2   #As we have no use for the user's starting number, it gets replaced with the remainder
        syscall
        beqz $t1, end
        jal Nickel

Nickel:
                        #Start of the nickel section. Rinse and repeat - divide by 5, send remainder to next
        li $s3, 5
        div $t1, $s3
        mfhi $t1
        mflo $t2
        beqz $t2, Penny
                        #if the qotient isn't 0, then we print out quater before moving to Penny
        li  $v0, 4
        la $a0, N
        syscall
        li  $v0, 1
        move $a0, $t2   #As we have no use for the user's starting number, it gets replaced with the remainder
        syscall
        beqz $t1, end
        jal Penny

Penny:
                        #Last section - pennys. Mod by 1 and take the result.
        li $s4, 1
        div $t1, $s4
        mfhi $t1
        mflo $t2
        beqz $t2, end
                        #if the qotient isn't 0, then we print out quater before moving to Penny
        li  $v0, 4
        la $a0, P
        syscall
        li  $v0, 1
        move $a0, $t2   #As we have no use for the user's starting number, it gets replaced with the remainder
        syscall
        beqz $t1, end


end:
        li  $v0, 10
        syscall 