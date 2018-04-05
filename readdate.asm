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
	