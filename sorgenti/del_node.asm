#funzione che cancella l'elemento di indice $a0
#input:
# $a0 = indice dell'elemento da cancellare 
#output: 
# $v0 = 1 elemento cancellato 
# $v0 = 0 elemento non cancellato 
	.data
t3:	.asciiz "3:"
t2:	.asciiz "2:"
	.text
	.globl del_node
del_node:
	la $t0, inizio
	lw $t3, 0($t0)
	li $t1, 0
	slt $t2, $a0, $t1		#controlllo se $a0 > 0
	bnez $t2, end_no
	
	la $t4, l		#leggo la lunghezza della lista e controllo che $a0 < lunghezza		
	lw $t4, 0($t4)
	slt $t2, $a0, $t4
	beqz $t2, end_no
	
	beqz $a0, primo_elem	#l'eliminazione del primo elemento la gestisco dopo
	
	addi $t4, $t4, -1
	li $t0, 0
loop:
	addi $t0, $t0, 1		#percorro la lista fermandomi all'indice richiesto
	sub $t1, $a0, $t0	
	move $t2, $t3		#in t2 ho l'indirizzo dell'elemento precedente a quello da cancellare
	lw $t3, 20($t3)		#in t3 ho l'indirizzo dell'elemento da cancellare
	beq $t0, $t4, ultimo_elem	#l'eliminazione dell'ultimo elemento la gestisco dopo
	bnez $t1, loop	
	
	lw $t3, 20($t3)		#elimino l'elemento cambiando i il next dell'elemento precedente con il successivo a quello da cancellare
	sw $t3, 20($t2)
	
	j end_ok
	
ultimo_elem:
	li $t3, -1		#l'ultimo elemento deve avere come next -1
	sw $t3, 20($t2)
	
	la $t3, fine		#aggiorno la variabile 'fine' salvata nel .data
	sw $t2, 0($t3)
	
	j end_ok
primo_elem:		
	lw $t1, 20($t3)		#per cancellare il primo elemento basta cambiare la variabile 'inizio' nel .data
	sw $t1, 0($t0)
	
	addi $t2, $t1, 1
	bnez $t2, non_vuota	#controllo che inizio non sia -1 (lista vuota)
	la $t3, fine		#lista vuota quindi devo aggiornare la fine con -1 per indicare che è vuota
	li $t2, -1
	sw $t2, 0($t3)
non_vuota:	
	j end_ok
end_no:
	li $v0, 0
	j end
end_ok:
	la $t5, l
	lw $t4, 0($t5)	
	addi $t4, $t4, -1	
	sw $t4, 0($t5)		#aggiorno la lunghezza con lunghezza-1
	li $v0, 1
end:
	jr $ra
