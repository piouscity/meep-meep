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
	time_format_str: .asciiz "Nhap kieu chuyen doi (A, B, C): "
	
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
	
	# Read user's option
	la $a0, option_str
	addi $v0, $0, 4
	syscall

	addi $a0, $0, 1
	jal ReadInt	# $v0: user's option

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
	beq $t0, $v0, Option5
	addi $t0, $t0, 1
	beq $t0, $v0, Option6
	
	j main_exit	# $v0 is not from 1 to 6, exit

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
		addi $a0, $s3, 0 # Dat tham so goi ham convert.
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
		

	j main_exit

# Ham yeu cau nguoi dung nhap ngay, thang, nam; tra ve chuoi co dinh dang "DD/MM/YYYY"
# Tham so:
#	a0: Dia chi cua vung nho luu chuoi ket qua
# Ham se thay doi vung nho $a0 tro toi.
# $a0 co the bi thay doi.
# Tra ve:
#	v0: 1 (successful) hoac 0 (error)
#	v1: Dia chi vung nho ket qua (neu successful)
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
		# result
		add $v0, $0, $0
		j readdate_restore

	readdate_write:
		# Cac thanh ghi a0, a1, a2 van luu ngay, thang, nam
		add $a3, $s3, $0	# Vung nho can ghi chuoi ket qua
		jal Date
		
		addi $a0, $0, 10
		addi $v0, $0, 11
		syscall	# new line

		addi $v0, $0, 1
		add $v1, $s3, $0

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

main_exit: