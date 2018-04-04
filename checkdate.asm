
# Kiem tra tinh hop le cua Date
# Tham so :
#	a0: ngay
#	a1: thang
#	a2: nam
# Tra ve : 
#	v0: 1 (true) hoac 0 (false)
checkdate:
	
	addi $t9, $0, 9999
	slt $t0, $t9, $a2
	bne $t0, $0, checkdate_false	# if (year > 9999) return false

	addi $t2, $0, 12
	slt $t0, $t2, $a1
	bne $t0, $0, checkdate_false	# if (month > 12) return false
	beq $a1, $0, checkdate_false	# if (month == 0) return false
	
	beq $a0, $0, checkdate_false	# if (day == 0) return false
	
	# if (month in 4,6,9,11) goto 30
	addi $t0, $0, 4
	beq $a1, $t0, checkdate_30
	addi $t0, $0, 6
	beq $a1, $t0, checkdate_30
	addi $t0, $0, 9
	beq $a1, $t0, checkdate_30
	addi $t0, $0, 11
	beq $a1, $t0, checkdate_30
	
	addi $t0, $0, 2
	bne $a1, $t0, checkdate_31	# if (month != 2) goto 31

	# month == 2:
		# backup
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a0, 4($sp)
		# call function
	add $a0, $a2, $0
	jal leapyear_int
		# restore
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	addi $sp, $sp, 8
		# continue process
	beq $v0, $0, checkdate_28	# Khong phai nam nhuan

	addi $t8, $0, 29		# Nam nhuan
	j checkdate_day	

	checkdate_28:
		addi $t8, $0, 28
		j checkdate_day
	checkdate_30:
		addi $t8, $0, 30
		j checkdate_day
	checkdate_31:
		addi $t8, $0, 31

	checkdate_day:
		slt $t0, $t8, $a0	
		bne $t0, $0, checkdate_false	# if (day > lim) return false
		addi $v0, $0, 1
		jr $ra
		
	checkdate_false:
		add $v0, $0, $0
		jr $ra