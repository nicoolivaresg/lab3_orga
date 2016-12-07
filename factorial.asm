

addi $a0, $zero, 5
jal factorial
add $s1, $zero, $v0
addi $v0, $zero, 10
syscall

# Calcula el factorial de n
#
# ARGUMENTOS:
#	$a0 => n
#
# RETORNO: $v0: n!
#
factorial:
addi $t0, $zero, 1
bne $a0, $t0, ELSE
addi $v0, $zero, 1
jr $ra
ELSE:
addi $sp, $sp, -8
sw $ra, 0($sp)
sw $a0, 4($sp)
addi $a0, $a0, -1 # n -1
jal factorial 	  # $v0 => (n-1)!
lw $a0, 4($sp)
lw $ra, 0($sp)
addi $sp, $sp, 8
mul $v0, $v0, $a0  # n*(n-1)! = n!
jr $ra
