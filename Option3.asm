Option3:
	addi $a0, $s0, 0
	addi $a1, $s1, 0
	addi $a2, $s2, 0
	addi $a3, $s3, 0 # Lay tham so la chuoi time
	jal Date # Khoi tao chuoi time theo dung format.

	addi $a0, $v0, 0 # Dat tham so la chuoi time da dinh dang.
	jal Weekday

	# Xuat ket qua
	addi $a0, $v0, 0
	addi $v0, $zero, 4
	syscall
	j end_program
