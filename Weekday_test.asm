.data
	time: .asciiz "05/04/2018"
	str0: .asciiz "Sat"
	str1: .asciiz "Sun"
	str2: .asciiz "Mon"
	str3: .asciiz "Tues"	
	str4: .asciiz "Wed"
	str5: .asciiz "Thurs"
	str6: .asciiz "Fri"

.text
	la $a0, time
	jal Weekday
	add $a0, $zero, $v0
	addi $v0, $zero, 4
	syscall
	j end_program

# Ham day
# Cac tham so:
#	a0: char * chuoi time.
# Cac thanh ghi a bi thay doi: khong co.
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

# Ham month.
# Cac tham so:
# 	a0: char * chuoi time.
# Cac thanh ghi a bi thay doi: khong co.
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

# Ham Year.
# Cac tham so:
#	a0: char * chuoi time.
# Cac thanh ghi a bi thay doi: khong co.
Year:
	addi $v0, $zero, 0 # Gan ket qua bang 0.
	addi $t0, $zero, 10 # So 10.
	addi $t1, $a0, 6 # Vi tri cua chu so dau tien trong nam.
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

# Ham kiem tra nam nhuan cua chuoi TIME
# Thanh ghi $a0 bi thay doi.
LeapYear:
	addi $sp, $sp, -4 # Khai bao bo nho stack.
	sw $ra, 0($sp) # Luu dia chi ra vao trong ram.

	jal Year # Goi ham year, tach nam ra khoi chuoi.
	add $a0, $v0, $0	# Truyen ket qua ham Year lam tham so
	jal leapyear_int	# Ket qua luc nay duoc luu trong $v0
	
	lw $ra, 0($sp) # Lay lai gia tri ra.
	addi $sp, $sp, 4 # Giai phong bo nho.
	jr $ra

# Ham kiem tra nam nhuan
# Tham so a0: gia tri nam (so nguyen)
# $a0 khong bi thay doi.
# Tra ve v0: 1 (true) hoac 0 (false)
leapyear_int:
	addi $t0, $zero, 400 # So 400.
	div $a0, $t0 # Kiem tra chia het cho 400.
	mfhi $t0 # Lay phan du.
	beq $t0, $zero, leapyear_int_true # Neu chia het cho 400 thi la nam nhuan.

	addi $t0, $zero, 100 # So 100.
	div $a0, $t0 # Kiem tra chia het cho 100.
	mfhi $t0
	beq $t0, $zero, leapyear_int_false # Neu chia het cho 100 thi khong la nam nhuan.

	addi $t0, $zero, 4 # So 4.
	div $a0, $t0 # Kiem tra chia het cho 4.
	mfhi $t0
	bne $t0, $zero, leapyear_int_false # Neu khong chia het cho 4 thi khong la nam nhuan.

	leapyear_int_true:
		addi $v0, $0, 1
		jr $ra
	leapyear_int_false:
		add $v0, $0, $0
		jr $ra

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

	# $t1: 2 chu so cuoi cua nam
	# $t2: 2 chu so dau cua nam

	# Lay 2 so cuoi cua nam
	addi $t0, $zero, 10 # so 10
	lb $t1, 8($s0) # lay chu so thu 3 trong nam
	subi $t1, $t1, 48 # doi ki tu thanh so
	mult $t1, $t0 # nhan 10
	mflo $t1 # lay ket qua phep nhan
	lb $t3, 9($s0) # lay chu so thu 4 trong nam
	add $t1, $t1, $t3 # cong vao ($t1 la 2 chu so cuoi cua nam)
	subi $t1, $t1, 48 # doi so thanh ki tu
	add $s1, $s1, $t1 # cong ket qua

	# 2 so cuoi cua nam chia 4
	addi $t0, $zero, 4 # so 4
	div $t1, $t0 # chia 4
	mflo $t3 # lay phan nguyen
	add $s1, $s1, $t3 # cong ket qua

	# Lay 2 so dau cua nam
	addi $t0, $zero, 10 # so 10
	lb $t2, 6($s0) # lay chu so dau tien trong nam
	subi $t2, $t2, 48 # doi ki tu thanh so
	mult $t2, $t0 # nhan 10
	mflo $t2 # lay ket qua phep nhan
	lb $t3, 7($s0) # lay chu so thu 2 trong nam
	add $t2, $t2, $t3 # cong vao ($s2 la 2 chu so dau cua nam)
	subi $t2, $t2, 48 # doi so thanh ki tu
	
	# Lay the ki
	beq $t1, $zero, end_century
	addi $t2, $t2, 1
	end_century:
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
	# Saturday
	addi $t0, $zero, 0
	beq $s1, $t0, Saturday
	j not_Saturday
	Saturday:
		la $v0, str0
		j end_weekday
	not_Saturday:

	# Sunday
	addi $t0, $zero, 1
	beq $s1, $t0, Sunday
	j not_Sunday
	Sunday:
		la $v0, str1
		j end_weekday
	not_Sunday:

	# Monday
	addi $t0, $zero, 2
	beq $s1, $t0, Monday
	j not_Monday
	Monday:
		la $v0, str2
		j end_weekday
	not_Monday:

	# Tuesday
	addi $t0, $zero, 3
	beq $s1, $t0, Tuesday
	j not_Tuesday
	Tuesday:
		la $v0, str3
		j end_weekday
	not_Tuesday:

	# Wednesday
	addi $t0, $zero, 4
	beq $s1, $t0, Wednesday
	j not_Wednesday
	Wednesday:
		la $v0, str4
		j end_weekday
	not_Wednesday:

	# Thursday
	addi $t0, $zero, 5
	beq $s1, $t0, Thursday
	j not_Thursday
	Thursday:
		la $v0, str5
		j end_weekday
	not_Thursday:

	# Friday
	addi $t0, $zero, 6
	beq $s1, $t0, Friday
	j not_Friday
	Friday:
		la $v0, str6
		j end_weekday
	not_Friday:
	
	end_weekday:
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	jr $ra

end_program:
