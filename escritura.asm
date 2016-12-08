.data
	file: .asciiz "salida.txt"
	buffer: .space 13
.text
	main:
		move $s0, $v0
		move $a1, $s0
		li $a0,2347
		jal int_to_string
		move $t9, $v0
		li $v0,4
		move $a0,$t9
		syscall
	b end
	
	end:
		li $v0,10
		syscall
	
	
	#Esta funcion se encarga de convertir un numero entero de 32 bits de representacion en base 10
	#a un string en ASCII
	#Entrada: 	$a0 -> un numero entero de 32 bits base 10
	#Salida:  	$v0 -> respresentacion string ASCII del número
	int_to_string:
		move $v1, $ra
		move $t0,$a0 #numero
		li $v0,0 # retorno
		li $t2, 10 # base
		la $t9, buffer #string buffer
		addi $t9, $t9,12 # correr indice de escritura en buffer a la ultima posicion
		li $t6, 10
		sb $t6,($t9)
		addi $t9, $t9,-1
		slt $a0, $t0,$zero
		beq $a0,1,negativo_int_string
			addi $k0,$zero,0
			b while_int_to_string
		negativo_int_string:
			addi $k0,$zero,1
			mul $t0,$t0,-1
			b while_int_to_string
		while_int_to_string:
			seq $t1,$t0,$zero
			beq $t1,1, coef_cero #while(num != 0)
			div $t0,$t2 # num/10
			mfhi $a0 #resto
			jal int_to_character
			move $t3,$v0
			
			#insertar al buffer
			sb $t3,($t9)
			#siguiente psicion buffer
			addi $t9,$t9,-1
			mflo $t0 # siguiente = coeficiente
			b while_int_to_string
		coef_cero:
			bne $k0, 1, terminar_int_string
			li $t3,45
			sb $t3,($t9)
			move $v0,$t9
			move $ra, $v1
			jr $ra
		terminar_int_string:
			addi $t9,$t9,1
			move $v0,$t9
			move $ra, $v1
			jr $ra
		
		
	#Esta funcion se encarga de convertir un dígito entero base 10 a su representación de caracter ASCII
	#Entrada:	$a0-> un digito numerico entero
	#Salida:	$v0-> un valor de caracter ASCII
	int_to_character:
		addi $v0, $a0,48
		jr $ra

	