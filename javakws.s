#       Homework:   #4
#       Due:        November 10, 2022
#       Course:     cs-2640-04-f22
#
#       Description:
#               Fourth homework - Takes use inputs, looks for words in the java library. Will print out the words, and where in the java file they exist.

        .data
Title:  .asciiz "Java Keywords by A. Urbany\n\n"
colon:  .asciiz ":"
n:      .asciiz "\n"
keywords:
	.word	abstract, assert, boolean, xbreak, byte, case, catch, char
	.word	class, const, continue, default, do, double, else, enum
	.word	extends, false, final, finally, float, for, goto, if
	.word	implements, import, instanceof, int, interface, long, native, new
	.word	null, package, private, protected, public, return, short, static
	.word	strictfp, super, switch, synchronized, this, throw, throws, transient
	.word	true, try, void, volatile, while
abstract:	.asciiz	"abstract"
assert:	.asciiz	"assert"
boolean:	.asciiz	"boolean"
xbreak:	.asciiz	"break"
byte:	.asciiz	"byte"
case:	.asciiz	"case"
catch:	.asciiz	"catch"
char:	.asciiz	"char"
class:	.asciiz	"class"
const:	.asciiz	"const"
continue:	.asciiz	"continue"
default:	.asciiz	"default"
do:	.asciiz	"do"
double:	.asciiz	"double"
else:	.asciiz	"else"
enum:	.asciiz	"enum"
extends:	.asciiz	"extends"
false:	.asciiz	"false"
final:	.asciiz	"final"
finally:	.asciiz	"finally"
float:	.asciiz	"float"
for:	.asciiz	"for"
goto:	.asciiz	"goto"
if:	.asciiz	"if"
implements:
	.asciiz	"implements"
import:	.asciiz	"import"
instanceof:
	.asciiz	"instanceof"
int:	.asciiz	"int"
interface:
	.asciiz	"interface"
long:	.asciiz	"long"
native:	.asciiz	"native"
new:	.asciiz	"new"
null:	.asciiz	"null"
package:	.asciiz	"package"
private:	.asciiz	"private"
protected:
	.asciiz	"protected"
public:	.asciiz	"public"
return:	.asciiz	"return"
short:	.asciiz	"short"
static:	.asciiz	"static"
strictfp:	.asciiz	"strictfp"
super:	.asciiz	"super"
switch:	.asciiz	"switch"
synchronized:
	.asciiz	"synchronized"
this:	.asciiz	"this"
throw:	.asciiz	"throw"
throws:	.asciiz	"throws"
transient:
	.asciiz	"transient"
true:	.asciiz	"true"
try:	.asciiz	"try"
void:	.asciiz	"void"
volatile:	.asciiz	"volatile"
while:	.asciiz	"while"

        .text
main:
        li      $a2, 53         #How many java key words there are + 1 extra 
        move	$s0, $a0        #How many arguments we have       
        move	$s1, $a1        #The array of arguments we have   
        addiu	$s1, $s1, 4	#Will skip the path to prevent it from printing 
        sub	$s0, $s0, 1       
        la      $a0, Title      #Standard affair of loading the title
        li      $v0, 4
        syscall                   
loop:	
        lw	$a0, ($s1)      #Will loop through and print out the arguments
        li	$v0, 4
        syscall                     
        move    $a1, $a0        
        la      $a0, keywords   #Takes the keywords and stores it in $a0  
        jal     lsearch             
        move    $s2, $v0        
        beq     $s2, $a2, endif #Once we reach the end of the array, we will go to endif                             
        la      $a0, colon
        li      $v0, 4
        syscall                  
        move    $a0, $s2
        li      $v0, 1          #This is what sets up $a0 to contain the java key word index to be printed
        syscall
        b       endif           #That's a wrap, we can terminate our program

strcmp:               
        move    $t1, $a0                
        move    $t2, $a1
        li      $t0, 0          #Counts how many times the forstr loop will increment   
forstr:
        lb      $t3, ($t1)      #Loads byte (character) into our "s" string represented in $t3        
        lb      $t4, ($t2)      #Loads byte (character) into our "t" string represented in $t4    
        bne     $t3, $t4, endfor#Loop will terminate once it realizes the characters are not the same       
        addi    $t0, $t0, 1         
        addi    $t1, $t1, 1         
        addi    $t2, $t2, 1     #These three addi's will increment either the characters, or the counter    
        bnez    $t3, forstr     #We loop if there's still more characters to go through    
        li      $v0, 0
        jr      $ra             #Get back to where we came from

lsearch:
        addiu   $sp, $sp, -20   #Making space in the stack      
        sw      $ra, 0($sp)
        sw      $s0, 4($sp)
        sw      $s1, 8($sp)
        sw      $s2, 12($sp)
        sw      $s3, 16($sp)
        sw      $s4, 20($sp)    #Shoving registers into the stack      
        li      $s0, 0          #by default this is set to not found (0). It will be set to 1 (found) if we find a match              
        li      $s1, 0          #Array we gotta get through     
        move    $s2, $a0            
        move    $s3, $a1            
        move    $s4, $a2            
whilesearch:
        bge     $s1, $s4, endsearch #If the index is greater than the length, we'll start our endsearch function   
        bnez    $s0, endsearch      #If the value is set to found, we'll start our endsearch function     
        lw      $a0, ($s2)      
        move    $a1, $s3            
        jal     strcmp           
        bnez    $v0, elseif         #If the compared strings are not the same, we increment the array's index and check the next word   
        li      $s0, 1              #If the word is found, we set the found value to 1, and we'll start our endsearch function 
        b       endsearch               
elseif:
        addi    $s1, $s1, 1         #Cycle through to next index value   
        addi    $s2, $s2, 4         #Cycle through to word 
        b       whilesearch         #go back to the search so we can rinse and repeat

endif:
        la		$a0, n
        li		$v0, 4         
        syscall                         
        addiu	$s1, $s1, 4             #Cycles through to next command line argument	       
        sub		$s0, $s0, 1     #Treating the arguments as the counter, will decrease with every loop
        bnez	$s0, loop               #Program will keep looping until the counter is 0
        b		end
endfor:  
        sub     $v0, $t3, $t4
        jr      $ra             #Get back to where we came from               
endsearch:
        move    $v0, $s1        #Index that will be returned
        lw      $s4, 20($sp)
        lw      $s3, 16($sp)
        lw      $s2, 12($sp)
        lw      $s1, 8($sp)
        lw      $s0, 4($sp)
        lw      $ra, 0($sp) 
        addiu   $sp, $sp, 20    #Cleaning up the stack
        jr      $ra             #Get back to where we came from
end:
        li      $v0, 10         #syscall 10 to terminate program
        syscall