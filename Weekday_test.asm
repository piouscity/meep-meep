.data
	time: .asciiz "13/07/2018"
	str0: .asciiz "Sun"
	str1: .asciiz "Mon"
	str2: .asciiz "Tues"
	str3: .asciiz "Wed"	
	str4: .asciiz "Thurs"
	str5: .asciiz "Fri"
	str6: .asciiz "Sat"

.text
	la $a0, time
	jal Weekday
	add $a0, $zero, $v0
	addi $v0, $zero, 4
	syscall
	j end_program

Day:
	addi $t0, $zero, 10 # So 10.
	lb $v0, 0($a0) # Lay chu so dau tien trong ngay.
	addi $v0, $v0, -48 # Doi no thanh so.
	mult $v0, $t0 # Nhan 10.
	mflo $v0 # Lay ket qua phep nhan.
	lb $t1, 1($a0) # Lay chu so thu hai trong ngay.
	add $v0, $v0, $t1 # Cong vao ket qua.
	addi $v0, $v0, -48
	jr $ra

Month:
	addi $t0, $zero, 10 # So 10.
	lb $v0, 3($a0) # Lay chu so dau tien trong thang.
	addi $v0, $v0, -48 # Doi no thanh so.
	mult $v0, $t0 # Nhan 10.
	mflo $v0 # Lay ket qua phep nhan.
	lb $t1, 4($a0) # Lay chu so thu hai trong thang.
	add $v0, $v0, $t1 # Cong vao ket qua.
	addi $v0, $v0, -48
	jr $ra

Year:
	addi $v0, $zero, 0 # Gan ket qua bang 0.
	addi $t0, $zero, 10 # So 10.
	addi $t1, $a0, 6 # Vi tri cua chu so dau tien trong thang.
	addi $t3, $a0, 10 # Vi tri ket thuc cua nam.
	Year_iterates_in_year:
		slt $t2, $t1, $t3 # Chua duyet xong nam.
		beq $t2, $zero, end_iterates_in_year
		mult $v0, $t0 # Nhan 10 ket qua.
		mflo $v0 # Lay ket qua phep nhan.
		lb $t2, 0($t1) # Lay chu so hien tai trong nam.
		add $v0, $v0, $t2 # Gan no vo ket qua.
		addi $v0, $v0, -48 # Doi tu char sang int.
		addi $t1, $t1, 1 # Tang vi tri chu so trong nam.
		j Year_iterates_in_year
	end_iterates_in_year:
	jr $ra

LeapYear:
	addi $sp, $sp, -4 # Khai bao bo nho stack.
	sw $ra, 0($sp) # Luu dia chi ra vao trong ram.

	jal Year # Goi ham year, tach nam ra khoi chuoi.
	addi $t0, $zero, 400 # So 400.
	div $v0, $t0 # Kiem tra chia het cho 400.
	mfhi $t0 # Lay phan du.
	beq $t0, $zero, leap # Neu chia het cho 400 thi la nam nhuan.

	addi $t0, $zero, 100 # So 100.
	div $v0, $t0 # Kiem tra chia het cho 100.
	mfhi $t0
	beq $t0, $zero, non_leap # Neu chia het cho 100 thi khong la nam nhuan.

	addi $t0, $zero, 4 # So 4.
	div $v0, $t0 # Kiem tra chia het cho 4.
	mfhi $t0
	bne $t0, $zero, non_leap # Neu khong chia het cho 4 thi khong la nam nhuan.

	leap:
		addi $v0, $zero, 1
		j end_leap_year
	non_leap:
		addi $v0, $zero, 0
end_leap_year:
	lw $ra, 0($sp) # Lay lai gia tri ra.
	addi $sp, $sp, 4 # Giai phong bo nho.
	jr $ra

Weekday:
	# Lay ngay
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	jal Day
	add $s0, $zero, $v0 # lay gia tri ngay
	lw $a0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8

	# Lay thang
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	jal Month
	add $s4, $zero, $v0 # lay gia tri thang
	add $s0, $s0, $s4 # cong ket qua
	lw $a0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8

	# Lay 2 so cuoi cua nam
	addi $t0, $zero, 10 # so 10
	lb $s1, 9($a0) # lay chu so thu 3 trong nam
	subi $s1, $s1, 48 # doi ki tu thanh so
	mult $s1, $t0 # nhan 10
	mflo $s1 # lay ket qua phep nhan
	lb $t1, 10($a0) # lay chu so thu 4 trong nam
	add $s1, $s1, $t1 # cong vao ($s1 la 2 chu so cuoi cua nam)
	subi $s1, $s1, 48 # doi so thanh ki tu
	add $s0, $s0, $s1 # cong ket qua

	# 2 so cuoi cua nam chia 4
	add $t1, $s1, $zero
	addi $t0, $zero, 4 # so 4
	div $t1, $t0 # chia 4
	mfhi $t2 # lay phan nguyen
	add $s0, $s0, $t2 # cong ket qua

	# Lay 2 so dau cua nam
	addi $t0, $zero, 10 # so 10
	lb $s2, 7($a0) # lay chu so dau tien trong nam
	subi $s2, $s2, 48 # doi ki tu thanh so
	mult $s2, $t0 # nhan 10
	mflo $s2 # lay ket qua phep nhan
	lb $t1, 8($a0) # lay chu so thu 2 trong nam
	add $s2, $s2, $t1 # cong vao ($s1 la 2 chu so dau cua nam)
	subi $s2, $s2, 48 # doi so thanh ki tu
	
	# Lay the ki
	beq $s1, $zero, end_century
	addi $s2, $s2, 1
	end_century:
	add $s0, $s0, $s2

	# Kiem tra nam nhuan
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	jal LeapYear
	add $s3, $zero, $v0 # lay ket qua
	lw $a0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	
	# Tinh he so m
	# Thang 1
	addi $t0, $zero, 1
	beq $s4, $t0, January
	j end_January
	January:
		beq $s3, $zero, not_leap_1
		addi $s0, $s0, 6
		j end_not_leap_1
		not_leap_1:
			addi $s0, $s0, 0
		end_not_leap_1:
		j end_weekmonth
	end_January:

	# Thang 2
	addi $t0, $zero, 2
	beq $s4, $t0, February
	j end_February
	February:
		beq $s3, $zero, not_leap_2
		addi $s0, $s0, 2
		j end_not_leap_2
		not_leap_2:
			addi $s0, $s0, 3
		end_not_leap_2:
		j end_weekmonth
	end_February:

	# Thang 3
	addi $t0, $zero, 3
	beq $s4, $t0, March
	j end_March
	March:
		addi $s0, $s0, 3
		j end_weekmonth
	end_March:

	# Thang 4
	addi $t0, $zero, 4
	beq $s4, $t0, April
	j end_April
	April:
		addi $s0, $s0, 6
		j end_weekmonth
	end_April:

	# Thang 5
	addi $t0, $zero, 5
	beq $s4, $t0, May
	j end_May
	May:
		addi $s0, $s0, 1
		j end_weekmonth
	end_May:

	# Thang 6
	addi $t0, $zero, 6
	beq $s4, $t0, June
	j end_June
	June:
		addi $s0, $s0, 4
		j end_weekmonth
	end_June:

	# Thang 7
	addi $t0, $zero, 7
	beq $s4, $t0, July
	j end_July
	July:
		addi $s0, $s0, 6
		j end_weekmonth
	end_July:

	# Thang 8
	addi $t0, $zero, 8
	beq $s4, $t0, August
	j end_August
	August:
		addi $s0, $s0, 2
		j end_weekmonth
	end_August:

	# Thang 9
	addi $t0, $zero, 9
	beq $s4, $t0, Sep
	j end_Sep
	Sep:
		addi $s0, $s0, 5
		j end_weekmonth
	end_Sep:
	
	# Thang 10
	addi $t0, $zero, 10
	beq $s4, $t0, Oct
	j end_Oct
	Oct:
		addi $s0, $s0, 0
		j end_weekmonth
	end_Oct:

	# Thang 11
	addi $t0, $zero, 11
	beq $s4, $t0, Nov
	j end_Nov
	Nov:
		addi $s0, $s0, 3
		j end_weekmonth
	end_Nov:

	# Thang 12
	addi $t0, $zero, 12
	beq $s4, $t0, Dec
	j end_Dec
	Dec:
		addi $s0, $s0, 5
		j end_weekmonth
	end_Dec:
	end_weekmonth:

	# Phep mod tinh thu trong tuan
	addi $t0, $zero, 7
	div $s0, $t0
	mflo $s0

	# Xac dinh thu trong tuan
	# Sunday
	addi $t0, $zero, 0
	beq $s0, $t0, WSun
	j not_WSun
	WSun:
		la $v0, str0
		j end_weekday
	not_WSun:

	# Monday
	addi $t0, $zero, 1
	beq $s0, $t0, WMon
	j not_WMon
	WMon:
		la $v0, str1
		j end_weekday
	not_WMon:

	# Tuesday
	addi $t0, $zero, 2
	beq $s0, $t0, WTues
	j not_WTues
	WTues:
		la $v0, str2
		j end_weekday
	not_WTues:

	# Wednesday
	addi $t0, $zero, 3
	beq $s0, $t0, WWed
	j not_WWed
	WWed:
		la $v0, str3
		j end_weekday
	not_WWed:

	# Thursday
	addi $t0, $zero, 4
	beq $s0, $t0, WThurs
	j not_WThurs
	WThurs:
		la $v0, str4
		j end_weekday
	not_WThurs:

	# Friday
	addi $t0, $zero, 5
	beq $s0, $t0, WFri
	j not_WFri
	WFri:
		la $v0, str5
		j end_weekday
	not_WFri:

	# Saturday
	addi $t0, $zero, 6
	beq $s0, $t0, WSat
	j not_WSat
	WSat:
		la $v0, str6
		j end_weekday
	not_WSat:
	
	end_weekday:
	jr $ra

end_program:
