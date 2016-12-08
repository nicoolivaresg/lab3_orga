.data
	message: .asciiz "\nEstoy ejecutando sort...\n"
	fallo_arg: .asciiz "\nFaltan o sobran argumentos\n\t java -jar Mars4_4.jar seleccion.asm pa [ARCHIVO_ENTRADA] [ARCHIVO_SALIDA]\n"
	mensaje_error_character_to_int: .asciiz "\nEl caracter ASCII está fuera del rango de digitos enteros es entre 0 y 9 (48~57)"
	buffer: .space 1048576
	salto_linea: .asciiz "\n"
	file: .asciiz "input/CP_0.txt"
	fout: .asciiz "salidaIter.txt"
.text 
	main:
		#INT MAX : 2147483647 
		#Lectura y carga de archivo en lista
		# $a0 tiene a argc y $a1 tiene a argv(lista de argumentos)
		# para acceder a primer elemento de argv lw $t0, 0($a1)
		
		
		
		#bne $a0, 2, fallo_entrada_argumentos
		#lw $s5, 0($a1) #argv[0] entrada
		#addi $sp, $sp,-4
		#lw $s0,4($a1)
		#sw $s0,0($sp) #En el stack guardo la direcion al archivo
				#de salida para escribir luego
		#Entra al if 
		###############################################################
  		# Open (for reading) a file that does not exist
  		li   $v0, 13       # system call for open file
  		lw $a1, 0($sp)
  		#la   $a0, ($s5)     # input file name
  		la $a0, file
  		li   $a1, 0        # Open for reading (flags are 0: read, 1: write)
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
			add $s3,$zero,0
			loop_lectura:
				#beq  $s3,45,numero_negativo # pregunta si existe un signo menos o negativo
				ble $s2,-1, end_loop_lectura
				add $t9, $s2,$s1 # obtencion de direccion de caracter
				lb $s3,($t9) #obtencion de numero ascii de caracter desde la direccion
				beq  $s3,45,numero_negativo # pregunta si existe un signo menos o negativo
				beq $s3,10,encontro_salto # pregunta si existe un salto de linea
				
				#convertir caracter a digito entero												
				add $a1, $zero, $s3
  				jal character_to_int
  				move $s7, $v0
  				#multiplicar digito entero por la potencia correspondiente de 10
  				addi $a0, $zero, 10 ##Argumento base
				add $a1, $zero, $s5 ## Argumento exponente
				jal pow
				move $s3,$v1 ##Resultado de potencia
				mul $s3,$s3,$s7 # (DIGITO x 10 ^ potencia)
				add $s6,$s6,$s3  #(DIGITO x 10 ^ potencia) + lo anterior
				addi $s5,$s5,1 					
				
				continuar_despues_numero_negativo_agregado:
				subi $s2,$s2,1
				b loop_lectura					
								
			encontro_salto:
				bne $k0, 1, agregar_lista					
				addi $k0, $zero, 0
				b continuar_despues_numero_negativo_agregado
				
			numero_negativo:
				sub $s6, $zero, $s6
				addi $k0, $zero, 1
				b agregar_lista
							
			agregar_lista:
				##ACA DEBO METER EL NUMERO RECIENTEMENTE CREADO EN LA LISTA ENLAZADA
				add $a0, $zero, $s4
				add $a1, $zero, $s6
				jal insertar_inicio
				move $s4,$v0
				addi $s6,$zero,0 #reiniciar suma del numero total
				addi $s5 $zero,0
				subi $s2,$s2,1
				#beq $s2,0, end_loop_lectura
				b loop_lectura
			
			end_loop_lectura:
				#AGREGAR EL ULTIMO VALOR positivo, debido a que no tiene salto de linea, no entra antes
				bne $s3, 45, positivo
				b true_end_lectura
				positivo:
				add $a0, $zero, $s4
				add $a1, $zero, $s6
				jal insertar_inicio
				move $s4,$v0
				b true_end_lectura
			true_end_lectura:
			
				
			###############################################################
			# Close the file 
			li   $v0, 16       # system call for close file
			move $a0, $s0      # file descriptor to close
			syscall            # close file
			###############################################################									
			
		#Llamar a función (lista debe estar cargada en $a1)
		#
		move $a0, $s4
		jal selection_sort
		
		lw $a0, 0($sp) #archivo  salida
		addi $sp, $sp,4 
		
		##### ESCRITURA DE LISTA ORDENADA EN ARCHIVO ###
		###############################################################
# Open (for writing) a file that does not exist
  li   $v0, 13       # system call for open file
  #move   $a0, $a0     # output file name
  la $a0, fout
  li   $a1, 1        # Open for writing (flags are 0: read, 1: write)
  li   $a2, 0        # mode is ignored
  syscall            # open a file (file descriptor returned in $v0)
  move $s6, $v0      # save the file descriptor 
  ###############################################################
  # Write to file just opened
  ######## ITERAR LA LISTA PARA IMPRIMIR TODAS LAS LINEAS #########
  move $a0, $s4
  move $a1,$s6
  jal dump_archivo
  ###############################################################
  # Close the file 
  li   $v0, 16       # system call for close file
  move $a0, $s6      # file descriptor to close
  syscall            # close file
  ###############################################################
	
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
	#Entrada: $a0 Direccion a una lista enlazada con los elementos enteros
	#Salida: $v0 Direccion a lista ordenada
	selection_sort:
		addi $sp,$sp,-4
		sw $a0, 0($sp)
		add $t1,$zero, $a0 #aux = L
		add $t0, $zero,0
		#while(aux != null)
		loop_1_selection_sort:
			#if(aux = null)
			beq $t1, $zero, end_loop_1_selection_sort
			#(aux != null)
			add $t0, $zero, $t1 #min = aux
			lw $t2, 4($t1) #aux2 = aux->sig
			#while(aux2 != null)
			loop_2_selection_sort:
				# if(aux2->sig = null)
				beq $t2, $zero, end_loop_2_selection_sort
				#(aux2->sig != null)
					lw $a0, 0($t2) #a0 = aux2->dato
					lw $a1, 0($t0) #a1 = min->dato
					#if (aux->dato >= min->dato)
					bge $a0,$a1, no_cambia_minimo
					# (aux2->dato < min->dato)
					add $t0, $zero, $t2 #min = aux2
				no_cambia_minimo:		
				lw $t2, 4($t2) #aux2 = aux2->sig
				b loop_2_selection_sort
			end_loop_2_selection_sort:
			#ZONA INTERCAMBIO
			lw $a0, 0($t0)
			lw $a1, 0($t1)
			sw $a1, 0($t0)
			sw $a0, 0($t1)
			lw $t1, 4($t1) #aux = aux->sig
			b loop_1_selection_sort
		end_loop_1_selection_sort:
			lw $v0, 0($sp)
			addi $sp, $sp, 4
			jr $ra

	#Este procedimiento se encarga de escribir en un archivo de texto
	#una lista enlazada (utiliza el buffer en .data)
	#Entrada:	$a0 -> lista a guardar
	#		$a1 -> file decriptor
	#Salida:	Sin salida
	dump_archivo:
		move $a2, $a0 #aux
		move $k1,$a1 #guardar file decriptor
		addi $sp, $sp,-4
		sw $ra, 0($sp)
		loop_dump_archivo:
			beq $a2,$zero,end_dump_archivo
			#cargar el dato de la lista en a0
			lw $a0,0($a2)
			addi $sp,$sp,-4
			sw $a2, 0($sp)
			#pasarlo a string
			jal int_to_string
			move $t9,$v0 #string representativo en t9
			#imprimir buffer en archivo
			li $v0,15
			move $a0, $k1
			la   $a1, ($t9)   # address of buffer from which to write
			la $t0, buffer
			sub $t0,$t0,$t9
			mul $t0,$t0,-1
			li $t1,13
			sub $t0,$t1,$t0
			move   $a2, $t0
			syscall
			lw $a2, 0($sp)
			addi $sp,$sp,4
			#  aux = aux->sig
			lw $a2, 4($a2)
			b loop_dump_archivo
		end_dump_archivo:
			lw $ra, 0($sp)
			addi $sp, $sp,4
			jr $ra

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
		seq $a0,$t0,$zero
		beq $a0,1,es_cero_int_string
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
			#agregar simbolo negativo
			li $t3,45
			sb $t3,($t9)
			move $v0,$t9
			move $ra, $v1
			jr $ra
		es_cero_int_string:
			li $t3,48
			sb $t3,($t9)
			move $v0,$t9
			move $ra, $v1
			jr $ra
		terminar_int_string:
			#no tiene simbolo negativo, se devuelve una posicion
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
	
	#Este procedimiento se encarga de convertir un caracter a su representacion entero base 10
	#Entrada: En $a1 un valor de caracter en código ASCII
	#Salida: En $v0 un valor en representacion entero base 10 para el caracter
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
			li $v0,4
			la $a0, salto_linea
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
		addi $sp, $sp, -8
		sw $ra, 0($sp)
		sw $a0, 4($sp)
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
			lw $t0, 0($sp)
			addi $sp, $sp,8
			jr $t0
			
	#Este procedimiento se encarga de insertar un elemento al FINAL de una lista
	#Entrada: 	$a0-> direccion de memoria de la lista
	#	  	$a1 -> dato a guardar
	#Salida: 	$v0-> nueva direccion de memoria de la lista
	insertar_final:
		addi $sp, $sp, -8
		sw $ra, 0($sp)
		sw $a0, 4($sp)
		move $a0, $a0
		jal es_vacia
		beq $v0, 1, lista_vacia_insertar_final
		##lista NO vacia
			add $a0, $zero, $a1
			jal crear_nodo
			move $t9, $v0
			
			lw $t2, 4($sp)
			loop_insertar_final:
				lw $t0, 4($t2)
				beq $t0,$zero,end_loop_insertar_final
					lw $t2, 4($t2)
				b loop_insertar_final
			end_loop_insertar_final:
				sw $t9, 4($t2)		
				b end_insertar_final
		
		lista_vacia_insertar_final:
		##lista vacia
			add $a0, $zero, $a1
			jal crear_nodo
			lw $t0, 0($sp)
			addi $sp, $sp,8
			jr $t0
		end_insertar_final:
			lw $t0, 0($sp)
			lw $v0, 4($sp)
			addi $sp, $sp,8
			jr $t0
			
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
			
		
		
