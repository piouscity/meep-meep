Option3:
	addi $a0, $v0, 0 # Dat tham so la chuoi time da dinh dang.
	jal Weekday

	# Xuat ket qua
	addi $a0, $v0, 0
	addi $v0, $zero, 4
	syscall
	j end_program
