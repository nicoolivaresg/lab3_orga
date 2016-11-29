.data
	message: .asciiz "Estoy ejecutando sort..."
	fallo_arg: .asciiz "Faltan o sobran argumentos\n\t java -jar Mars4_4.jar seleccion.asm pa [ARCHIVO_ENTRADA] [ARCHIVO_SALIDA]\n"
.text 
	main:
		#Lectura y carga de archivo en lista
		# $a0 tiene a argc y $a1 tiene a argv(lista de argumentos)
		# para acceder a primer elemento de argv lw $t0, 0($a1)
		
		lw $s5, 0($a1)
		lw $s7, 4($a1)
		move $s7, $a1
		move $s6, $a0
		addi $t0, $zero, 2
		#Se verifica que el número de argumentos es el correcto
		bne $s6, $t0, fallo_entrada_argumentos
		#Entra al if 
			li $v0, 4
			la $a0,($s5)
			syscall
			la $a0,($s5)
			syscall
			

		
		#Llamado a termino del programa
		j end
		
		#Si la entrada no contiene los suficientes argumentos muestra mensaje de error
		fallo_entrada_argumentos:
			li $v0, 4
			la $a0, fallo_arg
			syscall
			#Llamado a termino del programa
			j end
			
			
		
		
		#Llamar a función (lista debe estar cargada en lista enlazada)
		jal selection_sort
		
		
		#Terminar el prgrama
		end:
			li $v0,10
			syscall
		
	
	
	
	selection_sort:
		li $v0,4
		la $a0,message
		syscall
		jr $ra