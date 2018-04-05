# Ham leapyear.
# Cac tham so:
#	a0: char * chuoi time.
# Cac thanh ghi a bi thay doi: khong co.
LeapYear:
	addi $sp, $sp, -4 # Khai bao bo nho stack.
	sw $ra, 0($sp) # Luu dia chi ra vao trong ram.

	jal Year # Goi ham year, tach nam ra khoi chuoi.
	addi $t0, $zero, 400 # So 400.
	div $v0, $t0 # Kiem tra chia het cho 400.
	mfhi $t0 # Lay phan du.
	beq $t0, $zero, leap_true # Neu chia het cho 400 thi la nam nhuan.

	addi $t0, $zero, 100 # So 100.
	div $v0, $t0 # Kiem tra chia het cho 100.
	mfhi $t0
	beq $t0, $zero, leap_false # Neu chia het cho 100 thi khong la nam nhuan.

	addi $t0, $zero, 4 # So 4.
	div $v0, $t0 # Kiem tra chia het cho 4.
	mfhi $t0
	bne $t0, $zero, leap_false # Neu khong chia het cho 4 thi khong la nam nhuan.

	leap_true:
		addi $v0, $zero, 1
		j end_leap_year
	leap_false:
		addi $v0, $zero, 0
end_leap_year:
	lw $ra, 0($sp) # Lay lai gia tri ra.
	addi $sp, $sp, 4 # Giai phong bo nho.
	jr $ra
