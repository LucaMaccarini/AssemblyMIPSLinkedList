#funzione che elenca tutta la lista a video
#input: 	nessuno
#output: nessuno (output a video)
	.data
stampa:	.asciiz "elementi nella lista:\n"
elemento:.asciiz "indice dell'elemento: "
	.text
	.globl stampa_lista
stampa_lista:
	la $a0, stampa
	li $v0, 4
	syscall

	addi $sp, $sp, -4		
	sw $ra, 0($sp)		#salvo $ra nello stack perchè succssivamente chiamerò una funzione
	
	la $t0, inizio
	lw $t0, 0($t0)
	
	li $t2, 0
loop:	
	addi $sp, $sp, -4		
	sw $t0, 0($sp)		#salvo l'indirizzo del nodo che sto utilizzando nello stack perchè dopo chiamo una funzione 
	
	la $a0, elemento		
	li $v0, 4
	syscall
	move  $a0, $t2		#stampo l'indice il numero dell'elemento	
	li $v0, 1
	syscall
	la $a0, a_capo		
	li $v0, 4	
	syscall
	
	addi $t2, $t2, 1		#salvo nelllo stack il prossimo indice
	addi $sp, $sp, -4		
	sw $t2, 0($sp)		
	
	lw $a0 0($t0)		#sistemo i parametri per la funzione stampa_nodo
	lw $a1 4($t0)
	lw $a2 8($t0)
	lw $a3 12($t0)
	lw $t1 16($t0)		
	addi $sp, $sp, -4
	sw $t1, 0($sp)		#register spilling per l'ultimo parametro
		
	
	jal stampa_nodo		#nodo stampato
	
	la $a0, a_capo		
	li $v0, 4	
	syscall
	
	lw $t2, 0($sp)		#riprendo l'indice
	addi $sp, $sp, 4

	lw $t0, 0($sp)		#riprendo l'indirizzo del nodo che stavo utilizzando
	addi $sp, $sp, 4
	
	lw $t0, 20($t0)		#mi sposto al nodo successivo mediante il next	
	add $t1, $t0, 1		
	bnez $t1 loop		#controllo che il nodo in questione npn sia l'ultimo
	
	lw $ra, 0($sp)		#riprendo $ra dallo stack per tornare al chiamante
	addi $sp, $sp, 4
	jr $ra
