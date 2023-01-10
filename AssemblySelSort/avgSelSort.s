.data 

orig: .space 100	# In terms of bytes (25 elements * 4 bytes each)
sorted: .space 100
newline: .asciiz "\n"


str0: .asciiz "Enter the number of assignments (between 1 and 25): "
str1: .asciiz "Enter score: "
str2: .asciiz "Original scores: "
str3: .asciiz "Sorted scores (in descending order): "
str4: .asciiz "Enter the number of (lowest) scores to drop: "
str5: .asciiz "Average (rounded down) with dropped scores removed: "


.text 

# This is the main program.
# It first asks user to enter the number of assignments.
# It then asks user to input the scores, one at a time.
# It then calls selSort to perform selection sort.
# It then calls printArray twice to print out contents of the original and sorted scores.
# It then asks user to enter the number of (lowest) scores to drop.
# It then calls calcSum on the sorted array with the adjusted length (to account for dropped scores).
# It then prints out average score with the specified number of (lowest) scores dropped from the calculation.
main: 
	addi $sp, $sp -4
	sw $ra, 0($sp)
	li $v0, 4 
	la $a0, str0 
	syscall 
	li $v0, 5	# Read the number of scores from user
	syscall
	move $s0, $v0	# $s0 = numScores
	move $t0, $0
	la $s1, orig	# $s1 = orig
	la $s2, sorted	# $s2 = sorted
loop_in:
	li $v0, 4 
	la $a0, str1 
	syscall 
	sll $t1, $t0, 2
	add $t1, $t1, $s1
	li $v0, 5	# Read elements from user
	syscall
	sw $v0, 0($t1)
	addi $t0, $t0, 1
	bne $t0, $s0, loop_in
	
	move $a0, $s0
	jal selSort	# Call selSort to perform selection sort in original array
	
	li $v0, 4 
	la $a0, str2 
	syscall
	move $a0, $s1	# More efficient than la $a0, orig
	move $a1, $s0
	jal printArray	# Print original scores
	li $v0, 4 
	la $a0, str3 
	syscall 
	move $a0, $s2	# More efficient than la $a0, sorted
	jal printArray	# Print sorted scores
	
	li $v0, 4 
	la $a0, str4 
	syscall 
	li $v0, 5	# Read the number of (lowest) scores to drop
	syscall
	move $a1, $v0
	sub $a1, $s0, $a1	# numScores - drop
	move $a0, $s2
	jal calcSum	# Call calcSum to RECURSIVELY compute the sum of scores that are not dropped
	
	# Your code here to compute average and print it
	div $t2, $v0, $a1	# calcSum(sorted, numScores - drop)/(numScores - drop))
	
	li $v0, 4
	la $a0, str5
	syscall
	
	li $v0, 1
	move $a0, $t2
	syscall
	# end of my code
	
	lw $ra, 0($sp)
	addi $sp, $sp 4
	li $v0, 10 
	syscall
	
	
	
# printList takes in an array and its size as arguments. 
# It prints all the elements in one line with a newline at the end.
printArray:
	# Your implementation of printList here
	la $t3, ($a0)
	add $t4, $zero, $zero
	
	StartPrintArray:
	beq $t4, $a1, EndingPrintArray #if counter == len, go to EndingPrintArray
	lw $a0, 0($t3)
	addi $t3, $t3, 4 #move onto the next integer within the array

	li $v0, 1 #printing out the element we're "modifying"
	syscall
	
	li $a0, 32 #whitespace in ASCII
	li $v0, 11 #syscall number for printing character
	syscall
	
	addi $t4, $t4, 1 #incrementing within our for loop, t2 is going to +1 within the array
	j StartPrintArray

EndingPrintArray:
	li $v0, 4 #loading new line instruction
	la $a0, newline
	syscall
	
	jr $ra

# selSort takes in the number of scores as argument. 
# It performs SELECTION sort in descending order and populates the sorted array
selSort:
    # Your implementation of selSort here
    
    # $a0 = len
    # $s1 = orig
    # $s2 = sorted 
    add $t0, $zero, $zero #resetting t0, for a counter
    	FirstLoop:
	beq $t0, $a0, EndFirstLoop #if counter == the len, then exit out of this loop
	
	sll $t1, $t0, 2
	add $t1, $t1, $s1
	
	sll $t2, $t0, 2	 #increment address by using shifting, since it's 2^(number) 
	add $t2, $t2, $s2 #copying address of sortedArray onto t2
    
    	lw $t1, 0($t1) # $t1 = integer that was stored in address of $t1
    	sw $t1, 0($t2) # $t2 = integer that was stored in $t1, basically logic of sorted == orig
    
    	addi $t0, $t0, 1 #i++
    	j FirstLoop      

EndFirstLoop: #set up for loop for loop2
	add $t0, $zero,$zero 	# resetting counter
	subi $t3, $a0, 1	# len - 1 //Setup for our second for loop (inner loop)

OuterForLoop: 
	add $t1, $zero, $zero 	#For our inner for loop, setting up for j
	beq $t0, $t3, EndOuterForLoop	# if the counter is = to our length
	add $t4, $t0, $zero	# maxIndex = i
	
	
	#maxIndex == t4,,
	##at this point of the program, t0-t4 are being used:: t0 = i, t1 = j, t2 = sortedarray, t3 = len of array, t4 = maxindex
	
	#set up for inner for loop
	addi $t1, $t0, 1
	
	InnerForLoop:
		beq $t1, $a0, Swap	
		
		#if (sorted[j] > sorted[maxIndex])
		 sll $t5, $t1, 2 	#shifting so we can look at the next element
		 add $t5, $t5, $s2 	# (sorted[j])
		 lw $t5, 0($t5) 	# loading value in t5
		 
		 
		 #same logic to find sorted[maxindex]
		 sll $t6, $t4, 2 	# (maxIndex*4) to increment address
		 add $t6, $t6, $s2 	# (sorted[max_index])
		 lw $t6, 0($t6) 	# loading value in t6
		 
		 ble $t5, $t6, EndInnerForLoop  	# if (sorted[j] <= sorted[maxIndex]), 'exiting', so skipping 'maxIndex = j' line
		 add $t4, $t1, $zero 	# maxIndex = j 
		 
		 EndInnerForLoop:	    
		 	addi $t1, $t1, 1 # j++ (incrementing inner for-loop)
		 	j InnerForLoop
	
	Swap:
		#(1) temp = sorted[maxIndex];
		sll $t7, $t4, 2  	# (maxIndex * 4) to increment address
		add $t7, $t7, $s2 	# (address of sorted array) + (offset stored in $t7)
		lw $s4, 0($t7) 		# load value in sorted array ---> $s4 = sorted[maxIndex]
		add $t2, $s4, $zero 	# store retrieved value to temp 
		
		#(2) sorted[maxIndex] = sorted[i];
		sll $t8, $t0, 2 	# (i*4) to increment address
		add $t8, $s2, $t8 	# (address of sorted array) + (offset stored in $t8)
		lw $s5, 0($t8) 		# load value in sorted array ---> sorted[i] value copied onto $s5
		sw $s5, 0($t7) 		# copy value from $s5, and put it in sorted array  --> sorted[maxIndex] = $t7
		
		#(3) sorted[i] = temp;
		sw $t2, 0($t8) 		# temp value stored in $t8, so just copying it and storing it to sorted[i]
		
		addi $t0, $t0, 1 	# i++ (incrementing outer for-loop)
		j OuterForLoop
EndOuterForLoop:
     add $t1, $zero, $zero
     add $t2, $zero, $zero
     jr $ra
	
	
# calcSum takes in an array and its size as arguments.
# It RECURSIVELY computes and returns the sum of elements in the array.
# Note: you MUST NOT use iterative approach in this function.
calcSum:
	# Your implementation of calcSum here

	add $t0, $zero, $zero	#resetting to 0
	addi $sp, $sp, -8	# Push stack frame for local storage
	sw $ra, 0($sp)		# store address to return to
	sw $a1, 4($sp)
	addi $t9, $a1, -1	#set up input (len-1)
	
	Recursion:
		beq $t9, $zero, EndRecursion	# if (len <= 0)
	
		addi $t9, $t9, -1
		sll $t1, $t9, 2
		add $t1, $t1, $a0
		
		lw $t2, 0($t1)
		add $t0, $t0, $t2
	
		jal Recursion	
	
	EndRecursion: 
		lw $t9, 4($sp) 		#load original array size (len)
	
		subi $t9, $t9, 1
		sll $t9, $t9, 2 	# index increment ---> (len-1) * 4
		add $t9, $t9, $a0 	# ((len-1) * 4) + starting address of array
		lw $t4, 0($t9)		# $t4 = arr[len-1]
	
		add $v0, $t0, $t4 	# calSum() + arr[len - 1]
	
		#return 0 ///resetting the stack
		lw $a1, 4($sp)
		lw $ra, 0($sp)
		addi $sp, $sp, 8
		jr $ra
