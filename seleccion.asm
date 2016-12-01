.data
	message: .asciiz "\nEstoy ejecutando sort...\n"
	fallo_arg: .asciiz "\nFaltan o sobran argumentos\n\t java -jar Mars4_4.jar seleccion.asm pa [ARCHIVO_ENTRADA] [ARCHIVO_SALIDA]\n"
	mensaje_error_character_to_int: .asciiz "\nEl caracter ASCII está fuera del rango de digitos decimales entre 0 y 9 (48~57)"
	buffer: .space 1048576
	salto_linea: .asciiz "\n"
	file: .asciiz "CP_0.txt"
.text 
	main:
		#INT MAX : 2147483647 
		#Lectura y carga de archivo en lista
		# $a0 tiene a argc y $a1 tiene a argv(lista de argumentos)
		# para acceder a primer elemento de argv lw $t0, 0($a1)
		
		move $s7, $a1
		move $s6, $a0
		#lw $s5, 0($a1)
		#lw $s7, 4($a1)
		addi $t0, $zero, 2
		#Se verifica que el número de argumentos es el correcto
		#bne $s6, $t0, fallo_entrada_argumentos
		#Entra al if 
			#li $v0, 4
			#la $a0,($s5)
			#syscall
			#%la $a0,($s5)
			#syscall
			###############################################################
  				# Open (for writing) a file that does not exist
  				li   $v0, 13       # system call for open file
  				#la   $a0, ($s5)     # output file name
  				la $a0, file
  				li   $a1, 0        # Open for writing (flags are 0: read, 1: write)
  				li   $a2, 0        # mode is ignored
  				syscall            # open a file (file descriptor returned in $v0)
				move $s0, $v0      # save the file descriptor 
				###############################################################
				# Read to file just opened
				li   $v0, 14       # system call for read to file
				move $a0, $s0      # file descriptor 
				la   $a1, buffer   # address of buffer in which to read
				li   $a2, 1048576    # hardcoded buffer length
				syscall            # read to file
				move $s2, $v0
				addi $s2, $s2,-2
				la $s1, buffer	 #$s1 = direccion de buffer, todas las lineas del archivo
				addi $s6,$zero,0
				addi $s5,$zero,0
				add $s4, $zero,$zero #puntero a cabeza de la lista L=NULL
				loop_lectura:
					
					add $t9, $s2,$s1 # obtencion de direccion de caracter
					lb $s3,($t9) #obtencion de numero ascii de caracter desde la direccion
					
					beq  $s3,45,signo_menos # pregunta si existe un signo menos o negativo
					volver_signo_negativo:
					beq $s3,10,encontro_salto # pregunta si existe un salto de linea
					volver_encontro_salto:
					
					#convertir caracter a digito decimal												
					add $a1, $zero, $s3
  					jal character_to_int
  					move $s7, $v0
  					#multiplicar digito decimal por la potencia correspondiente de 10
  					addi $a0, $zero, 10 ##Argumento base
					add $a1, $zero, $s5 ## Argumento exponente
					jal pow
					move $s3,$v1 ##Resultado de potencia
					mul $s3,$s3,$s7 # (DIGITO x 10 ^ potencia)
					add $s6,$s6,$s3  #(DIGITO x 10 ^ potencia) + lo anterior
					addi $s5,$s5,1 					
					beq $s2,0, end_loop_lectura
					subi $s2,$s2,1 
					b loop_lectura					
				
				signo_menos:
					subi $s2,$s2,1
					addi $k0, $zero, 1
					
				encontro_salto:
					beq $k0,1,numero_negativo
					beq $k0,0,numero_positivo
					volver_numero_negativo:
					volver_numero_positivo:					
					b agregar_lista
					
					
				numero_negativo:
					sub $s6, $zero, $s6
					addi $k0, $zero, 0
					b volver_numero_negativo
				
				numero_positivo:
					addi $k0, $zero, 0
					b volver_numero_positivo
					
					
				agregar_lista:
					##ACA DEBO METER EL NUMERO RECIENTEMENTE CREADO EN LA LISTA ENLAZADA
					add $a0, $zero, $s4
					add $a1, $zero, $s6
					jal insertar_inicio
					move $s4,$v0
					#li $v0,1
					#move $a0, $s6
					#syscall
					#li $v0,4
					#la $a0, salto_linea
					#syscall
					addi $s6,$zero,0 #reiniciar suma del numero total
					addi $s5 $zero,0
					subi $s2,$s2,1
					beq $s2,0, end_loop_lectura
					
					b loop_lectura
					
				end_loop_lectura:
				move $s0, $zero
				move $s1, $zero
				move $s2, $zero
				move $s3, $zero
				move $s5, $zero
				move $s6, $zero
				move $s7, $zero
				move $t9, $zero
				move $k0, $zero
				move $k1, $zero
				
				add $a0, $zero, $s4
				jal mostrar_lista
				
				###############################################################
				# Close the file 
				li   $v0, 16       # system call for close file
				move $a0, $s0      # file descriptor to close
				syscall            # close file
				###############################################################
			
								

			
			#Llamar a función (lista debe estar cargada en $a1)
			#
			jal selection_sort

		
		#Llamado a termino del programa
		b end
				
		#Terminar el prgrama
		end:
			li $v0,10
			syscall
		
	#Si la entrada no contiene los suficientes argumentos muestra mensaje de error
	fallo_entrada_argumentos:
		li $v0, 4
		la $a0, fallo_arg
		syscall
		#Llamado a termino del programa
		j end
	
	#Este procedimiento se encarga de ordenar una lista enlazada, con el algoritmo iterativo de seleccion
	#Entrada: $a1 Direccion a una lista enlazada con los elementos enteros
	#Salida: $v0 Direccion a lista ordenada
	selection_sort:
		li $v0,4
		la $a0,message
		syscall
		jr $ra

	

	#Este procedimiento se encarga de convertir un caracter a su representacion decimal
	#Entrada: En $a1 un valor de caracter en código ASCII
	#Salida: En $v0 un valor en representacion decimal para el caracter
	character_to_int:
		blt $a1,48, error_character_to_int
		bgt $a1,57,error_character_to_int
		addi $t0,$zero,47
		addi $v0, $zero, -1
		loop_character_to_int:
			addi $v0,$v0,1
			addi $t0,$t0,1
			bne $a1,$t0,loop_character_to_int
			j end_loop_character_to_int
		error_character_to_int:
			li $v0,4
			la $a0, mensaje_error_character_to_int
			syscall
			li $v0,1
			move $a0,$a1
			syscall
			b end	
		end_loop_character_to_int:
			jr $ra
	
	#Este procedimiento se encarga de obtener la potencia de b^e
	#Entrada: 	$a0-> valor base 
	#		$a1-> valor exponente
	#Salida: 	$v1 -> resultado de potencia
	pow:
		addi $t9,$zero,0
		addi $v1, $zero,1
		loop_pow:
			beq $t9,$zero,primer_pow
			mul $v1,$v1,$a0
			volver_primer_pow:
			beq $t9,$a1,end_loop_pow
			addi $t9,$t9,1
			b loop_pow
		end_loop_pow:
			jr $ra
		primer_pow:
			b volver_primer_pow
			
			
			
	#Este procedidmiento se encarga de crear un nuevo nodo con un dato
	#Entrada: $a0-> dato entero para el nodo
	#Salida: $v0-> Direccion de memoria del nodo
	crear_nodo:
		addi $sp, $sp, -4
		sw $a0, 0($sp)
		addi $v0,$zero,9
		addi $a0,$zero,8
		syscall
		lw $a0, 0($sp)
		sw $a0, 0($v0) #Nodo->dato = dato_argumento
		sw $zero, 4($v0)#Nodo->sig = null o 0 o zero
		addi $sp,$sp,4
		jr $ra
	
	#Este procedimiento se encarga de crear una lista enlazada vacia
	#Entrada: Sin entrada
	#Salida: $v0-> direccion a la lista creada
	crear_lista:
		addi $v0,$zero,9
		addi $a0,$zero,8
		syscall
		sw $zero, 0($v0)
		sw $zero, 4($v0)
		jr $ra
		
	#Este procedimiento se encarga de reconocer si una lista está vacia
	#Entrada: $a0-> direccion de memoria de la lista
	#Salida: $v0-> un valor 1 o 0. 1 si esta vacia 0 si no esta vacia
	es_vacia:
		beq $a0, $zero, lista_vacia
		addi $v0,$zero, 0
		jr $ra
		lista_vacia:
			addi $v0, $zero, 1
			jr $ra
		
		
	#Este procedimiento se encarga de insertar un elemento al INICIO de una lista
	#Entrada: 	$a0-> direccion de memoria de la lista
	#	  	$a1 -> dato a guardar
	#Salida: 	$v0-> nueva direccion de memoria de la lista
	insertar_inicio:
		addi $sp, $sp, -12
		sw $ra, 0($sp)
		sw $a0, 4($sp)
		sw $a1, 8($sp)
		jal es_vacia
		beq $v0, 1, lista_vacia_insertar_inicio
		##lista NO vacia
			add $a0, $zero, $a1
			jal crear_nodo
			
			lw $a0, 4($sp) # $a0 -> puntero primer nodo
			sw $a0, 4($v0) #nuevo->sig = puntero primer nodo			
			b end_insertar_inicio
		
		lista_vacia_insertar_inicio:
		##lista vacia
			add $a0, $zero, $a1
			jal crear_nodo
			b end_insertar_inicio
		end_insertar_inicio:
			lw $k0, 0($sp)
			addi $sp, $sp,12
			jr $k0
			
	#Este procedimiento se encarga de mostrar por panatalla la lista enlazada
	#Entrada:	$a0->direccion de memoria de lista
	#Salida:	Sin salida
	mostrar_lista:
		addi $sp,$sp,-4
		sw $a0, 0($sp)
		move $t2, $a0
		loop_mostrar_lista:
			li $v0,1
			lw $a0,0($t2)
			syscall
			li $v0,4
			la $a0,salto_linea
			syscall
			lw $t0, 4($t2)
			beq $t0,$zero,end_mostrar_lista
			lw $t2, 4($t2)
			b loop_mostrar_lista
		end_mostrar_lista:
			lw $a0, 0($sp)
			addi $sp, $sp, 4
			jr $ra
			
		
		
