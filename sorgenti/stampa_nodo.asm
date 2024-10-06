#funzione che stampa un nodo a video
#parametri: 
# $a0 = x
# $a1 = y
# $a2 = altezza
# $a3 = larghezza
# nello stack = colore ($sp)
#output: nessuno (stampa a video)
	.data
x:	.asciiz "x: "
y:	.asciiz "y: "
alte:	.asciiz "altezza: "
larg:	.asciiz "larghezza: "
colore:	.asciiz "colore: "
	.globl a_capo
a_capo: .asciiz "\n"
	.text
	.globl stampa_nodo
stampa_nodo:

	addi $sp, $sp, -4		#salvo tutti i parametri nello stack perchè devo fare delle syscall e potrebbero modificere i registri a...
	sw $a3, 0($sp)
	
	addi $sp, $sp, -4
	sw $a2, 0($sp)
	
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	
	la $a0, x		
	li $v0, 4	
	syscall			
	lw $a0, 0($sp)		#estraggo x dallo stack
	addi $sp, $sp, 4
	li $v0, 1	
	syscall			#x stampato
	
	la $a0, a_capo
	li $v0, 4	
	syscall			#vado a capo
			
	la $a0, y
	li $v0, 4	
	syscall	
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	li $v0, 1	
	syscall			#y stampato
	
	la $a0, a_capo
	li $v0, 4	
	syscall
	
	la $a0, alte
	li $v0, 4	
	syscall	
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	li $v0, 1	
	syscall			#altezza stampato
	
	la $a0, a_capo
	li $v0, 4	
	syscall
	
	la $a0, larg
	li $v0, 4	
	syscall	
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	li $v0, 1	
	syscall			#larghezza stampato
	
	la $a0, a_capo
	li $v0, 4	
	syscall
	
	la $a0, colore
	li $v0, 4	
	syscall	
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	li $v0, 1	
	syscall			#colore stampato
	
	la $a0, a_capo
	li $v0, 4	
	syscall			
	
	jr $ra
	
	
