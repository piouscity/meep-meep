.data
	time: .asciiz "24/11/4000"
.text
	la $a0, time
	jal LeapYear
	addi $a0, $v0, 0
	addi $v0, $zero, 1
	syscall
	j end_program

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

end_program: