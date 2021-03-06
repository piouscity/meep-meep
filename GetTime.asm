# Ham gettime.
# Cac tham so:
#	a0: char * chuoi time1.
#	a1: char * chuoi time2.
# Cac thanh ghi a bi thay doi: a0.
GetTime:
	addi $sp, $sp, -36 # Cap phat bo nho.
	sw $ra, 0($sp) # Luu ra.
	sw $s0, 4($sp) # Luu lai cac thanh ghi s.
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)

	#_________________________________________________
	# Trich xuat ngay thang nam cua time 1.
	jal Day
	addi $s0, $v0, 0 # Luu ngay cua time 1.
	jal Month
	addi $s1, $v0, 0 # Luu thang cua time 1.
	jal Year
	addi $s2, $v0, 0 # Luu nam cua time 1.

	#Trich xuat ngay thang nam cua time 2.
	addi $a0, $a1, 0 # Dat tham so = time 2 de goi ham.
	jal Day
	addi $s3, $v0, 0 # Luu ngay cua time 2.
	jal Month
	addi $s4, $v0, 0 # Luu thang cua time 2.
	jal Year
	addi $s5, $v0, 0 # Luu nam cua time 2.	


	#________________________________________________
	# Dat x = nam1 * 1e4 + thang1 * 1e2 + ngay1.
	#	y = nam2 * 1e4 + thang2 * 1e2 + ngay2.
	addi $t0, $zero, 100 # So 100.

	# Tinh x.
	addi $s6, $s2, 0 # Lay nam cua time 1.
	mult $s6, $t0 # Nhan nam voi 100.
	mflo $s6 # Lay ket qua phep nhan.  
	add $s6, $s6, $s1 # Cong voi thang cua time 1.
	mult $s6, $t0 # Nhan voi 100.
	mflo $s6 # Lay ket qua phep nhan.
	add $s6, $s6, $s0 # Cong voi ngay cua time 1.

	# Tinh y.
	addi $s7, $s5, 0 # Lay nam cua time 2.
	mult $s7, $t0 # Nhan nam voi 100.
	mflo $s7 # Lay ket qua phep nhan.  
	add $s7, $s7, $s4 # Cong voi thang cua time 2.
	mult $s7, $t0 # Nhan voi 100.
	mflo $s7 # Lay ket qua phep nhan.
	add $s7, $s7, $s3 # Cong voi ngay cua time 2.

	#______________________________________________
	# Kiem tra time1 >= time2.
	slt $t0, $s6, $s7 # Kiem tra nam cua time 1 co be hon nam cua time 2.
	beq $t0, $zero, dont_swap_time # Neu s6 >= s7 (t0 false) thi khong can phai swap 2 time.

		addi $t0, $s0, 0 # Doi ngay.
		addi $s0, $s3, 0	
		addi $s3, $t0, 0

		addi $t0, $s1, 0 # Doi thang.
		addi $s1, $s4, 0	
		addi $s4, $t0, 0

		addi $t0, $s2, 0 # Doi nam.
		addi $s2, $s5, 0	
		addi $s5, $t0, 0

	dont_swap_time:
		
		sub $v0, $s2, $s5 # Hieu 2 nam.
		addi $t0, $zero, 100 # So 100.
		#____________________
		# Tinh thang1 * 100 + ngay1.
		addi $s6, $s1, 0 # Lay thang cua time 1.
		mult $s6, $t0 # Nhan 100.
		mflo $s6 # Lay ket qua phep nhan.
		add $s6, $s6, $s0 # Cong voi ngay cua time 1.
		
		# Tinh thang2 * 100 + ngay2.
		addi $s7, $s4, 0 # Lay thang cua time 2
		mult $s7, $t0 # Nhan 100.
		mflo $s7 # Lay ket qua phep nhan.
		add $s7, $s7, $s3 # Cong voi ngay cua time 2.
		#_______________________
		# Tru ket qua neu chua du ngay
		slt $t0, $s6, $s7 # Kiem tra t1 < t2.
		beq $t0, $zero, end_get_time # Neu s6 >= s7 thi khong tru ket qua ma tra ve luon.
		addi $v0, $v0, -1

	end_get_time:
	lw $ra, 0($sp) # Lay ra.
	lw $s0, 4($sp) # Lay lai cac thanh ghi s.
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	lw $s7, 32($sp)
	addi $sp, $sp, 36 # Giai phong bo nho.
	jr $ra
