.data 



orig: .space 100	# In terms of bytes (25 elements * 4 bytes each)

sorted: .space 100



str0: .asciiz "\nEnter the number of assignments (between 1 and 25): "

str1: .asciiz "Enter score: "

str2: .asciiz "Original scores: "

str3: .asciiz "\nSorted scores (in descending order): "

str4: .asciiz "\nEnter the number of (lowest) scores to drop: "

str5: .asciiz "Average (rounded down) with dropped scores removed: "



space: .asciiz " "



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

	li $v0, 4 

	la $a0, str5 

	syscall

	div $a0, $v0, $a1

	li $v0, 1

	syscall

	

	lw $ra, 0($sp)

	addi $sp, $sp 4

	li $v0, 10 

	syscall

	

	

# printList takes in an array and its size as arguments. 

# It prints all the elements in one line with a newline at the end.

printArray:

        # Your implementation of printList here    

        # $s0 is the length (numScores)

        

        move $t1, $a0

        li $t0, 0    # initialize i to 0

        

        #loop through the array to print the elements

loop:

        beq $t0, $s0, endloop     # check if we have reached the end of the array

        lw $a0, 0($t1)         # load $a0 with value at $t1

           li $v0, 1        # system call code for print integer

        syscall

        li $v0, 4 

        la $a0, space 

        syscall

        

        addi $t1, $t1, 4    #go to next element

        addi $t0, $t0, 1    #increment i

        j loop

    

endloop:

    #li $v0, 4

    #la $a0, orig

        jr $ra

               

# selSort takes in the number of scores as argument. 

# It performs SELECTION sort in descending order and populates the sorted array

selSort:

	add $s3, $s3, $zero

firstLoop: 

	#copying original array into sorted array

	beq $s3, $s0, endFirst # i < len

	la $t0, 0($s1)
	sw $t0, 0($s2)
	
	addi $t0, $t0, 4


	

        addi $s3, $s3, 1    #increment i

        j firstLoop

endFirst:

	move $s3, $zero #i index reset

	addi $t3, $s0, -1 #t = len - 1

secondLoop:
	
	add $s4, $zero, $zero
	
	beq $s3, $t3, breakLoops #i < len. if equal we've gone through both for loops

	move $s6, $s3 #maxIndex = i
	
	addi $s4, $s3, 1 #j = i + 1
	


nestedLoop:

	beq $s4, $s0, endNested #j < len. if equal we've gone through the inner for loop

maxCheck:


	sll $t5, $s4, 2

	add $t5, $t5, $s2
	
	lw $t5, 0($t5)

 #calculating sorted[maxIndex]

	sll $t6, $s6, 2

	add $t6, $t6, $s2

	lw $t6, 0($t6)

	blt $t5, $t6, nestedIterate #if its less than we dont do anything and just iterate j

	move $s6, $s4 #otherwise maxIndex = j

nestedIterate:

	addi $s4, $s4, 1 #j++

	j nestedLoop

endNested:


	sll $t7, $s6, 2  #moving/incrementing max_index (basically max_index * 4)

	add $t7, $t7, $s2 

	lw $s7, 0($t7)
	
	add $s5, $s7, $zero #store retrieved value to temp

	 #calculating sorted[i]

	sll $t8, $s3, 2

	add $t8, $s2, $t8

	lw $t9, 0($t8)
	
	sw $t9, 0($t7)

	sw $s5, 0($t8)


	addi $s3, $s3, 1
	j secondLoop

breakLoops:

	jr $ra

	

	

# selSort takes in the number of scores as argument. 

# It performs SELECTION sort in descending order and populates the sorted array

	

# calcSum takes in an array and its size as arguments.

# It RECURSIVELY computes and returns the sum of elements in the array.

# Note: you MUST NOT use iterative approach in this function.	

calcSum:

    	# Your implementation of calcSum here

     

    	#s2 = address of our sorted array

    	

	# Push stack frame for local storage

    	addi $sp, $sp, -12 

    	sw $ra, 0($sp) 

    	sw $a1, 4($sp)			# length after drop

    	sw $s2, 8($sp)			# sorted array

    	

    	# Implement if statement if true

    	ble $a1, $zero, endIf

    	

    	# do recursion if not true

    	add $a1, $a1, -1		# len = len - 1

    	jal calcSum			# do recursion call 

    	move $s2, $v0



    	sll $t1, $a1, 2

    	add $t1, $t1, $a0 		# get sorted array

    	lw $t3, 0($t1)			# implement index where [len-1]



    	add $v0, $s2, $t3		# result

    	j end



endIf:

    	add $v0, $zero, $zero # return 0

    	j end # go to End



end:

	# restore registers

    	lw $ra, 0($sp) 

    	lw $a1, 4($sp)

    	lw $s2, 8($sp)

    	addi $sp, $sp, 12		# pop stack

    	

    	# return to calling function

    	jr $ra

    	
