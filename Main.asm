.data
	time0: .space 16
	time1: .space 16
	header: .asciiz "-----Hay chon 1 trong cac thao tac duoi day------\n"
	option1_str: .asciiz "1. Xuat chuoi time theo dinh dang DD/MM/YYYY\n"
	option2_str: .asciiz "2. Chuyen doi chuoi TIME thanh mot trong cac dinh dang sau:\n\tA. MM/DD/YYYY\n\tB. Month DD, YYYY\n\tC. DD Month, YYYY\n"
	option3_str: .asciiz "3. Cho biet ngay vua nhap la ngay thu may trong tuan:\n"
	option4_str: .asciiz "4. Kiem tra nam trong chuoi time co phai la nam nhuan khong\n"
	option5_str: .asciiz "5. Cho biet khoang thoi gian giua chuoi time1 va time2\n"
	option6_str: .asciiz "6. Cho biet 2 nam nhuan gan nhat voi nam trong chuoi time\n"
	option_str: .asciiz "Lua chon: "
	result_str: .asciiz "Ket qua: "
	leap_str: .asciiz "Nam nhuan"
	non_leap_str: .asciiz "Nam khong nhuan"
	time_format_str: .asciiz "Nhap kieu chuyen doi (A, B, C): "
	str0: .asciiz "Sat"
	str1: .asciiz "Sun"
	str2: .asciiz "Mon"
	str3: .asciiz "Tues"	
	str4: .asciiz "Wed"
	str5: .asciiz "Thurs"
	str6: .asciiz "Fri"
	
.text
main:
	# Read time0
	la $a0, time0
	jal readdate
	# Print menu
	addi $v0, $0, 4
	la $a0, header
	syscall
	la $a0, option1_str
	syscall
	la $a0, option2_str
	syscall
	la $a0, option3_str
	syscall
	la $a0, option4_str
	syscall
	la $a0, option5_str
	syscall
	la $a0, option6_str
	syscall
	
	addi $v0, $0, 11
	addi $a0, $0, 45
	add $t0, $0, $0
	addi $t1, $0, 50
	main_print_footer:
		slt $t2, $t0, $t1
		beq $t2, $0, main_print_footer_break
		syscall
		addi $t0, $t0, 1
		j main_print_footer
	main_print_footer_break:
	addi $a0, $0, 10
	syscall
	
	while_user_option_is_invalid:
		# Read user's option
		la $a0, option_str
		addi $v0, $0, 4
		syscall

		addi $a0, $0, 1
		jal ReadInt	# $v0: user's option

		addi $s0, $v0, 0 # Luu lai v0
		addi $a0, $zero, 10 # Xuat xuong hang.
		addi $v0, $zero, 11
		syscall

		addi $v0, $s0, 0 # Tra lai v0
		# process user's option
		addi $t0, $0, 1
		beq $t0, $v0, Option1
		addi $t0, $t0, 1
		beq $t0, $v0, Option2
		addi $t0, $t0, 1
		beq $t0, $v0, Option3
		addi $t0, $t0, 1
		beq $t0, $v0, Option4
		addi $t0, $t0, 1
		#beq $t0, $v0, Option5
		addi $t0, $t0, 1
		beq $t0, $v0, Option6
	
		j while_user_option_is_invalid # Khong hop le thi nhap lai.

	# process every option
	Option1:
		addi $v0, $0, 4
		la $a0, result_str
		syscall
		la $a0, time0
		syscall
		j main_exit
	Option2:
		la $a0, time_format_str # Chuoi thong bao nhap dang chuyen doi.
		addi $v0, $zero, 4 # Xuat string.
		syscall
		# Nhap ki tu.
		addi $v0, $zero, 12 # Nhap ki tu.
		syscall
		addi $s0, $v0, 0 # Luu ki tu lai.
		addi $a0, $zero, 10 # Xuat xuong dong.
		addi $v0, $zero, 11
		syscall
		la $a0, time0 # Con tro den chuoi time.
		addi $a1, $s0, 0
		jal convert
		addi $s0, $v0, 0 # Luu ket qua.
		la $a0, result_str # Xau thong bao ket qua.
		addi $v0, $zero, 4
		syscall
		addi $a0, $s0, 0 # Xuat chuoi.
		addi $v0, $zero, 4
		syscall
		j main_exit
	Option3:
		addi $v0, $0, 4
		la $a0, result_str
		syscall
		la $a0, time0
		jal Weekday

		# Xuat ket qua
		addi $a0, $v0, 0
		addi $v0, $zero, 4
		syscall

		j main_exit
	Option4:		
		la $a0, time0
		jal LeapYear # Kiem tra nam nhuan.


		beq $v0, $zero, print_non_leap_year # Neu khong la nam nhuan thi jump.
		la $a0, leap_str # Xuat nam nhuan.
		j end_option4 # Nhay toi cuoi option4.

		print_non_leap_year:
		la $a0,	non_leap_str # Xuat khong nhuan.
	end_option4:
		addi $v0, $zero, 4 # Xuat ket qua.
		syscall
		j main_exit # Ket thuc chuong trinh.
	Option6:
		addi $v0, $zero, 4 # Xuat ket qua.
		syscall
		addi $s4, $zero, 0 # i = 0.
		while_not_enough_leep_year:
			slti $t0, $s4, 2 # i < 2.
			beq $t0, $zero, end_while_not_enough_leep_year # t0 = false <=> i >= 2
			addi $s2, $s2, 1 # Tang nam len.
			addi $a0, $s0, 0 # Khoi tao ngay thang nam moi.
			addi $a1, $s1, 0
			addi $a2, $s2, 0
			addi $a3, $s3, 0
			jal Date # Tao chuoi time tu ngay thang nam.
			addi $a0, $v0, 0 # Dat tham so la chuoi time.
			jal LeapYear # Goi ham kiem tra nam nhuan.
			add $s4, $s4, $v0 # Neu nam nhuan thi cong 1, nam khong nhuan thi cong 0.
			beq $v0, $zero, while_not_enough_leep_year # Nam khong nhuan thi continue.

			# Nam nhuan thi xuat ket qua.
			addi $a0, $s2, 0 # Xuat nam.
			addi $v0, $zero, 1
			syscall
			addi $a0, $zero, 32 # Xuat dau cach.
			addi $v0, $zero, 11
			syscall
			j while_not_enough_leep_year
		end_while_not_enough_leep_year:
		j main_exit # Ket thuc chuong trinh
		
		
# Ham yeu cau nguoi dung nhap ngay, thang, nam; tra ve chuoi co dinh dang "DD/MM/YYYY"
# Tham so:
#	a0: Dia chi cua vung nho luu chuoi ket qua
# Ham se thay doi vung nho $a0 tro toi.
# $a0 co the bi thay doi.
# Tra ve:
#	v0: 1 (successful) hoac 0 (error)
#	v1: Dia chi vung nho ket qua (neu successful)
# Ham yeu cau nguoi dung nhap ngay, thang, nam; tra ve chuoi co dinh dang "DD/MM/YYYY"
# Nguoi dung phai nhap toi khi dung thi thoi.
# Tham so:
#	a0: Dia chi cua vung nho luu chuoi ket qua
# Ham se thay doi vung nho $a0 tro toi.
# $a0 co the bi thay doi.
# Tra ve:
#	v0: Dia chi vung nho ket qua 
readdate:
	# backup
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $s0, 4($sp)	
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)

	add $s3, $a0, $0	# s3: Dia chi vung nho ket qua
	# create string memory
	addi $sp, $sp, -12

	# print "Nhap ngay:"
	readdate_begin_read:

	lui $t0, 0x7061
	ori $t0, $t0, 0x684e
	sw $t0, 0($sp)
	lui $t0, 0x6167
	ori $t0, $t0, 0x6e20
	sw $t0, 4($sp)
	ori $t0, $0, 0x3a79
	sw $t0, 8($sp)

	addi $v0, $0, 4
	add $a0, $sp, $0
	syscall

	# scan day
	addi $a0, $0, 2
	jal ReadInt
	slt $t0, $v0, $0
	bne $t0, $0, readdate_error
	add $s0, $v0, $0

	# print "Nhap thang:"
	addi $a0, $0, 10
	addi $v0, $0, 11
	syscall	# new line

	lui $t0, 0x6168
	ori $t0, $t0, 0x7420	
	sw $t0, 4($sp)
	lui $t0, 0x003a
	ori $t0, $t0, 0x676e
	sw $t0, 8($sp)

	addi $v0, $0, 4
	add $a0, $sp, $0
	syscall

	# scan month
	addi $a0, $0, 2
	jal ReadInt
	slt $t0, $v0, $0
	bne $t0, $0, readdate_error
	add $s1, $v0, $0

	# print "Nhap nam:"
	addi $a0, $0, 10
	addi $v0, $0, 11
	syscall	# new line

	lui $t0, 0x6d61
	ori $t0, $t0, 0x6e20	
	sw $t0, 4($sp)
	ori $t0, $0, 0x3a
	sw $t0, 8($sp)

	addi $v0, $0, 4
	add $a0, $sp, $0
	syscall

	# scan year
	addi $a0, $0, 4
	jal ReadInt
	slt $t0, $v0, $0
	bne $t0, $0, readdate_error
	add $s2, $v0, $0

	# continue checking error
	add $a0, $s0, $0
	add $a1, $s1, $0
	add $a2, $s2, $0
	jal checkdate 	# sau cau lenh nay, a0 a1 a2 van khong thay doi
	bne $v0, $0, readdate_write

	readdate_error:
		# print "Error!"
		addi $a0, $0, 10
		addi $v0, $0, 11
		syscall	# new line

		lui $t0, 0x6f72
		ori $t0, $t0, 0x7245
		sw $t0, 0($sp)
		ori $t0, $0, 0x2172
		sw $t0, 4($sp)

		addi $v0, $0, 4
		add $a0, $sp, $0
		syscall

		addi $a0, $0, 10
		addi $v0, $0, 11
		syscall	# new line

		# read again
		j readdate_begin_read	

	readdate_write:
		# Cac thanh ghi a0, a1, a2 van luu ngay, thang, nam
		add $a3, $s3, $0	# Vung nho can ghi chuoi ket qua
		jal Date
		
		addi $a0, $0, 10
		addi $v0, $0, 11
		syscall	# new line

		add $v0, $s3, $0

	readdate_restore:
		# restore
		addi $sp, $sp, 12	# Free string memory	
		lw $ra, 0($sp)
		lw $s0, 4($sp)	
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		addi $sp, $sp, 20
		jr $ra

# Ham readint.
# Nhap mot so nguyen voi toi da mot luong ki tu cho truoc.
# Cac tham so:
#	a0: int so ki tu toi da.
# Ket qua tra ve: so nguyen 4 byte luu gia tri ngay hoac -1 neu ngay nhap khong hop le.
# Cac thanh ghi a bi thay doi: a0, a1
ReadInt:	
	# Backup
	addi $sp, $sp, -12 # Phan nho cho cac thanh ghi s.
	sw $s0, 0($sp) # Luu cac thanh ghi s.
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	# Process
	addi $s0, $a0, 1 # So ki tu toi da, chua ki tu \0 o cuoi.
	addi $t0, $zero, 4 # So 4.
	div $s0, $t0 # Lay so ki tu chia 4.
	mfhi $t0 # Lay phan du phep chia.
	sub $s1, $s0, $t0 # Tru di phan du
	beq $t0, $zero, dont_add_four # Neu phan du la 0 thi khong can +4.
	addi $s1, $s1, 4 # Cong 4.
	dont_add_four:
	# Khai bao bo nho stack.
	sub $sp, $sp, $s1 # Phan nho cho xau nhap.
	addi $a0, $sp, 0 # Nhap xau.
	addi $a1, $s0, 0 # So ki tu toi da can nhap.
	addi $v0, $zero, 8
	syscall

	
	#______________________
	# Kiem tra du lieu co phai la mot so hop le hay khong.
	addi $v0, $zero, 0 # Dat ket qua la 0.
	addi $s2, $sp, 0 # Luu con tro den xau.
	while_not_end_of_int:
		lb $s0, 0($s2) # Lay ki tu cua xau ra.
		addi $s0, $s0, -10 # Tru di 10.
		beq $s0, $zero, end_while_not_end_of_int # Ki tu newline thi break.
		addi $s0, $s0, 10 # Tra lai gia tri cu
		beq $s0, $zero, end_while_not_end_of_int # Ki tu \0 thi break.
		# Kiem tra ki tu tren co phai chu so hay khong.
		slti $t0, $s0, 48 # Kiem tra s0 < '0'	
		bne $t0, $zero, invalid_int_entered # s0 < 48 <=> t0 != false <=> t0 = true <=> ki tu dau tien khong phai chu so.
		addi $t0, $zero, 57 # Ki tu '9'.
		slt $t1, $t0, $s0 # Kiem tra '9' < s0.
		bne $t1, $zero, invalid_int_entered # t1 != false <=> t1 = true <=> '9' < s0 <=> ki tu thu dau tien khong phai chu so.
		addi $t0, $zero, 10 # So 10.
		# Luu vao ket qua.
		mult $v0, $t0 # Nhan ket qua voi 10.
		mflo $v0
		add $v0, $v0, $s0 # Luu chu so tren vao ket qua.
		addi $v0, $v0, -48 # Doi thanh so.
		# Tiep tuc lap.
		addi $s2, $s2, 1 # Ki tu tiep theo.
		j while_not_end_of_int # Lap.
	end_while_not_end_of_int:
	j end_readint # Nhay toi cuoi ham.
	invalid_int_entered:
	addi $v0, $zero, -1 # Ngay nhap khong hop le.	
end_readint:
	add $sp, $sp, $s1 # Giai phong bo nho chua xau
	lw $s0, 0($sp) # Lay lai cac thanh ghi s.
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12 # Giai phong bo nho chua thanh ghi
	jr $ra


# Kiem tra tinh hop le cua Date.
# Tham so :
#	a0: ngay
#	a1: thang
#	a2: nam
# Ham dam bao rang cac tham so khong bi thay doi.
# Tra ve : 
#	v0: 1 (true) hoac 0 (false)
checkdate:
	
	addi $t9, $0, 9999
	slt $t0, $t9, $a2
	bne $t0, $0, checkdate_false	# if (year > 9999) return false
	slti $t0, $a2, 1900
	bne $t0, $0, checkdate_false	# if (year < 1900) return false

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

# Ham Date.
# Cac tham so
#	a0: int ngay.
#	a1: int thang.
# 	a2: int nam.
#	a3: char * time.
# Cac thanh ghi a bi thay doi: a2.
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
	sb $zero, 10($a3) # Them \0.
	addi $v0, $a3, 0
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

# Ham chuyen doi dinh dang chuoi TIME
# Tham so:
#	$a0: chuoi TIME
#	$a1: kieu dinh dang ('A', 'B' hoac 'C')
# Ham se thay doi gia tri cua vung nho ma $a0 tro toi.
# Cac tham so $a0, $a1 co the bi thay doi.
# Tra ve:
#	$v0: dia chi vung nho chua chuoi TIME da dinh dang.
convert:
	addi $t0, $0, 65
	bne $t0, $a1, convert_type_not_a
	# swap 0 and 3
	lb $t0, 0($a0)
	lb $t1, 3($a0)
	sb $t1, 0($a0)
	sb $t0, 3($a0)
	# swap 1 and 4
	lb $t0, 1($a0)
	lb $t1, 4($a0)
	sb $t1, 1($a0)
	sb $t0, 4($a0)
	j convert_return

	convert_type_not_a:
	# backup if type not A
		addi $sp, $sp, -8
		sw $s0, 4($sp)
		sw $ra, 0($sp)
	
		add $s0, $a0, $0
	# process if type not A
		sb $0, 12($s0)		# add '\0' to the end
		# t2 : MM	
		lb $t2, 3($s0)		
		addi $t2, $t2, -48
		addi $t0, $0, 10
		mult $t2, $t0
		mflo $t2
		lb $t0, 4($s0)
		addi $t0, $t0, -48
		add $t2, $t2, $t0
		# insert (, YYYY)
		lb $t0, 9($s0)
		sb $t0, 11($s0)
		lb $t0, 8($s0)
		sb $t0, 10($s0)
		lb $t0, 7($s0)
		sb $t0, 9($s0)
		lb $t0, 6($s0)
		sb $t0, 8($s0)
		addi $t0, $0, 0x2c 	# comma and space
		sb $t0, 6($s0)
		addi $t0, $0, 0x20
		sb $t0, 7($s0)

		addi $t0, $0, 66	
		beq $t0, $a1, convert_type_b

		# type_c:
		addi $t0, $0, 32	# space
		sb $t0, 2($s0)
		
		addi $a1, $s0, 3
		add $a0, $t2, $0	
		jal mm_to_month	
		
		j convert_restore

		convert_type_b:
			lb $t0, 0($s0)	# DD
			sb $t0, 4($s0)
			lb $t0, 1($s0)
			sb $t0, 5($s0)

			addi $t0, $0, 32
			sb $t0, 3($s0)
			
			add $a1, $s0, $0
			add $a0, $t2, $0
			jal mm_to_month

	# restore if type not A and return
	convert_restore:
		add $v0, $s0, $0 	
		lw $s0, 4($sp)
		lw $ra, 0($sp)
		addi $sp, $sp, 8
		jr $ra
# return
	convert_return:
		add $v0, $a0, $0
		jr $ra

# Ham chuyen MM sang Month ( vd: 01 --> "JAN" )
# Tham so:
#	$a0: so thang (vd: 1)
#	$a1: dia chi chuoi can ghi
# Ham dam bao se khong thay doi $a0 va $a1
mm_to_month:
	addi $t0, $0, 1
	beq $a0, $t0, mm_to_month_1
	addi $t0, $t0, 1
	beq $a0, $t0, mm_to_month_2
	addi $t0, $t0, 1
	beq $a0, $t0, mm_to_month_3
	addi $t0, $t0, 1
	beq $a0, $t0, mm_to_month_4
	addi $t0, $t0, 1
	beq $a0, $t0, mm_to_month_5
	addi $t0, $t0, 1
	beq $a0, $t0, mm_to_month_6
	addi $t0, $t0, 1
	beq $a0, $t0, mm_to_month_7
	addi $t0, $t0, 1
	beq $a0, $t0, mm_to_month_8
	addi $t0, $t0, 1
	beq $a0, $t0, mm_to_month_9
	addi $t0, $t0, 1
	beq $a0, $t0, mm_to_month_10
	addi $t0, $t0, 1
	beq $a0, $t0, mm_to_month_11
	# mm_to_month_12:
	lui $t1, 0x2043
	ori $t1, 0x4544
	j mm_to_month_return
	mm_to_month_1:
		lui $t1, 0x204e
		ori $t1, 0x414a
		j mm_to_month_return
	mm_to_month_2:
		lui $t1, 0x2042
		ori $t1, 0x4546
		j mm_to_month_return
	mm_to_month_3:
		lui $t1, 0x2052
		ori $t1, 0x414d
		j mm_to_month_return
	mm_to_month_4:
		lui $t1, 0x2052
		ori $t1, 0x5041
		j mm_to_month_return
	mm_to_month_5:
		lui $t1, 0x2059
		ori $t1, 0x414d
		j mm_to_month_return
	mm_to_month_6:
		lui $t1, 0x204e
		ori $t1, 0x554a
		j mm_to_month_return
	mm_to_month_7:
		lui $t1, 0x204c
		ori $t1, 0x554a
		j mm_to_month_return
	mm_to_month_8:
		lui $t1, 0x2047
		ori $t1, 0x5541
		j mm_to_month_return
	mm_to_month_9:
		lui $t1, 0x2050
		ori $t1, 0x4553
		j mm_to_month_return
	mm_to_month_10:
		lui $t1, 0x2054
		ori $t1, 0x434f
		j mm_to_month_return
	mm_to_month_11:
		lui $t1, 0x2056
		ori $t1, 0x4f4e
	mm_to_month_return:
		sb $t1, 0($a1)
		srl $t1, $t1, 8
		sb $t1, 1($a1)
		srl $t1, $t1, 8
		sb $t1, 2($a1)
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

main_exit:
