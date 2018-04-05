.data
	str: .space 16
.text

main:
	addi $a1, $0, 15
	la $a0, str
	addi $v0, $0, 8
	syscall
	addi $v0, $0, 12
	syscall
	add $a1, $v0, $0
	jal convert
	add $a0, $v0, $0
	addi $v0, $0, 4
	syscall
	j exit


# Ham chuyen doi dinh dang chuoi TIME
# Tham so:
#	$a0: chuoi TIME
#	$a1: kieu dinh dang ('A', 'B' hoac 'C')
# Ham se thay doi gia tri cua vung nho ma $a0 tro toi.
# Cac tham so $a0, $a1 co the bi thay doi.
# Tra ve:
#	$v0: dia chi vung nho chua chuoi TIME da dinh dang.
convert:
	addi $t0, $0, 65
	bne $t0, $a1, convert_type_not_a
	# swap 0 and 3
	lb $t0, 0($a0)
	lb $t1, 3($a0)
	sb $t1, 0($a0)
	sb $t0, 3($a0)
	# swap 1 and 4
	lb $t0, 1($a0)
	lb $t1, 4($a0)
	sb $t1, 1($a0)
	sb $t0, 4($a0)
	j convert_return

	convert_type_not_a:
	# backup if type not A
		addi $sp, $sp, -8
		sw $s0, 4($sp)
		sw $ra, 0($sp)
	
		add $s0, $a0, $0
	# process if type not A
		sb $0, 12($s0)		# add '\0' to the end
		# t2 : MM	
		lb $t2, 3($s0)		
		addi $t2, $t2, -48
		addi $t0, $0, 10
		mult $t2, $t0
		mflo $t2
		lb $t0, 4($s0)
		addi $t0, $t0, -48
		add $t2, $t2, $t0
		# insert (, YYYY)
		lb $t0, 9($s0)
		sb $t0, 11($s0)
		lb $t0, 8($s0)
		sb $t0, 10($s0)
		lb $t0, 7($s0)
		sb $t0, 9($s0)
		lb $t0, 6($s0)
		sb $t0, 8($s0)
		addi $t0, $0, 0x2c 	# comma and space
		sb $t0, 6($s0)
		addi $t0, $0, 0x20
		sb $t0, 7($s0)

		addi $t0, $0, 66	
		beq $t0, $a1, convert_type_b

		# type_c:
		addi $t0, $0, 32	# space
		sb $t0, 2($s0)
		
		addi $a1, $s0, 3
		add $a0, $t2, $0	
		jal mm_to_month	
		
		j convert_restore

		convert_type_b:
			lb $t0, 0($s0)	# DD
			sb $t0, 4($s0)
			lb $t0, 1($s0)
			sb $t0, 5($s0)

			addi $t0, $0, 32
			sb $t0, 3($s0)
			
			add $a1, $s0, $0
			add $a0, $t2, $0
			jal mm_to_month

	# restore if type not A and return
	convert_restore:
		add $v0, $s0, $0 	
		lw $s0, 4($sp)
		lw $ra, 0($sp)
		addi $sp, $sp, 8
		jr $ra
# return
	convert_return:
		add $v0, $a0, $0
		jr $ra

# Ham chuyen MM sang Month ( vd: 01 --> "JAN" )
# Tham so:
#	$a0: so thang (vd: 1)
#	$a1: dia chi chuoi can ghi
# Ham dam bao se khong thay doi $a0 va $a1
mm_to_month:
	addi $t0, $0, 1
	beq $a0, $t0, mm_to_month_1
	addi $t0, $t0, 1
	beq $a0, $t0, mm_to_month_2
	addi $t0, $t0, 1
	beq $a0, $t0, mm_to_month_3
	addi $t0, $t0, 1
	beq $a0, $t0, mm_to_month_4
	addi $t0, $t0, 1
	beq $a0, $t0, mm_to_month_5
	addi $t0, $t0, 1
	beq $a0, $t0, mm_to_month_6
	addi $t0, $t0, 1
	beq $a0, $t0, mm_to_month_7
	addi $t0, $t0, 1
	beq $a0, $t0, mm_to_month_8
	addi $t0, $t0, 1
	beq $a0, $t0, mm_to_month_9
	addi $t0, $t0, 1
	beq $a0, $t0, mm_to_month_10
	addi $t0, $t0, 1
	beq $a0, $t0, mm_to_month_11
	# mm_to_month_12:
	lui $t1, 0x2043
	ori $t1, 0x4544
	j mm_to_month_return
	mm_to_month_1:
		lui $t1, 0x204e
		ori $t1, 0x414a
		j mm_to_month_return
	mm_to_month_2:
		lui $t1, 0x2042
		ori $t1, 0x4546
		j mm_to_month_return
	mm_to_month_3:
		lui $t1, 0x2052
		ori $t1, 0x414d
		j mm_to_month_return
	mm_to_month_4:
		lui $t1, 0x2052
		ori $t1, 0x5041
		j mm_to_month_return
	mm_to_month_5:
		lui $t1, 0x2059
		ori $t1, 0x414d
		j mm_to_month_return
	mm_to_month_6:
		lui $t1, 0x204e
		ori $t1, 0x554a
		j mm_to_month_return
	mm_to_month_7:
		lui $t1, 0x204c
		ori $t1, 0x554a
		j mm_to_month_return
	mm_to_month_8:
		lui $t1, 0x2047
		ori $t1, 0x5541
		j mm_to_month_return
	mm_to_month_9:
		lui $t1, 0x2050
		ori $t1, 0x4553
		j mm_to_month_return
	mm_to_month_10:
		lui $t1, 0x2054
		ori $t1, 0x434f
		j mm_to_month_return
	mm_to_month_11:
		lui $t1, 0x2056
		ori $t1, 0x4f4e
	mm_to_month_return:
		sb $t1, 0($a1)
		srl $t1, $t1, 8
		sb $t1, 1($a1)
		srl $t1, $t1, 8
		sb $t1, 2($a1)
		jr $ra	
exit: