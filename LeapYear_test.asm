.data
	time: .asciiz "24/11/1700"
.text
	la $a0, time
	jal LeapYear
	addi $a0, $v0, 0
	addi $v0, $zero, 1
	syscall
	j end_program

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
	add $a0, $v0, $0	# Truyen ket qua ham Year lam tham so
	jal leapyear_int	# Ket qua luc nay duoc luu trong $v0
	
	lw $ra, 0($sp) # Lay lai gia tri ra.
	addi $sp, $sp, 4 # Giai phong bo nho.
	jr $ra

# Ham kiem tra nam nhuan
# Tham so a0: gia tri nam (so nguyen)
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

end_program: