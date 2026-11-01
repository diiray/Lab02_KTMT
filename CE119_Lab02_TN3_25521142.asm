.data
s1: .asciiz "(a+b)*[c-{d/e}]"
s2: .asciiz "f(x[i]{j}))"
s3: .asciiz "{[(])}"
s4: .asciiz "((a)"
s5: .asciiz ""
s6: .asciiz "no brackets here"
s7: .asciiz "]"
s8: .asciiz "([)]"
sCN: .asciiz "([{([])}])"
.align 2
space: .asciiz ", "



.text

#thu tuc: main
#tham so: khong co
#tra ve: khong co
#thanh ghi su dung: $a0, $v0, $v1, $s2
main:
	la $a0, sCN
	jal check_brackets
	move $s2, $v1
	move $a0, $v0
	li $v0, 1	#in vi tri
	syscall
	li $v0, 4
	la $a0, space
	syscall
	li $v0, 1
	move $a0, $s2	#in ma loi
	syscall
	
	li $v0, 10
	syscall

#thu tuc check_brackets
#Tham so: $a0
#tra ve: $v0 (vi tri), $v1 (ma loi)
#thanh ghi su dung: $t0, $t1, $t2, $t3, $t4, $t5
check_brackets:
	move $t0, $sp	#luu $sp
	move $t1, $a0	#luu dia chi chuoi
	li $t2, 0	#luu so ky tu da xet
cb_loop:
	lbu $t3, 0($t1)
	beq $t3, $zero, cb_endstr	#xet null
	
	addi $t2, $t2, 1
	addi $t1, $t1, 1
	
	li $t4, 40
	beq $t3, $t4, cb_tronmo
	
	li $t4, 91
	beq $t3, $t4, cb_vuongmo
	
	li $t4, 123
	beq $t3, $t4, cb_mocmo
	
	li $t4, 41
	beq $t3, $t4, cb_dong
	
	li $t4, 93
	beq $t3, $t4, cb_dong
	
	li $t4, 125
	beq $t3, $t4, cb_dong
	j cb_loop
	
cb_tronmo:
	li $t4, 41	#luu lai ngoac dong de bo vo stack
	j cb_push
cb_vuongmo:
	li $t4, 93
	j cb_push
cb_mocmo:
	li $t4, 125
cb_push:
	addi $sp, $sp, -4
	sw $t4, 0($sp)
	j cb_loop
cb_dong:
	beq $sp, $t0, cb_err2
	lw $t5, 0($sp)
	addi $sp, $sp, 4
	bne $t5, $t3, cb_err1
	j cb_loop
cb_err2:	
	move $v0, $t2
	li $v1, 2
	move $sp, $t0
	jr $ra
cb_err1:
	move $v0, $t2
	li $v1, 1
	move $sp, $t0
	jr $ra
cb_endstr:
	beq $sp, $t0, cb_ok
	addi $v0, $t2, 1
	li $v1, 3
	move $sp, $t0
	jr $ra
cb_ok:
	li $v0, 0
	li $v1, 0
	jr $ra
	
	
	
	
	
	
	
	
	
	
	
	
	
