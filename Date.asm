Date:
	addi $t0, $zero, 10 # So 10.
	#Xu ly ngay.
	div $a0, $t0 # Tach ngay thanh 2 chu so.
	mflo $t1 # Phan nguyen.
	addi $t1, $t1, 48 # Doi sang ki tu.	
	sb $t1, 0($a3) # Luu vao ram.
	mfhi $t1 # Phan du.
	addi $t1, $t1, 48
	sb $t1, 1($a3)
	addi $t1, $zero, 47 # Dau /
	sb $t1, 2($a3)
	
	
	#Xu ly thang
	div $a1, $t0 # Tach thang thanh 2 chu so.
	mflo $t1 # Phan nguyen.
	addi $t1, $t1, 48 # Doi sang ki tu.
	sb $t1, 3($a3) # Luu vao ram.
	mfhi $t1 # Phan du.
	addi $t1, $t1, 48
	sb $t1, 4($a3)
	addi $t1, $zero, 47 # Dau /
	sb $t1, 5($a3)

	#Xu ly nam
	add $t2, $zero, $a3
	addi $t2, $t2, 9 # Vi tri cuoi chuoi time.
while_date_positive:
	slt $t1, $zero, $a2
	beq $t1, $zero, end_while_date_positive
	div $a2, $t0 # Tinh phan du khi chia 10.
	mfhi $t1 # Lay phan du.
	addi $t1, $t1, 48
	sb $t1, 0($t2)
	addi $t2, $t2, -1
	mflo $a2 # Phan nguyen con lai.
	j while_date_positive
end_while_date_positive:	
	addi $v0, $a3, 0
	jr $ra