Option1:
	addi $a0, $s0, 0 # Truyen tham so ngay.
	addi $a1, $s1, 0 # Truyen tham so thang.
	addi $a2, $s2, 0 # Truyen tham so nam.
	addi $a3, $s3, 0 # Truyen chuoi time.
	jal Date # Goi ham Date.

	#_________________
	# Xuat ket qua.
	addi $a0, $v0, 0 # Dat chuoi can xuat la v0.
	addi $v0, $zero, 4 # Xuat chuoi.
	syscall
	j end_program # Ket thuc chuong trinh.