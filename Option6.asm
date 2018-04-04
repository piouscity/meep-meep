Option6:
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
	
	j end_program # Ket thuc chuong trinh