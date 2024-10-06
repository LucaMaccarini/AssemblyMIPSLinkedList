#
# ATTENZIONE!
# SE SI VUOLE USARE LA FUNZIONE 4 DEL MENU FARE QUANTO SCRITTO QUI SOTTO:
# - PRIMA DI ASSEMBLARE ED ESEGUIRE IL PROGRAMMA APRIRE IL TOOL 'Bitmap Display' ED IMPOSTARE ALTEZZA = 128 LARGHEZZA = 128 
# - CLICCARE 'Connect to MIPS'
# - IL TOOL UNA VOLTA APERTO ED IMPOSTATO NON VA TOCCATO E NON VA CHIUSO FINO AL TEMINE DEL PROGRAMMA 
#   IN QUANTO SE VENISSE TOCCATO O CHIUSO DURANTE UNA SYSCALL IL SIMULATORE MARS SI BLOCCA
# - si può usare solo il tasto reset presente sul tool
#(il main è quasi sempre in attesa di un'input dall'utente mediante syscall 
#quindi toccare il tool mentre il programma è in esecuzione fa bloccare mars)
#
#------------------------------------------------------------------------
	.data
	.globl immagine
	.globl inizio	#puntatore alla testa della nostra lista
	.globl fine	#utilizzato per ottimizzare l'nserimento
	.globl l		#lunghezza della lista
immagine:.space 65536	#impostare il bitmap display: width:260  x  height:128
inizio:	.word -1
fine:	.word -1
l:	.word 0
avvio:	.asciiz "Progetto d'rsame di Luca Maccarini: implementazione di una lista e suo utilizzo"
menu:	.asciiz "\nmenu:\n1 - aggiungere un nodo alla lista (se vuota viene creata)\n2 - eliminazione di un nodo\n3 - stampa la lista\n4 - disegna i quadrati della lista\n5 - esci"
azione:	.asciiz "\nselezionare una voce del menu: "
errore_i:.asciiz "voce del menu non esistente!\n"
invio:	.asciiz "cliccare invio per continuare..."
new_ret:	.asciiz "\ninserimento di un nuovo rettangolo\n"
x:	.asciiz "inserire la x dello spingolo in alto a sinistra: "
y:	.asciiz "inserire la y dello spingolo in alto a sinistra: "
alte:	.asciiz "inserire la altezza del rettangolo: "
larg:	.asciiz "inserire la larghezza del rettangolo: "
colore:	.asciiz "inserire il colore in DECIMALE (24 bit di colore divisi in: 0-7 blu, 8-15 verde, 16-23 rosso): "
inserito:.asciiz "\nquadrato aggiunto!\n"
in_errx:	.asciiz "input ERRATO (x>=0 and x<=128)\n"
in_erry:	.asciiz "input ERRATO (y>=0 and y<=128)\n"
erralte:	.asciiz "input ERRATO! con questa altezza esci dall'area di disegno: y+altezza<=128\n"
erralarg:.asciiz "input ERRATO! con questa larghezza esci dall'area di disegno: x+larghezza<=128\n"
ind_del:	.asciiz "inserire l'indice dell'elemento da cancellare: "
ind_err:	.asciiz "indice NON valido!\n"
del:	.asciiz "elemento cancellato!\n"
l_vuota:	.asciiz "prima di utilizzare questa funzione è necessario avere elementi nella lista!\n"
	.text
	.globl main
main:
	la $a0, avvio		#comunica d'inizio
	li $v0, 4
	syscall

out_menu:
	la $a0, menu		#comunica del menu
	li $v0, 4
	syscall
	j chiedi_input
	
errore_input:
	la $a0, errore_i		#comunica di errore nell'input
	li $v0, 4
	syscall
	
chiedi_input:
	la $a0, azione		
	li $v0, 4
	syscall
	
	li $v0, 5		#leggo cosa ha selezionato l'utente
	syscall
	
	li $t1, 1
	slt $t0, $v0, $t1		#controllo che l'input sia > 0 
	bnez $t0, errore_input

	addi $v0, $v0, -1		#switch per la decisione dell'utente
	beqz $v0, uno
	addi $v0, $v0, -1
	beqz $v0, due
	addi $v0, $v0, -1
	beqz $v0, tre
	addi $v0, $v0, -1
	beqz $v0, quattro
	addi $v0, $v0, -1
	beqz $v0, cinque
	j errore_input
	
uno:
	li $t0, 0		#parametri epr controllare x e y	
	li $t1, 129
	
	la $a0, new_ret		
	li $v0, 4
	syscall
	j chiedi_x
errata_x:
	la $a0, in_errx			
	li $v0, 4
	syscall
chiedi_x:
	la $a0, x
	li $v0, 4
	syscall
	li $v0, 5		#leggo x
	syscall
	slt $t2, $v0, $t0		#controllo x>=0 and x<129
	bnez $t2, errata_x	
	slt $t2, $v0, $t1	
	beqz $t2, errata_x		
	
	move $t3, $v0
	
	addi $sp, $sp, -4		#salvo x nello stack 
	sw $v0, 0($sp)
	
	j chiedi_y
errata_y:
	la $a0, in_erry			
	li $v0, 4
	syscall
chiedi_y:
	la $a0, y
	li $v0, 4
	syscall
	li $v0, 5		#leggo y
	syscall
	slt $t2, $v0, $t0		#controllo y>=0 and y<129
	bnez $t2, errata_y	
	slt $t2, $v0, $t1	
	beqz $t2, errata_y		
	
	move $t4, $v0
	
	addi $sp, $sp, -4		#salvo y nello stack 
	sw $v0, 0($sp)
	
	j chiedi_alte
errata_alte:
	la $a0, erralte			
	li $v0, 4
	syscall
chiedi_alte:
	la $a0, alte
	li $v0, 4
	syscall
	li $v0, 5		#leggo altezza
	syscall
	slt $t2, $v0, $t0		#controllo altezza>=0 and y+altezza<129
	bnez $t2, errata_alte
	add $t5, $t4, $v0	
	slt $t2, $t5, $t1	
	beqz $t2, errata_alte	
	
	addi $sp, $sp, -4		#salvo l'altezza nello stack
	sw $v0, 0($sp)
	
	j chiedi_larg
errata_larg:
	la $a0, erralarg			
	li $v0, 4
	syscall
chiedi_larg:
	la $a0, larg
	li $v0, 4
	syscall
	li $v0, 5		#leggo altezza
	syscall
	slt $t2, $v0, $t0		#controllo altezza>=0 and y+altezza<129
	bnez $t2, errata_larg
	add $t5, $t3, $v0	
	slt $t2, $t5, $t1	
	beqz $t2, errata_larg	
	
	addi $sp, $sp, -4		#salvo la larghezza nello stack
	sw $v0, 0($sp)
	
	
	la $a0, colore
	li $v0, 4
	syscall
	li $v0, 5		#leggo colore
	syscall
	addi $sp, $sp, -4
	sw $v0, 0($sp)
	
	jal add_node
	
	la $a0, inserito		#nodo inserito
	li $v0, 4
	syscall
	la $a0, invio		
	li $v0, 4
	syscall
	li $v0, 12
	syscall
	
	j out_menu
due:
	la $t2, inizio		#controllo se inizio = -1 (lista vuota)
	lw $t2, 0($t2)
	addi $t2, $t2, 1
	beqz $t2, lista_vuota
	
	la $a0, ind_del
	li $v0, 4
	syscall
	li $v0, 5		#leggo l'indice
	syscall
	move $a0, $v0
	jal del_node		#chiamo la funzione per cancellare
	bnez $v0, ind_giusto	#cobntrollo output funzione

	la $a0, ind_err		#indice non esistente
	li $v0, 4
	syscall
	j due
ind_giusto:			#indice esistente perciò elemento cancellato
	la $a0, del
	li $v0, 4
	syscall
	la $a0, invio		
	li $v0, 4
	syscall
	li $v0, 12
	syscall
	j out_menu
tre:
	la $t2, inizio		#controllo se inizio = -1 (lista vuota)
	lw $t2, 0($t2)
	addi $t2, $t2, 1
	beqz $t2, lista_vuota
	
	jal stampa_lista		#chiamo la funzione per stampare la lista
	
	la $a0, invio		
	li $v0, 4
	syscall
	li $v0, 12
	syscall
	j out_menu
quattro:
	la $t2, inizio		#controllo se inizio = -1 (lista vuota)
	lw $t2, 0($t2)
	addi $t2, $t2, 1
	beqz $t2, lista_vuota
	
	jal disegna_lista_rettangoli	#chiamo la funzione per disegnare la lista
	j out_menu
cinque:
	j end

lista_vuota:
	la $a0, l_vuota		
	li $v0, 4
	syscall
	la $a0, invio		
	li $v0, 4
	syscall
	li $v0, 12
	syscall
	j out_menu
end:
	li $v0, 10
	syscall
	
	
	
	
