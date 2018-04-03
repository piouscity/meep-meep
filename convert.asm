# Ham chuyen doi dinh dang
# Tham so:
#	$a0: chuoi TIME
#	$a1: kieu dinh dang ('A', 'B' hoac 'C')
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
		addi $sp, $sp, -12
		sw $a1, 8($sp)
		sw $a0, 4($sp)
		sw $ra, 0($sp)
	# process if type not A
		sb $0, 12($a0)		# add '\0' to the end
		# t2 : MM	
		lb $t2, 3($a0)		
		addi $t2, $t2, -48
		addi $t0, $0, 10
		mult $t2, $t0
		mflo $t2
		lb $t0, 4($a0)
		addi $t0, $t0, -48
		add $t2, $t2, $t0
		# insert (, YYYY)
		lb $t0, 9($a0)
		sb $t0, 11($a0)
		lb $t0, 8($a0)
		sb $t0, 10($a0)
		lb $t0, 7($a0)
		sb $t0, 9($a0)
		lb $t0, 6($a0)
		sb $t0, 8($a0)
		addi $t0, $0, 0x2c 	# comma and space
		sb $t0, 6($a0)
		addi $t0, $0, 0x20
		sb $t0, 7($a0)

		addi $t0, $0, 66	
		beq $t0, $a1, convert_type_b

		# type_c:
		addi $t0, $0, 32	# space
		sb $t0, 2($a0)
		
		addi $a1, $a0, 3
		add $a0, $t2, $0	
		jal mm_to_month	
		
		j convert_restore

		convert_type_b:
			lb $t0, 0($a0)	# DD
			sb $t0, 4($a0)
			lb $t0, 1($a0)
			sb $t0, 5($a0)

			addi $t0, $0, 32
			sb $t0, 3($a0)
			
			add $a1, $a0, $0
			add $a0, $t2, $0
			jal mm_to_month

	# restore if type not A
	convert_restore:
		lw $a1, 8($sp)
		lw $a0, 4($sp)
		lw $ra, 0($sp)
		addi $sp, $sp, 12
# return
	convert_return:
		add $v0, $a0, $0
		jr $ra

# Ham chuyen MM sang Month ( vd: 01 --> "JAN" )
# Tham so:
#	a0: so thang (vd: 1)
#	a1: dia chi chuoi can ghi
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