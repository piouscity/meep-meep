.text
	jal ReadDayOrMonth
	addi $a0, $v0, 0
	addi $v0, $zero, 1
	syscall
	j end_program	

ReadDayOrMonth:
	# Ham nhap mot ngay va kiem tra xem du lieu co phai la mot so hay khong.
	# Ket qua tra ve: so nguyen 4 byte luu gia tri ngay hoac -1 neu ngay nhap khong hop le.
	#######################################################
	addi $sp, $sp, -8 # Cap phat 12 byte trong stack.
	sw $s0, 0($sp) # Luu cac thanh ghi s.
	addi $sp, $sp, 4 # Vung nho cua xau nhap vao.
	addi $a0, $sp, 0 # Nhap xau.
	addi $a1, $zero, 3 # Chi dc nhap toi da 2 ki tu.
	addi $v0, $zero, 8
	syscall
	#______________________
	# Kiem tra du lieu co phai la mot so hop le hay khong.
	# Ki tu dau tien
	# Kiem tra ki tu dau tien co phai newline hay khong.
	lb $s0, 0($sp) # Lay ki tu dau tien cua xau.
	addi $s0, $s0, -10 # Tru di 10.
	beq $s0, $zero, invalid_day_entered # Ki tu dau tien la ki tu xuong dong thi ngay nhap khong hop le.
	addi $s0, $s0, 10 # Khoi phuc lai gia tri cu.
		
	# Kiem tra ngay nhap co hoan toan la chu so hay khong.
	slti $t0, $s0, 48 # Kiem tra s0 < '0'
	bne $t0, $zero, invalid_day_entered # s0 < 48 <=> t0 != false <=> t0 = true <=> ki tu dau tien khong phai chu so.
	addi $t0, $zero, 57 # Ki tu '9'.
	slt $t1, $t0, $s0 # Kiem tra '9' < s0.
	bne $t1, $zero, invalid_day_entered # t1 != false <=> t1 = true <=> '9' < s0 <=> ki tu thu dau tien khong phai chu so.
	addi $v0, $s0, -48 # Luu chu so dau tien vao ket qua.

	# Ki tu thu hai.
	# Kiem tra ki tu dau tien co phai newline hay khong.
	lb $s0, 1($sp) # Lay ki tu thu hai cua xau.
	addi $s0, $s0, -10 # Tru di 10.
	beq $s0, $zero, end_readdayormonth # Ki tu thu hai la ki tu xuong dong thi ngay nhap da hop le.
	addi $s0, $s0, 10 # Khoi phuc lai gia tri cu.
	# Kiem tra ki tu thu hai co phai chu so hay khong.
	slti $t0, $s0, 48 # Kiem tra s0 < '0'
	bne $t0, $zero, invalid_day_entered # s1 < 48 <=> t0 != false <=> t0 = true <=> ki tu dau tien khong phai chu so.
	addi $t0, $zero, 57 # Ki tu '9'.
	slt $t1, $t0, $s0 # Kiem tra '9' < s0.
	bne $t1, $zero, invalid_day_entered # t1 != false <=> t1 = true <=> '9' < s0 <=> ki tu thu dau tien khong phai chu so.
	addi $t0, $zero, 10 # So 10.
	mult $v0, $t0 # Nhan 10 ket qua.
	mflo $v0
	add $v0, $v0, $s0 # Cong chu so thu hai vo ket qua.
	addi $v0, $v0, -48	

	j end_readdayormonth # Ngay duoc nhap da hop le.
	######################################
	invalid_day_entered:
	addi $v0, $zero, -1 # Ngay nhap khong hop le.	
end_readdayormonth:
	addi $sp, $sp, -4 # Vi tri nho thanh ghi ra.
	lw $s0, 0($sp) # Lay lai cac thanh ghi s.
	addi $sp, $sp, 8 # Giai phong bo nho.
	jr $ra


end_program:
