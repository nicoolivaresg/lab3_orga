.data 
	message: .asciiz "\nEstoy ejecutando sort...\n"
	fallo_arg: .asciiz "\nFaltan o sobran argumentos\n\t java -jar Mars4_4.jar busqueda_lineal.asm pa [ARCHIVO_ENTRADA] [ARCHIVO_SALIDA]\n"
	error_posicion_negativa_insertar_posicion: .asciiz "\nError en procedimiento insertar_posicion: Posicion otorgada fuera de rango, es negativa\n"
	error_posicion_mayor_insertar_posicion: .asciiz "\nError en procedimiento insertar_posicion: Posicion otorgada fuera de rango, es mayor al numero de datos\n"
	error_posicion_negativa_dato_en_posicion: .asciiz "\nError en procedimiento dato_en_posicion: Posicion otorgada fuera de rango, es negativa\n"
	error_posicion_mayor_dato_en_posicion: .asciiz "\nError en procedimiento dato_en_posicion: Posicion otorgada fuera de rango, es mayor al numero de datos\n"
	mensaje_error_character_to_int: .asciiz "\nEl caracter ASCII está fuera del rango de digitos decimales entre 0 y 9 (48~57)"
	buffer: .space 1048576
	salto_linea: .asciiz "\n"
	file: .asciiz "prueba_cache.txt"
	fout: .asciiz "salidaRec.txt"
.text
	main:
	#Entra al if
		###############################################################
  		# Open (for reading) a file that does not exist
  		li   $v0, 13       # system call for open file
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
			li $k1,0
			loop_lectura:
				#beq  $s3,45,numero_negativo # pregunta si existe un signo menos o negativo
				ble $s2,-1, end_loop_lectura
				add $t9, $s2,$s1 # obtencion de direccion de caracter
				lb $s3,($t9) #obtencion de numero ascii de caracter desde la direccion
				beq  $s3,45,numero_negativo # pregunta si existe un signo menos o negativo
				beq $s3,10,encontro_salto # pregunta si existe un salto de linea

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
				addi $k1,$k1,1
				addi $s6,$zero,0 #reiniciar suma del numero total
				addi $s5 $zero,0
				subi $s2,$s2,1

				b loop_lectura

			end_loop_lectura:
				#AGREGAR EL ULTIMO VALOR positivo, debido a que no tiene salto de linea, no entra antes
				bne $s3, 45, positivo
				b true_end_lectura
				positivo:
				addi $k1,$k1,1
				b true_end_lectura
			true_end_lectura:

			move $s5, $k1
			###############################################################
			# Close the file
			li   $v0, 16       # system call for close file
			move $a0, $s0      # file descriptor to close
			syscall            # close file
			###############################################################
		li $v0,1
		move $a0, $s5
		syscall
		
		move $a0 ,$zero
		move $a1 ,$zero
		move $a2 ,$zero
		move $a3 ,$zero
		move $t0 ,$zero
		move $t1 ,$zero
		move $t2 ,$zero
		move $t3 ,$zero
		move $t4 ,$zero
		move $t5 ,$zero
		move $t6 ,$zero
		move $t7,$zero
		move $t8 ,$zero
		move $t9 ,$zero
		move $s0 ,$zero
		move $s1 ,$zero
		move $s2 ,$zero
		move $s3 ,$zero
		move $s6 ,$zero
		
		#Se conoce el numero de elementos en s5
		li $v0,9
		mul $a0, $s5,4
		syscall
		move $s4, $v0

		move $k1,$s5
		###############################################################
  		# Open (for reading) a file that does not exist
  		li   $v0, 13       # system call for open file
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
			#li $k1,0
			loop_lectura2:
				#beq  $s3,45,numero_negativo # pregunta si existe un signo menos o negativo
				ble $s2,-1, end_loop_lectura2
				add $t9, $s2,$s1 # obtencion de direccion de caracter
				lb $s3,($t9) #obtencion de numero ascii de caracter desde la direccion
				beq  $s3,45,numero_negativo2 # pregunta si existe un signo menos o negativo
				beq $s3,10,encontro_salto2 # pregunta si existe un salto de linea

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

				continuar_despues_numero_negativo_agregado2:
				subi $s2,$s2,1
				b loop_lectura2

			encontro_salto2:
				bne $k0, 1, agregar_lista2
				addi $k0, $zero, 0
				b continuar_despues_numero_negativo_agregado2

			numero_negativo2:
				sub $s6, $zero, $s6
				addi $k0, $zero, 1
				b agregar_lista2

			agregar_lista2:
				##ACA DEBO METER EL NUMERO RECIENTEMENTE CREADO EN LA LISTA ENLAZADA
				mul $a1,$k1,4
				add $a0, $s4,$a1
				sw $s6, ($a0)
				addi $k1,$k1,-1
				addi $s6,$zero,0 #reiniciar suma del numero total
				addi $s5 $zero,0
				subi $s2,$s2,1

				b loop_lectura2

			end_loop_lectura2:
				#AGREGAR EL ULTIMO VALOR positivo, debido a que no tiene salto de linea, no entra antes
				bne $s3, 45, positivo2
				b true_end_lectura2
				positivo2:
				add $a0, $s4,$k1
				sw $s6, ($a0)
				addi $k1,$k1,-1
				b true_end_lectura2
			true_end_lectura2:

			###############################################################
			# Close the file
			li   $v0, 16       # system call for close file
			move $a0, $s0      # file descriptor to close
			syscall            # close file
			###############################################################



	#Estructura vector
	# Dirección a primer elemento del arreglo
	# Tamaño acutal
	# Tamaño disponible en arreglo (Cada vector tiene un tamaño predefinido inicial de 10 espacios)
#	li $a0,8
#	li $v0,9
#	syscall
##	# s0 = datos
#	sw $zero, 0($s0)
#	# s1 = n 
#	sw $zero, 4($s0)

		
		
#		li $a0, 5
#		jal crear_vector

		
		b end
	end:
		li $v0,10
		syscall 
		
	#Este procedimiento se encarga de contruir un Vector
	#Entrada:	$a0 -> cantidad de elementos iniciales n
	#Salida: 	$v0 -> Dirección de memoria a Vector
	crear_vector:
		slt $t0, $a0,$zero
		beq $t0, 1, negativo_crear_vector
		seq $t0,$a0,0
		beq $t0,1, cero_crear_vector
			#N espacios 
			sw $a0, 4($s0)#nelementos = n
			#Arreglo de n espacios
			add $a0,$zero, $a0
			li $v0,9
			syscall
			sw $v0, 0($s0) #datos = new datos[n]
			move $v0, $s0
			jr $ra
		negativo_crear_vector:
			move $v0,$zero
			jr $ra
		cero_crear_vector:
			move $v0,$zero
			jr $ra
		
	#Este procedimiento se encarga de copiar un Vector original
	# a otro Vector copia.
	#Entrada:	$a0 -> Direccion de Vector Original
	#Salida: 	$v0 -> Dirección de Vector Copiado
	crear_vector_1:
		move $k0,$a0
		lw $t0,4($a0) #original.nelementos
		sw $t0, 4($s0) #nelementos = original.nelementos
		lw $t0, 4($s0)
		ble $t0,0,else_crear_vector_1
		li $v0,9
		lw $a0, 4($s0)
		syscall # new int[nelementos]
		sw $v0, 0($s0) #datos = new int[nelementos]
		li $t5,0
		lw $t2,0($s0) #datos
		lw $t3,0($k0) #original.datos
		for_crear_vector_1:
			lw $t0, 4($s0)
			bgt $t5,$t0, salir_for_crear_vector_1
			
			add $t2,$t2,$t5 #datos+i
			add $t3,$t3,$t5 #original.datos+i
			
			lw $t4, ($t3) #original.datos[i]
			sw $t4,($t2) #datos[i] = original.datos[i]
			addi $t5,$t5,1
			b for_crear_vector_1
		salir_for_crear_vector_1:
			move $v0,$s0
			jr $ra
		else_crear_vector_1:
			sw $zero, 0($s0) #datos = 0
			jr $ra

	#Este procedimiento se encarga de entregar el tamaño actual del Vector
	#Entrada:	$a0 -> Direccion de Vector
	#Salida:	$v0 -> Valor con tamaño actual de Vector
	size:
		lw $v0, 4($s0)
		jr $ra
		
	#Este procedimiento se encarga de realizar la operacion de acceso Vector[i]
	#Entrada:	$a0 -> posicion i
	#Salida:	$v0 -> valor en datos[i]
	acceso:
		lw $a1,4($s0)
		sgt $t0,$a0,0
		slt $t1,$a0,$a1
		mul $t0,$t0,$t1
		bne $t0,1,no_cumple
		lw $t2, 0($s0)
		add $t2,$t2,$a0
		lw $v0,($t2)
		jr $ra	
		no_cumple:
		jr $ra
	
	#Este procedimiento se encarga de copiar en el Vector que hace el llamado, el vector original proporcionado
	#Entrada:	$a0 -> Direccion a Vector Original
	#Salida:	$v0 -> Direccion a Vector Copiado
	igual_a:
		move $k0,$a0
		beq $a0,$s0,son_iguales
		lw $t0,4($s0)
		ble $t0,0,nelementos_menor_o_igual
		lw $a0,0($s0)
		jal delete
		lw $t0,4($k0)#original.nelementos
		sw $t0,4($s0)#nelementos = original.nelementos
		lw $t1,0($s0)#datos
		lw $t2,0($k0)#original.datos
		li $t5,0
		for_igual_a:
		bge $t5,$t0,end_for_igual_a
		add $t1,$t1,$t5
		add $t2,$t2,$t5
		
		lw $t3,($t2)
		sw $t3,($t1)
		
		addi $t5,$t5,1
		b for_igual_a
		end_for_igual_a:
		nelementos_menor_o_igual:
		move $v0, $s0
		jr $ra
		son_iguales:
			jr $ra
	
	#Este procedimiento se encarga de hacer la reorganización de tamaño de un Vector
	#Entrada:	$a0 -> numero n de elementos nuevos
	#Salida:	Sin salida
	resize:
		#move $k1, $a0
		lw $t0,4($s0) #t1 = nelementos
		blt $a0,0, nada_resize 
		beq $a0,$t0,nada_resize
		beq $a0,0, else_cero
		move $a0, $a0
		li $v0, 9
		syscall # v0 = arreglo n elementos
		move $k0,$v0 
		lw $t1, 4($s0) #nelementos
		ble $t1,0,menor_igual_resize
		slt $k1,$t1,$a0
		bne $k1, 1, minimo_n
			move $k1,$t1
			b seguir_minimo
		minimo_n:
			move $k1,$a0
		seguir_minimo:
		li $t5,0
		lw $t0, 0($s0) #t0 = datos
		move $t6,$t0
		move $t7,$k0
		for_resize:
			bge $t5,$k1,end_for_resize
			add $k0,$k0,$t5 #nuevos_datos = nuevos_datos+i
			add $t0,$t0,$t5 #datos = datos+i
			lw $t8,($t0)
			sw $t8,($k0)
			addi $t5,$t5,1
			b for_resize
		end_for_resize:
		move $a0,$t6
		jal delete
		sw $v0, 0($s0)
		menor_igual_resize:
			sw $k1,4($s0)
			sw $v0, 0($s0)
			jr $ra
		else_cero:
			ble $a0,0,nada_else_cero	
			lw $a0, 0($s0)
			jal delete
			sw $zero, 0($s0)
			sw $zero,4($s0)
			jr $ra
		nada_else_cero:
			jr $ra
		n_negativo:
			jr $ra
		nada_resize:
			jr $ra
	
	#Este procedimiento se encarga de vaciar un Vector
	#Entrada:	$a0 -> Direccion de Vector
	#Salida:	Sin salida
	vaciar:
		lw $t0, 4($s0)
		lw $t1, 0($s0)
		ble $t0,0, pasar_vaciar
		move $a0, $t1
		jal delete
		sw $v0, 0($s0)
		sw $zero, 4($s0)
		jr $ra
		pasar_vaciar:
		 jr $ra
	
	
	
		
	
			
	#Estre procedimiento se encarga de hacer un delete[] de un arreglo
	#Entrada:	$a0 -> Direccion arreglo a vaciar
	#		$a1 -> Tamaño de arreglo
	#Salida:	$v0 ': Direccion arreglo vaciado
	delete:
		move $t0,$a0
		li $t5,0
		for_delete:
		bge $t5,$a1,end_for_delete
		add $t0,$t0,$t5
		sw $zero, ($t0)
		addi $t5,$t5,1
		b for_delete
		end_for_delete:
		move $v0,$a0
		jr $ra
		
	#Este procedimiento se encarga de ordenar un Vector 
	# mediante el algoritmo de merge sort
	#Entrada:	$a0 -> Direccion de Vector para ordenar
	#		$a1-> Posicion inicio
	#		$a2-> Posicion final
	#Salida:	$v0 -> Direccion de Vector ordenado
	merge_sort:
		bge $a1,$a2, no_entra_merge_sort
		addi $s7,$s7,1
		add $t1,$a1,$a2 # t1= inicio+final
		div $t1,$t1,2 #t1 = (inicio+final)/2
			
		
		addi $sp,$sp,-20 #reserva en el stack
		sw $ra ,0($sp) #direccion antes de llamado
		sw $a0,4($sp) #cabeza lista
		sw $a1,8($sp) #inicio
		sw $a2,12($sp) #fin 
		sw $t1,16($sp) #medio
		move $a0, $a0
		move $a1,$a1 #inicio =inicio
		move $a2,$t1 #fin = medio
		
		jal merge_sort
		
		lw $a0,4($sp)#cabez
		lw $a1,8($sp)#inicio
		lw $a2,12($sp)#fin
		lw $t1, 16($sp)#medio

		
				
		
		addi $sp, $sp,-20
		sw $ra ,0($sp) #direccion antes de llamado
		sw $a0,4($sp) #cabeza lista
		sw $a1,8($sp) #inicio =medio+1
		sw $a2,12($sp) #fin =fin
		sw $t1,16($sp) #guardar medio
		
		move $a0, $a0
		addi $a1, $t1,1
		move $a1,$a1 #inicio =medio+1
		move $a2,$a2 #fin = fin
		
		jal merge_sort
		
					
		lw $a0,4($sp)#cabeza
		lw $a1,8($sp)#incio
		lw $a2,12($sp)#fin
		lw $t1,16($sp)#medio
		addi $sp, $sp,20
		move $a0, $a0
		move $a1,$a1 #inicio=inicio
		move $a3,$a2 #fin = fin
		move $a2, $t1 #medio = medio
		
		jal combinar
		move $v0,$a0
		lw $ra, 0($sp)
		addi $sp,$sp,40
		jr $ra
		no_entra_merge_sort:
		move $v0,$a0
		jr $ra
		
		
	#Este procedimiento se encarga de combinar los Vector del procedimiento de merge_sort
	#Entrada: 	$a0-> Direccion a Vector
	#		$a1-> inicio
	#		$a2-> medio
	#		$a3-> final
	#Salida: 	$v0-> Direccion a Vector ordenado
	combinar:
		move $t9, $a0
		move $k0, $a1
		move $k1, $a3
		move $a0, $s5
		
		add $sp, $sp,-12
		sw $a1, 0($sp)
		sw $a2, 4($sp)
		sw $a3, 8($sp)


		move $t0,$s6  #Aux
		move $t1,$a1 #h = inicio
		move $t2,$a1 #i= inicio
		addi $t3,$a2,1 #j = medio+1
		addi $t4,$zero,0 #k = 0
		

		loop_recorre_ambas_sublistas:
			sle  $a0,$t2,$a2 #¿i <= medio ?
			sle  $a1,$t3,$a3 #¿j <= fin ? 
			mul $a0, $a0,$a1 # 1 si lo anterior se cumple
			bne $a0,1,end_loop_recorre_ambas_sublistas #while
			#move $a0, $t9 
			#move $a1, $t2
			move $a0, $t2
			jal acceso
			#jal dato_en_posicion # Buscar A[i]
			lw $a1, 0($sp)
			lw $a2, 4($sp)
			lw $a3, 8($sp)
			move $t8, $v0 #A[i]
			#move $a0,$t9 
			#move $a1, $t3
			move $a0, $t3
			jal acceso
			#jal dato_en_posicion #Buscar A[j]
			lw $a1, 0($sp)
			lw $a2, 4($sp)
			lw $a3, 8($sp)
			move $t7,$v0 #A[j]
			sle $a0,$t8,$t7 #¿A[i]<= A[j]?
			bne $a0,1,sino_sublista #if (A[i]>A[j]) goto else
				move $a0, $t0 # t0 es Aux
				move $a1, $t8 # t8 es A[i]
				move $t8, $a2
				move $a2, $t1 # t1 es h
				move $a0, $s6
				#jal cambiar_valor_en_p #Aux[h] = A[i]
				lw $a1, 0($sp)
				lw $a2, 4($sp)
				lw $a3, 8($sp)		
				move $t0,$v0 
				move $a2,$t8
				addi $t2,$t2,1 # i=i+1
				b avanzar_h
			sino_sublista:  #else
				move $a0, $t0 # t0 es Aux
				move $a1, $t7 # t7 es A[j]
				move $t8, $a2
				move $a2, $t1 # t1 es h
				move $a0, $s6		
				#jal cambiar_valor_en_p
				lw $a1, 0($sp)
				lw $a2, 4($sp)
				lw $a3, 8($sp)
				move $t0,$v0
				move $a2, $t8
				addi $t3,$t3,1 # j =j+1
				b avanzar_h
			avanzar_h:
				addi $t1,$t1,1 # h= h+1
				b  loop_recorre_ambas_sublistas
		end_loop_recorre_ambas_sublistas:
		sgt $a0,$t2,$a2
		beq $a0,0, seguir
			move $t4, $t3
			for_1:
				sne $a0,$t4,$a3 #¿k>fin?
				beq $a0,1,end_for_1
				move $a0, $t9 #A
				move $a1,$t4 # k
				#jal dato_en_posicion #Buscar A[k]
				lw $a1, 0($sp)
				lw $a2, 4($sp)
				lw $a3, 8($sp)
				move $t8,$v0 
				move $a0, $t0  # Aux
				move $a1, $t8 # A[k]
				move $t8, $a2
				move $a2, $t1 # h
				move $a0, $s6		
				#jal cambiar_valor_en_p
				lw $a1, 0($sp)
				lw $a2, 4($sp)
				lw $a3, 8($sp)
				move $t0,$v0
				move $a2, $t8
				addi $t4,$t4,1 #k=k+1
				addi $t1,$t1,1 #h=h+1
				b for_1

		seguir:
			move $t4, $t2
			for_2:
				sgt $a0,$t4,$a2  #¿k>medio?
				beq $a0,1,end_for_2
				move $a0, $t9 #A
				move $a1,$t4 # k	
				#jal dato_en_posicion #Buscar A[k]
				lw $a1, 0($sp)
				lw $a2, 4($sp)
				lw $a3, 8($sp)
				move $t8,$v0 
				move $a0, $t0  # Aux
				move $a1, $t8 # A[k]
				move $t8, $a2
				move $a2, $t1 # h
				move $a0, $s6				
				#jal cambiar_valor_en_p							
				lw $a1, 0($sp)
				lw $a2, 4($sp)
				lw $a3, 8($sp)				
				move $t0,$v0
				move $a2, $t8
				addi $t4,$t4,1 #k=k+1
				addi $t1,$t1,1 #h=h+1
				b for_2
		end_for_1:
		end_for_2:
		move $t8,$t9 #L sin cammbios
		move $t0,$t0 #arreglo aux
		move $t4, $k0
			for_3:
				sgt $a0,$t4,$a3
				beq $a0,1,end_for_3
				move $a0, $t0 #Aux
				move $a1,$t4 # k
				move $a0, $s6
				#jal obtener_valor_en_p
				lw $a1, 0($sp)
				lw $a2, 4($sp)
				lw $a3, 8($sp)		
				move $t8,$v0
				move $a0, $t9 #A
				move $a1, $t8 #A[k]
				move $t8, $a2
				move $a2, $t4 # k
				#jal insertar_posicion #A[k] = Aux[k]
				lw $a1, 0($sp)
				lw $a2, 4($sp)
				lw $a3, 8($sp)
				move $t9,$v0
				move $a2, $t8
				addi $t4,$t4,1 #k=k+1
				b for_3
		end_for_3:
		move $a0,$s6
		move $a1, $s5
		#jal vaciar_arreglo
		addi $sp,$sp,12
		move $v0, $t9
		lw $ra, 0($sp)
		addi $sp, $sp,20
		jr $ra


	#Esta funcion se encarga de convertir un dígito entero base 10 a su representación de caracter ASCII
	#Entrada:	$a0-> un digito numerico entero
	#Salida:	$v0-> un valor de caracter ASCII
	int_to_character:
		addi $v0, $a0,48
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