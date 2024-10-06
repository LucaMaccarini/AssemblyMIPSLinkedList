#funzione per stampare un rettangolo nel tool bitmap display
#input: 
# $a0 = x 
# $a1 = y
# $a2 = altezza
# $a3 = larghezza
# nello stack = colore ($sp) 
#output: nessuno (stampa a video)

	.text
	.globl disegna_rettangolo
disegna_rettangolo:
	li $t2, 65536		#bytes dell'immagine (128*128*4)
	la $t1, immagine
	add $t2, $t2, $t1
	
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	
	beqz $a1, no_offset_y		
	li $t3, 0
loop_offset_y:			#loop per raggiungere il byte corrispondente alla la riga dove disegnare
	add $t1, $t1, 512 	#$t1 = larghezza*4 (bytes occupati da ogni riga della bitmap)
	add $t3, $t3, 1
	bne $t3, $a1, loop_offset_y	
no_offset_y:
	li $t5,0			#contatore delle righe
	
			
loop_riga:
	beqz $a0, no_offset_x
	li $t3, 0
loop_offset_x:			#loop per raggiungere il byte corrispondente alla colonna dove disegnare
	add $t1, $t1, 4
	add $t3, $t3, 1
	bne $t3, $a0, loop_offset_x
no_offset_x:


	move $t3, $a3
loop_colore:			#coloro sulla riga i pixel corrispondenti alla larghezza del quadrato
	sw $t0, 0($t1)
	add $t1, $t1, 4
	add $t3, $t3, -1
	bnez $t3, loop_colore

	add $t3, $a0, $a3
	sub $t3, $t3, 128		#Calcolo quanti pixel devo saltare per finire la riga	(128 è la larghezza dello schermo)
	beqz $t3, no_offset_dopo_larghezza
loop_offset_dopo_larghezza:
	add $t1, $t1, 4		#salto i byte corrispondenti ai pixel da saltare
	add $t3, $t3, 1
	bnez $t3, loop_offset_dopo_larghezza
	
no_offset_dopo_larghezza:	

	add $t5, $t5, 1	
	
	slt $t4, $a2, $t5		#controllo se ho raggiunto l'altezza del quadrato
	bnez $t4 end
	
	slt $t4, $t2, $t1
	beqz $t4, loop_riga 	#controllo di sicurezza per non far scrivere al di fuori dello spazio dell'immagine
				#nel possibile cheso che l'utente abbia posizionato male il quadrato
end:
	jr $ra
