.data
	time: .space 20
	leap_str: .asciiz "Nam nhuan"
	non_leap_str: .asciiz "Nam khong nhuan"
	
.text
	la $s3, time
	addi $v0, $zero, 5
	syscall
	addi $s0, $v0, 0
	
	addi $v0, $zero, 5
	syscall
	addi $s1, $v0, 0

	addi $v0, $zero, 5
	syscall
	addi $s2, $v0, 0
	j Option4

Option4:
	addi $a0, $s0, 0
	addi $a1, $s1, 0
	addi $a2, $s2, 0
	addi $a3, $s3, 0 # Lay tham so la chuoi time
	jal Date # Khoi tao chuoi time theo dung format.
	
	addi $a0, $v0, 0 # Dat tham so la chuoi time da dinh dang.
	jal LeapYear # Kiem tra nam nhuan.


	beq $v0, $zero, print_non_leap_year # Neu khong la nam nhuan thi jump.
	la $a0, leap_str # Xuat nam nhuan.
	j end_option4 # Nhay toi cuoi option4.

	print_non_leap_year:
	la $a0,	non_leap_str # Xuat khong nhuan.
end_option4:
	addi $v0, $zero, 4 # Xuat ket qua.
	syscall
	j end_program # Ket thuc chuong trinh.

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
end_program:
