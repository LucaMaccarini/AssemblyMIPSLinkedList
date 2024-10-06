#funzione che disegna tutti i rettangoli della lista
#input: nessuno
#output: nessuno (stampa a video)
	.text
	.globl disegna_lista_rettangoli
disegna_lista_rettangoli:
	addi $sp, $sp, -4		
	sw $ra, 0($sp)		#salvo $ra nello stack perchè succssivamente chiamerò una funzione
	
	la $t0, inizio
	lw $t0, 0($t0)
	
loop:	
	addi $sp, $sp, -4		
	sw $t0, 0($sp)		#salvo l'indirizzo del nodo che sto utilizzando nello stack perchè dopo chiamo una funzione 
	
	lw $a0 0($t0)		#sistemo i parametri per la funzione disegna_rettangolo
	lw $a1 4($t0)
	lw $a2 8($t0)
	lw $a3 12($t0)
	lw $t1 16($t0)		
	addi $sp, $sp, -4
	sw $t1, 0($sp)		#register spilling per l'ultimo parametro
	
	
	jal disegna_rettangolo	#rettangolo disegnato
	

	lw $t0, 0($sp)		#riprendo l'indirizzo del nodo che stavo utilizzando
	addi $sp, $sp, 4
	
	lw $t0, 20($t0)		#mi sposto al nodo successivo mediante il next	
	add $t1, $t0, 1		
	bnez $t1 loop		#controllo che il nodo in questione non sia l'ultimo
	
	lw $ra, 0($sp)		#riprendo $ra dallo stack per tornare al chiamante
	addi $sp, $sp, 4
	jr $ra
