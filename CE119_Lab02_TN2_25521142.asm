# 8, 5, 10, 0, 4, 7, 9, 4, 8, 0, 6, 5
.data
diem: .word 8, 5, 10, 0, 4, 7, 9, 4, 8, 0, 6, 5
grade_tab: .byte 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3
hist: .word 0, 0, 0, 0
n: .word  12
text1: .asciiz "min="
text2: .asciiz " max="
text3: .asciiz "\ng0="
text4: .asciiz " g1="
text5: .asciiz " g2="
text6: .asciiz " g3="
glabels: .word text3, text4, text5, text6

.text
main:
	#stats
	la $a0, diem
	lw $a1, n
	jal stats
	move $s0, $v0
	move $s1, $v1
	
	li $v0, 4
	la $a0, text1
	syscall
	li $v0, 1
	move $a0, $s0
	syscall
	li $v0, 4
	la $a0, text2
	syscall
	li $v0, 1
	move $a0, $s1
	syscall
	
	#histogram
	la $a0, diem
	lw $a1, n
	la $a2, grade_tab
	la $a3, hist
	jal histogram
	
	#g0, g1, g2, g3
	li $t0, 0
	la $s0, glabels
loops_output:
	slti $t1, $t0, 4
	beq $t1, $zero, exit_output
	
	sll $t2, $t0, 2
	add $t3, $t2, $s0
	lw $a0, 0($t3)
	li $v0, 4
	syscall
	
	add $t4, $t2, $a3
	lw $a0, 0($t4)
	li $v0, 1
	syscall
	
	addi $t0, $t0, 1
	j loops_output
exit_output:
	#ve bieu do phan pho diem draw_hist
	la $a0, hist
	li $a1, 4
	jal draw_hist
	
	li $v0, 10
	syscall

#thu tuc histogram
#tham so: $a0, $a1, $a2, $a3
#tra ve: khong co gia tri tra ve
#thanh ghi su dung: $t0, $t1, $t2, $t3, $t4, $t5, $t6	
histogram:
	li $t0, 0
loop_histogram:
	beq $t0, $a1, exit_histogram
	
	sll $t1, $t0, 2
	add $t1, $t1, $a0
	lw $t2, 0($t1)
	
	add $t3, $t2, $a2
	lbu $t4, 0($t3)
	
	sll $t5, $t4, 2
	add $t5, $t5, $a3
	lw $t6, 0($t5)
	
	addi $t6, $t6, 1
	sw $t6, 0($t5)
	
	addi $t0, $t0, 1
	j loop_histogram
exit_histogram:
	jr $ra
	
#thu tuc stats
#tham so: $a0, $a1
#tra ve: $v0, $v1
#thanh ghi su dung: $t0, $t1, $t2, $t3, $t4, $t5
stats:
	li $t0, 0	#i
	li $t1, 10	#min
	li $t2, 0	#max
loop_stats:
	beq $t0, $a1, exit_stats
	
	sll $t3, $t0, 2
	add $t3, $t3, $a0
	lw $t4, 0($t3)
	
	slt $t5, $t4, $t1
	beq $t5, $zero, check_max
	move $t1, $t4
	j next
check_max:
	slt $t5, $t2, $t4
	beq $t5, $zero, next
	move $t2, $t4
next:
	addi $t0, $t0, 1
	j loop_stats
exit_stats:
	move $v0, $t1
	move $v1, $t2
	jr $ra

#thu tuc draw_hist
#tham so: $a0, $a1
#tra ve: khong co
#thanh ghi su dung: $t0, $t1, $t2, $t3, $t4, $t5, $v0, $a0
draw_hist:
	move $t0, $a0	#dia chi hist
	move $t1, $a1	#so nhom
	li $t2, 0	#i = nhom hien tai
	li $v0, 11	#syscall in ky tu
loop_draw1:
	beq $t2, $t1, exit_draw
	
	li $a0, 10	#xuong dong
	syscall
	li $a0, 103	#ky tu g
	syscall
	addi $a0, $t2, 48 #'0' + i
	syscall
	li $a0, 58	#ky tu :
	syscall
	li $a0, 32	#khoang trong " "
	syscall
	
	sll $t3, $t2, 2
	add $t3, $t3, $t0
	lw $t4, 0($t3)	#so sinh vien cua nhom i
	
	li $t5, 0 	#index j
loop_draw2:
	beq $t5, $t4, next_group
	li $a0, 124	#'|'
	syscall		#syscall 11
	addi $t5, $t5, 1
	j loop_draw2
next_group:
	addi $t2, $t2, 1
	j loop_draw1
exit_draw:
	jr $ra
	
	
