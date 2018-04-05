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
	j end_program
