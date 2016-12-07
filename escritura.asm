.data
	file: .asciiz "salida.txt"
	buffer: .space 32
.text
	main:
		#la   $t0, buffer
		
		#addi $t0, $t0,0
		
		#la $t1, buffer
		#sb $zero, 1($t0) #salto de linea al final
		#li   $t1, 49  
		#sb   $t1, ($t0)
		#addi $t0, $t0,-1
		#li   $t1, 50  
		#sb   $t1, ($t0)
		#addi $t0, $t0,-1
		#li   $t1, 51  
		#sb   $t1, ($t0)
		#addi $t0, $t0,-1
		#li   $t1, 52  
		#sb   $t1, ($t0)
		
		#insertar caracter a string
		#addi $t0, $t0,-1
		#li $t1,'2'
		#sb $t1, ($t0)
		##########################
		
		#li $v0,4
		#move $a0, $t0
		#syscall
	
	
		li $a0, 123456
		jal int_to_string
		move $a0,$v0
		li $v0,4
		syscall
###############################################################
  	# Open (for writing) a file that does not exist
	li   $v0, 13       # system call for open file
  	la   $a0, file     # output file name
  	li   $a1, 1        # Open for writing (flags are 0: read, 1: write)
  	li   $a2, 0        # mode is ignored
 	syscall            # open a file (file descriptor returned in $v0)
  	move $s6, $v0      # save the file descriptor 
  	###############################################################
  	# Write to file just opened
  	li   $v0, 15       # system call for write to file
  	move $a0, $s6      # file descriptor 
  	la   $a1, buffer   # address of buffer from which to write
  	li   $a2, 44       # hardcoded buffer length
  	syscall            # write to file
  	li   $v0, 15       # system call for write to file
	move $a0, $s6      # file descriptor 
  	la   $a1, buffer   # address of buffer from which to write
  	syscall
  	###############################################################
  	# Close the file 
  	li   $v0, 16       # system call for close file
  	move $a0, $s6      # file descriptor to close
  	syscall            # close file
  	###############################################################
	b end
	
	end:
		li $v0,10
		syscall
	
	
	#Esta funcion se encarga de convertir un numero entero de 32 bits de representacion en base 10
	#a un string en ASCII
	#Entrada: 	$a0 -> un numero entero de 32 bits base 10
	#Salida:  	$v0 -> respresentacion string ASCII del número
	int_to_string:
		addi $sp, $sp,-12
		sw $ra, 8($sp)
		addi $t6, $zero,10
		#la   $t9, buffer #carga de buffer a $t9
		#addi $t9,$t9,30
		#la $t8, buffer
		#sb $zero, 1($t9)
		
		la   $t0, buffer
		addi $t0, $t0,0
		la $t1, buffer
		sb $zero, 1($t0) #salto de linea al final
		
		blt $a0, $zero, numero_negativo_int_to_string
		#NUMERO POSITIVO
		move $t5,$a0
		loop_int_to_string:
			div  $t5,$t6 #numero / 10
			mflo $t5 #cuociente
			mfhi $t7 #resto
			###cambiar digito a character
			sw $t0,0($sp)
			sw $t1,4($sp)
			move $a0,$t7
			jal int_to_character
			move $t7,$v0
			lw $t0,0($sp)
			lw $t1,4($sp)
			#insertar caracter a string
			
			
			move   $t1, $t7
			sb   $t1, ($t0)
			addi $t0, $t0,-1
			#li   $t1, 50  
			#sb   $t1, ($t0)
			
			##########################
			beq $t5,1,end_loop_int_to_string
			
			b loop_int_to_string
		
		end_loop_int_to_string:
			b end_int_to_string
		
		numero_negativo_int_to_string:
		#NUMERO NEGATIVO
		move $t5,$a0
		end_int_to_string:
			lw $ra, 8($sp)
			addi, $sp, $sp, 12
			la $v0, buffer
			jr $ra
		
	#Esta funcion se encarga de convertir un dígito entero base 10 a su representación de caracter ASCII
	#Entrada:	$a0-> un digito numerico entero
	#Salida:	$v0-> un valor de caracter ASCII
	int_to_character:
		addi $t0,$zero,48
		addi $t1, $zero,0
		loop_int_to_character:
			beq $t1,$a0,end_loop_int_to_character
			addi $t0,$t0,1
			addi $t1,$t1,1
			b loop_int_to_character
		end_loop_int_to_character:
		move $v0, $t0
		jr $ra