# Day khong phai la ham nen khong can quan tam den cac quy tac goi ham.
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