.data
	salto_linea: .asciiz "\n"
	error_posicion_negativa_insertar_posicion: .asciiz "\nError en procedimiento insertar_posicion: Posicion otorgada fuera de rango, es negativa\n"
	error_posicion_mayor_insertar_posicion: .asciiz "\nError en procedimiento insertar_posicion: Posicion otorgada fuera de rango, es mayor al numero de datos\n"
	error_posicion_negativa_dato_en_posicion: .asciiz "\nError en procedimiento dato_en_posicion: Posicion otorgada fuera de rango, es negativa\n"
	error_posicion_mayor_dato_en_posicion: .asciiz "\nError en procedimiento dato_en_posicion: Posicion otorgada fuera de rango, es mayor al numero de datos\n"
.text

main:	
	li $a0,5
	jal crear_lista_n_nodos
	move $a0, $v0
	move $s0, $v0
	jal mostrar_lista
	move $a0,$s0
	li $a1, 29
	li $a2, 4
	jal insertar_posicion
	move $s0, $v0
	move $a0,$s0
	jal mostrar_lista
	li $v0,10
	move $a0, $s0
	li $a1, -14
	jal dato_en_posicion
	move $a0,$v0
	li $v0,1
	syscall
	
	b end
	
	
end:
	li $v0,10
	syscall

#Este procedidmiento se encarga de crear un nuevo nodo con un dato
	#Entrada: $a0-> dato entero para el nodo
	#Salida: $v0-> Direccion de memoria del nodo
	crear_nodo:
		move $t0,$a0
		addi $v0,$zero,9
		addi $a0,$zero,8
		syscall
		sw $t0, 0($v0) #Nodo->dato = dato_argumento
		sw $zero, 4($v0)#Nodo->sig = null o 0 o zero
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
	
	#Este procedimiento se encarga de insertar un elemento al FINAL de una lista
	#Entrada: 	$a0-> direccion de memoria de la lista
	#	  	$a1 -> dato a guardar
	#Salida: 	$v0-> nueva direccion de memoria de la lista
	insertar_final:
		addi $sp, $sp, -8
		sw $a0, 4($sp)
		sw $ra,0($sp)
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
			lw $ra, 0($sp)
			move $a0, $t8
			addi $sp, $sp,8
			jr $ra
			
		end_insertar_final:
			lw $ra, 0($sp)
			lw $v0,4($sp)
			addi $sp, $sp,8
			jr $ra
	
	#Este procedimiento se encarga de mostrar por panatalla la lista enlazada
	#Entrada:	$a0->direccion de memoria de lista
	#Salida:	Sin salida
	mostrar_lista:
		addi $sp,$sp,-4
		sw $a0, 0($sp)
		move $t2, $a0
		loop_mostrar_lista:
			beq $t2,$zero,end_mostrar_lista
			li $v0,1
			lw $a0,0($t2)
			syscall
			li $v0,4
			la $a0,salto_linea
			syscall
			lw $t2, 4($t2)
			b loop_mostrar_lista
		end_mostrar_lista:
			lw $a0, 0($sp)
			addi $sp, $sp, 4
			jr $ra
	
	#Este procemidiento se ecnarga de generar una lista enlazada de tamaño dado, inicializada en ceros
	#Entrada: 	$a0-> n cantidad de nodos
	#Salida:	$v0 -> puntero a la cabeza de esta lista
	crear_lista_n_nodos:
		addi $sp,$sp,12
		sw $ra,0($sp)
		addi $t8, $zero, 0
		addi $t9, $zero, 0
		add $t7, $zero, $a0
		loop_crear_lista_n_nodos:
			bge $t9,$t7, end_loop_crear_lista_n_nodos
			move $a0, $t8
			li $a1,0
			sw $t9,4($sp)
			sw $t7,8($sp)
			jal insertar_final
			lw $t9,4($sp)
			lw $t7,8($sp)
			move $t8,$v0
			addi $t9, $t9,1
			b loop_crear_lista_n_nodos
			
		end_loop_crear_lista_n_nodos:
			lw $ra,0($sp)
			addi $sp,$sp,12
			move $v0, $t8
			jr $ra
			
			
			
	#Este procedimiento se encarga de obtener un dato en una posicion dada de una lista enlazada
	#Entrada: 	$a0-> puntero a cabeza de lista
	#		$a1-> posicion
	#Salida: 	$v0-> dato obtenido
	dato_en_posicion:
		move $t0,$a0
		move $t1,$a1
		li $t3,0
		loop_dato_en_posicion:
			blt $t1,0,posicion_negativa_dato_en_posicion
			bgt $t3,$t1, posicion_mayor_dato_en_posicion
			beq $t3,$t1,  encontro_dato_en_posicion
			addi $t3,$t3,1
			lw $t0, 4($t0)
			b loop_dato_en_posicion
		encontro_dato_en_posicion:
			lw $t1, 0($t0)
			move $v0, $t1
			jr $ra
		posicion_negativa_dato_en_posicion:
			li $v0,4
			la $a0, error_posicion_negativa_dato_en_posicion
			syscall
			b end
		posicion_mayor_dato_en_posicion:
			li $v0,4
			la $a0, error_posicion_mayor_dato_en_posicion
			syscall
			b end
			
			
	#Este procedimiento se encarga de instroducir un valor a una lista enlazada en una posicion dada
	#(Para este procedimiento se requiere una lista inicializada con nodos creados, mediante el procedimiento crear_lista_n_nodos)
	#Entrada: 	$a0-> puntero cabeza lista
	#		$a1-> valor a ingresar
	#		$a2-> posicion de ingreso
	#Salida: 	$v0-> puntero a cabeza de nueva lista
	insertar_posicion:
		move $t0,$a0
		move $t1,$a1
		move $t2,$a2
		li $t3,0
		loop_insertar_posicion:
			blt $t2,0,posicion_negativa_insertar_posicion
			bgt $t3,$t2, posicion_mayor_insertar_posicion
			beq $t3,$t2, encontro_posicion
			addi $t3,$t3,1
			lw $t0, 4($t0)
			b loop_insertar_posicion
		encontro_posicion:
			sw $t1, 0($t0)
			move $v0, $a0
			jr $ra
		posicion_negativa_insertar_posicion:
			li $v0,4
			la $a0, error_posicion_negativa_insertar_posicion
			syscall
			b end
		posicion_mayor_insertar_posicion:
			li $v0,4
			la $a0, error_posicion_mayor_insertar_posicion
			syscall
			b end
	