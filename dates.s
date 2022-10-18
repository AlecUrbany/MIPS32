#       Name:       Urbany, Alec 
#       Project:    #2 
#       Due:        October 20, 2022  
#       Course:     cs-2640-04-f22 
# 
#       Description: 
#               Second project - Takes user input for M/D/Y/. Prints out the date, day, and whether it's a leap year.

        .data
Title:  .asciiz "Dates by A. Urbany\n\n"
Month:  .asciiz "Enter the month? "
Day:    .asciiz "Enter the day? "
Year:   .asciiz "Enter the year? "
Leap:   .asciiz " is a leap year "
NLeap:  .asciiz " is not a leap year "
Mon:    .asciiz " is a Monday."
Tues:   .asciiz " is a Tuesday."
Wed:    .asciiz " is a Wednesday."
Thurs:  .asciiz " is a Thursday."
Fri:    .asciiz " is a Friday."
Sat:    .asciiz " is a Saturday."
Sun:    .asciiz " is a Sunday."
Slash:  .asciiz "/"
And:    .asciiz "and "

        .text
main:
                        #Month Section
        li  $v0, 4
        la  $a0, Title  #Setting up v0 to take in a0. a0 holds the title ascii text
        syscall
        la  $a0, Month  #putting month in $a0 to print out the first prompt for month
        syscall
        li  $v0, 5      #This is what parses the user's input for month 
        syscall
        move $t0, $v0   #Storing the value of the user's input into a temp register
                        #Day Section
        li  $v0, 4
        la  $a0, Day    #putting month in $a0 to print out the first prompt for day
        syscall
        li  $v0, 5      #This is what parses the user's input for month 
        syscall
        move $t1, $v0   #Storing the value of the user's input into a temp register
                        #Year Section
        li  $v0, 4
        la  $a0, Year   #putting month in $a0 to print out the first prompt for month
        syscall
        li  $v0, 5      #This is what parses the user's input for month 
        syscall
        move $t2, $v0   #Storing the value of the user's input into a temp register

a:
                        #This will be to solve "a" in the Gregorian calendar calculation
        li $t3, 14      #Storing value of 14 into $t3, this is so we can use $t3 to store the difference later 
        sub $t3, $t3, $t0  #Subtracting 14 and the month. Storing the answer in $t3
        div $t3, $t3, 12
        mflo $t3        #a is now $t3
y:
                        #This will be to solve "y" in the Gregorian calendar calculation
        sub $t4, $t2, $t3   #y is now $t4
m:
                        #This will be to solve "m" in the Gregorian calendar calculation
        mul $t5, $t3, 12       #Storing the product of 12a
        add $t5, $t0, $t5
        sub $t5, $t5, 2      #m is now $t5
d:
                        #This will be to solve "d" in the Gregorian calendar calculation
        add $t6, $t1, $t4
        div $t7, $t4, 4    #Dividing y by 4. We will then add this to our previous addition
        add $t6, $t6, $t7 
        div $t7, $t4, 100    #Dividing y by 100. We will then add this to our previous addition
        sub $t6, $t6, $t7 
        div $t7, $t4, 400    #Dividing y by 400. We will then add this to our previous addition
        add $t6, $t6, $t7 
        mul $t7, $t5, 31
        div $t7, $t7, 12    #Dividing 31m by 12. We will then add this to our previous addition
        add $t6, $t6, $t7 
        rem $t6, $t6, 7
                        #We load integer values that we will use later to divide (it will also be used to calculate whether it's a leap year)
        li $t3, 4
        li $t4, 100
        li $t5, 400
calc:
                        #This will figure out whether or not it's a leap year
        div $t2, $t3    #Divide the year by 4, store the answer back where 4 was stored
        mfhi $t3
        div $t2, $t4    #Divide the year by 100, store the answer back where 100 was stored
        mfhi $t4
        div $t2, $t5    #Divide the year by 400, store the answer back where 400 was stored
        mfhi $t5
        beqz $t3, YLeap   
Mill: 
        li $t4, 1       #Giving the register $t4 a value so it doesn't loop infintely
        beqz $t5, YLeap #If it is equal to zero, then that means year is divisible by 4 and not divisible by 100 
        bnez $t5, Norm
Norm:
                        #If it's not a leap year, we print out the year + our NLeap phrase
        li $v0, 1
        move $a0, $t2
        syscall
        li  $v0, 4
        la  $a0, NLeap
        syscall
        b Name

YLeap:
        beqz $t4, Mill  #If it can be divided by 100, there's still a chance it's a leap year on the turn of the millenium
                        #If it is a leap year, we print out the year + our Leap phrase
        li $v0, 1
        move $a0, $t2
        syscall
        li  $v0, 4
        la  $a0, Leap
        syscall
        b Name

Name:    
        beqz $t6, Sunday
        beq $t6, 1, Monday
        beq $t6, 2, Tuesday
        beq $t6, 3, Wednesday
        beq $t6, 4, Thursday
        beq $t6, 5, Friday
        beq $t6, 6, Saturday

Sunday:
        li  $v0, 4
        la  $a0, And    #Printing the word And
        syscall
        li $v0, 1       #Printing out the Month
        move $a0, $t0
        syscall
        li  $v0, 4
        la  $a0, Slash    #Printing the /
        syscall
        li $v0, 1       #Printing out the Month
        move $a0, $t1
        syscall
        li  $v0, 4
        la  $a0, Slash    #Printing the /
        syscall
        li $v0, 1       #Printing out the Year
        move $a0, $t2
        syscall
        li  $v0, 4
        la  $a0, Sun    #Printing the day
        syscall
        b end
Monday:
        li  $v0, 4
        la  $a0, And    #Printing the word And
        syscall
        li $v0, 1       #Printing out the Month
        move $a0, $t0
        syscall
        li  $v0, 4
        la  $a0, Slash    #Printing the /
        syscall
        li $v0, 1       #Printing out the Month
        move $a0, $t1
        syscall
        li  $v0, 4
        la  $a0, Slash    #Printing the /
        syscall
        li $v0, 1       #Printing out the Year
        move $a0, $t2
        syscall
        li  $v0, 4
        la  $a0, Mon    #Printing the day
        syscall
        b end
Tuesday:
        li  $v0, 4
        la  $a0, And    #Printing the word And
        syscall
        li $v0, 1       #Printing out the Month
        move $a0, $t0
        syscall
        li  $v0, 4
        la  $a0, Slash    #Printing the /
        syscall
        li $v0, 1       #Printing out the Month
        move $a0, $t1
        syscall
        li  $v0, 4
        la  $a0, Slash    #Printing the /
        syscall
        li $v0, 1       #Printing out the Year
        move $a0, $t2
        syscall
        li  $v0, 4
        la  $a0, Tues    #Printing the day
        syscall
        b end
Wednesday:
        li  $v0, 4
        la  $a0, And    #Printing the word And
        syscall
        li $v0, 1       #Printing out the Month
        move $a0, $t0
        syscall
        li  $v0, 4
        la  $a0, Slash    #Printing the /
        syscall
        li $v0, 1       #Printing out the Month
        move $a0, $t1
        syscall
        li  $v0, 4
        la  $a0, Slash    #Printing the /
        syscall
        li $v0, 1       #Printing out the Year
        move $a0, $t2
        syscall
        li  $v0, 4
        la  $a0, Wed    #Printing the day
        syscall
        b end
Thursday:
        li  $v0, 4
        la  $a0, And    #Printing the word And
        syscall
        li $v0, 1       #Printing out the Month
        move $a0, $t0
        syscall
        li  $v0, 4
        la  $a0, Slash    #Printing the /
        syscall
        li $v0, 1       #Printing out the Month
        move $a0, $t1
        syscall
        li  $v0, 4
        la  $a0, Slash    #Printing the /
        syscall
        li $v0, 1       #Printing out the Year
        move $a0, $t2
        syscall
        li  $v0, 4
        la  $a0, Thurs    #Printing the day
        syscall
        b end
Friday:
        li  $v0, 4
        la  $a0, And    #Printing the word And
        syscall
        li $v0, 1       #Printing out the Month
        move $a0, $t0
        syscall
        li  $v0, 4
        la  $a0, Slash    #Printing the /
        syscall
        li $v0, 1       #Printing out the Month
        move $a0, $t1
        syscall
        li  $v0, 4
        la  $a0, Slash    #Printing the /
        syscall
        li $v0, 1       #Printing out the Year
        move $a0, $t2
        syscall
        li  $v0, 4
        la  $a0, Fri    #Printing the day
        syscall
        b end
Saturday:
        li  $v0, 4
        la  $a0, And    #Printing the word And
        syscall
        li $v0, 1       #Printing out the Month
        move $a0, $t0
        syscall
        li  $v0, 4
        la  $a0, Slash    #Printing the /
        syscall
        li $v0, 1       #Printing out the Month
        move $a0, $t1
        syscall
        li  $v0, 4
        la  $a0, Slash    #Printing the /
        syscall
        li $v0, 1       #Printing out the Year
        move $a0, $t2
        syscall
        li  $v0, 4
        la  $a0, Sat    #Printing the day
        syscall
end:
        li  $v0, 10
        syscall         #Termination of the program