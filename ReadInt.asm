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
