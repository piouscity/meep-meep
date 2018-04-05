# Ham tra ve thu trong tuan
# Tham so $a0: *char chuoi TIME (duoc luu trong $s0)
# Tham so $a0 khong bi thay doi
Weekday:
	# $s0: chuoi TIME
	# $s1: ket qua can duoc tinh (0 ... 6)
	# $s2: gia tri thang
	# $s3: kiem tra nam nhuan
	# $t0: hang so
	
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	add $s0, $a0, $zero

	# Lay ngay
	jal Day
	add $s1, $zero, $v0 # lay gia tri ngay

	# Lay thang
	jal Month
	add $s2, $zero, $v0 # lay gia tri thang

	# $t1: gia tri nam
	addi $t0, $zero, 10 # so 10
	lb $t1, 6($s0) # lay chu so dau tien trong nam
	subi $t1, $t1, 48 # doi ki tu thanh so
	mult $t1, $t0 # nhan 10
	mflo $t1 # lay ket qua phep nhan
	lb $t2, 7($s0) # lay chu so thu 2 trong nam
	add $t1, $t1, $t2 # cong vao
	subi $t1, $t1, 48 # doi so thanh ki tu
	mult $t1, $t0
	mflo $t1
	lb $t2, 8($s0) # lay chu so thu 3 trong nam
	add $t1, $t1, $t2 # cong vao
	subi $t1, $t1, 48 # doi ki tu thanh so
	mult $t1, $t0 # nhan 10
	mflo $t1 # lay ket qua phep nhan
	lb $t2, 9($s0) # lay chu so thu 4 trong nam
	add $t1, $t1, $t2 # cong vao ($t1 la 2 chu so cuoi cua nam)
	subi $t1, $t1, 48 # doi so thanh ki tu
	add $s1, $s1, $t1 # cong ket qua

	# nam chia 4
	addi $t0, $zero, 4 # so 4
	div $t1, $t0 # chia 4
	mflo $t2 # lay phan nguyen
	add $s1, $s1, $t2 # cong ket qua

	# nam chia 100
	addi $t0, $zero, 100 # so 100
	div $t1, $t0 # chia 100
	mflo $t2 # lay phan nguyen
	sub $s1, $s1, $t2 # cong ket qua

	# nam chia 400
	addi $t0, $zero, 400
	div $t1, $t0
	mflo $t2
	add $s1, $s1, $t2

	# Kiem tra nam nhuan
	jal LeapYear
	add $s3, $zero, $v0 # lay ket qua
	
	# Tinh he so m
	# Thang 1
	addi $t0, $zero, 1
	beq $s2, $t0, January
	j end_January
	January:
		beq $s3, $zero, not_leap_1
		addi $s1, $s1, 6
		j end_not_leap_1
		not_leap_1:
			addi $s1, $s1, 0
		end_not_leap_1:
		j end_weekmonth
	end_January:

	# Thang 2
	addi $t0, $zero, 2
	beq $s2, $t0, February
	j end_February
	February:
		beq $s3, $zero, not_leap_2
		addi $s1, $s1, 2
		j end_not_leap_2
		not_leap_2:
			addi $s1, $s1, 3
		end_not_leap_2:
		j end_weekmonth
	end_February:

	# Thang 3
	addi $t0, $zero, 3
	beq $s2, $t0, March
	j end_March
	March:
		addi $s1, $s1, 3
		j end_weekmonth
	end_March:

	# Thang 4
	addi $t0, $zero, 4
	beq $s2, $t0, April
	j end_April
	April:
		addi $s1, $s1, 6
		j end_weekmonth
	end_April:

	# Thang 5
	addi $t0, $zero, 5
	beq $s2, $t0, May
	j end_May
	May:
		addi $s1, $s1, 1
		j end_weekmonth
	end_May:

	# Thang 6
	addi $t0, $zero, 6
	beq $s2, $t0, June
	j end_June
	June:
		addi $s1, $s1, 4
		j end_weekmonth
	end_June:

	# Thang 7
	addi $t0, $zero, 7
	beq $s2, $t0, July
	j end_July
	July:
		addi $s1, $s1, 6
		j end_weekmonth
	end_July:

	# Thang 8
	addi $t0, $zero, 8
	beq $s2, $t0, August
	j end_August
	August:
		addi $s1, $s1, 2
		j end_weekmonth
	end_August:

	# Thang 9
	addi $t0, $zero, 9
	beq $s2, $t0, Sep
	j end_Sep
	Sep:
		addi $s1, $s1, 5
		j end_weekmonth
	end_Sep:
	
	# Thang 10
	addi $t0, $zero, 10
	beq $s2, $t0, Oct
	j end_Oct
	Oct:
		addi $s1, $s1, 0
		j end_weekmonth
	end_Oct:

	# Thang 11
	addi $t0, $zero, 11
	beq $s2, $t0, Nov
	j end_Nov
	Nov:
		addi $s1, $s1, 3
		j end_weekmonth
	end_Nov:

	# Thang 12
	addi $t0, $zero, 12
	beq $s2, $t0, Dec
	j end_Dec
	Dec:
		addi $s1, $s1, 5
		j end_weekmonth
	end_Dec:
	end_weekmonth:

	# Phep mod tinh thu trong tuan
	addi $t0, $zero, 7
	div $s1, $t0
	mfhi $s1

	# Xac dinh thu trong tuan
	addi $t0, $zero, 0
	beq $t0, $s1, Saturday
	addi $t0, $zero, 1
	beq $t0, $s1, Sunday
	addi $t0, $zero, 2
	beq $t0, $s1, Monday
	addi $t0, $zero, 3
	beq $t0, $s1, Tuesday
	addi $t0, $zero, 4
	beq $t0, $s1, Wednesday
	addi $t0, $zero, 5
	beq $t0, $s1, Thursday
	addi $t0, $zero, 6
	beq $t0, $s1, Friday

	Saturday:
		lui $t0, 0x0000
		ori $t0, 0x0000
		lui $t1, 0x0074
		ori $t1, 0x6153
		j end_weekday

	Sunday:
		lui $t0, 0x0000
		ori $t0, 0x0000
		lui $t1, 0x006e
		ori $t1, 0x7553
		j end_weekday

	Monday:
		lui $t0, 0x0000
		ori $t0, 0x0000
		lui $t1, 0x006e
		ori $t1, 0x6f4d
		j end_weekday

	Tuesday:
		lui $t0, 0x0000
		ori $t0, 0x0000
		lui $t1, 0x7365
		ori $t1, 0x7554
		j end_weekday

	Wednesday:
		lui $t0, 0x0000
		ori $t0, 0x0000
		lui $t1, 0x0064
		ori $t1, 0x6557
		j end_weekday

	Thursday:
		lui $t0, 0x0000
		ori $t0, 0x0073
		lui $t1, 0x7275
		ori $t1, 0x6854
		j end_weekday

	Friday:
		lui $t0, 0x0000
		ori $t0, 0x0000
		lui $t1, 0x0069
		ori $t1, 0x7246
		j end_weekday		
	end_weekday:
		la $v0, time_ans
		sb $t1, 0($v0)
		srl $t1, $t1, 8
		sb $t1, 1($v0)
		srl $t1, $t1, 8
		sb $t1, 2($v0)
		srl $t1, $t1, 8
		sb $t1, 3($v0)
		sb $t0, 4($v0)
		srl $t0, $t0, 8
		sb $t0, 5($v0)
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	jr $ra

end_program:
