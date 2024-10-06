#funzione per aggiungere un nodo alla lista
#parametri tutti nello stack: 
# x ($sp +16)
# y ($sp +12)
# altezza ($sp +8)
# larghezza ($sp +4)
# colore	($sp)
#output: nessuno

	.text
	.globl add_node
add_node:
	la $t0, fine

	li $a0, 24
	li $v0, 9
	syscall			#alloco 6 nodi (24 bytes) nello heap
	
	lw $t1, 0($sp)		#t1=colore
	addi $sp, $sp, 4
	lw $t2, 0($sp)		#t2=larghezza
	addi $sp, $sp, 4
	lw $t3, 0($sp)		#t3=altezza
	addi $sp, $sp, 4
	lw $t4, 0($sp)		#t2=y
	addi $sp, $sp, 4
	lw $t5, 0($sp)		#t2=x
	addi $sp, $sp, 4
	
	sw $t5, 0($v0)		#salvo la struxt nello heap
	sw $t4, 4($v0)
	sw $t3, 8($v0)
	sw $t2, 12($v0)
	sw $t1, 16($v0)
	li $t1, -1		
	sw $t1, 20($v0)		#next=-1 valore che indica che non è presente un nodo dopo questo
	
	
	lw $t1, 0($t0)		#controllo se la lista esiste
	addi $t2, $t1, 1
	beqz $t2 vuota
	
	lw $t1, 0($t0)		
	sw $v0, 20($t1)		#la lista esiste quindi devo aggiornare il next dell'ultimo nodo in quanto diventerà penultimo
	j end
	
vuota:			
	la $t1, inizio		#la lista non esite, quindi questo è il primo nodo
	sw $v0, 0($t1)		#inizio = indirizzo di questo nodo
	
end:
	sw $v0, 0($t0)		#aggiorno la varuiabile fine
	
	la $t0, l
	lw $t1, 0($t0)
	addi $t1, $t1, 1
	sw $t1, 0($t0)		#incremento la variabile l (lunghezza)
	
	jr $ra
	
