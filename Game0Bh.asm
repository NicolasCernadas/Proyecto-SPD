.8086
.model small
.stack 100h
.data

;Cosas que arreglar:
				
		;LISTO--; si disparas cuando hay una bala en movimiento y te moves, mueve la bala ya existente
		;LISTO--; que se fije los colores y cada enemigo sume diferente
		;LISTO--; hacer efectos de sonido(cuando todas w hace el sonido entonces si lo tocas mucho esta mal)
  ;LISTO(CREO)--; si tocas disparar muchas veces se bugea y no te deja mas
  		;LISTO--; que las opciones de YOU WIN funcionen

  				; que si te tocan los enemigos pierdas o si llegan al final 
				; que sea mas rapido cada nivel(menos retardos)				
				; que el score se sume al highscore al final de cada nivel
				; el enemigo secreto (aparece y se va, no determinantre para que gane el jugador)
				
;-------------------fabrica de enemigos
; ▀ █ ▄

;   ▄█▄█▄
;   █▄█▄█
;    ▀ ▀ 

;   ▄█▄█▄
; █▄█▄█▄█▄█
; ▄█ ▀ ▀ █▄

;-------------------fabrica de naves

;  ▄█▄

;------------------- WIN
;	▄   █   ▄
;	██▄███▄██
;	█████████

;219 █ es el rectanculo , 220 ▄ es el cuadrado abajo , 223 ▀ es el cuadrado arriba
;-------------------------------------------	
;Variables de JUGADOR
	columna_Jugador db 38  ;eje x
	renglon_Jugador db 23  ;eje y
;-------------------------------------------
;Variables de Enemigos de fila 1

	renglon_de_Enemigos_nro_1 db 3

	columna_Enemigo_1 db 0
	color_Enemigo_1 db 2 ;(verde)

	columna_Enemigo_2 db 11
	color_Enemigo_2 db 2 ;(verde)

	columna_Enemigo_3 db 22
	color_Enemigo_3 db 2 ;(verde)

	columna_Enemigo_4 db 33
	color_Enemigo_4 db 2 ;(verde)

	columna_Enemigo_5 db 44
	color_Enemigo_5 db 2 ;(verde)

	columna_Enemigo_6 db 55
	color_Enemigo_6 db 2 ;(verde)

;-------------------------------------------
;Variables de Enemigos de fila 2

	renglon_de_Enemigos_nro_2 db 8

	columna_Enemigo_7 db 0
	color_Enemigo_7 db 3 ;(cyan)

	columna_Enemigo_8 db 11
	color_Enemigo_8 db 3 ;(cyan)

	columna_Enemigo_9 db 22
	color_Enemigo_9 db 3 ;(cyan)

	columna_Enemigo_10 db 33
	color_Enemigo_10 db 3 ;(cyan)

	columna_Enemigo_11 db 44
	color_Enemigo_11 db 3 ;(cyan)

	columna_Enemigo_12 db 55
	color_Enemigo_12 db 3 ;(cyan)

;-------------------------------------------
;Variables de Enemigos de fila 3

	renglon_de_Enemigos_nro_3 db 13

	columna_Enemigo_13 db 0
	color_Enemigo_13 db 4 ;(rojo)

	columna_Enemigo_14 db 11
	color_Enemigo_14 db 4 ;(rojo)

	columna_Enemigo_15 db 22
	color_Enemigo_15 db 4 ;(rojo)

	columna_Enemigo_16 db 33
	color_Enemigo_16 db 4 ;(rojo)

	columna_Enemigo_17 db 44
	color_Enemigo_17 db 4 ;(rojo)

	columna_Enemigo_18 db 55
	color_Enemigo_18 db 4 ;(rojo)


;-------------------------------------------
;Variables de Enemigo SECRETO (que miedo)
	columna_Enemigo_SECRETO db 0
	renglon_Enemigo_SECRETO db 14
	color_Enemigo_SECRETO db 5 ;(magenta)
;-------------------------------------------
;Variables de bala
	col_bala db 0
	reng_bala db 22
	bala db 173 ;ascii de la bala
	flag_bala db 0
;-------------------------------------------
;Variables de enemigos general
	flag_movimiento db 0 
	contador_de_desplazamiento db 0
	enemigos_masacrados db 0
;-------------------------------------------
;Variables de puntaje
	textoScore db "SCORE:",24h
	textoHighscore db "  HIGHSCORE: ",24h
	scoreAscii db "0000",24h
	highscoreAscii db "0000",24h
	score db 0
	highscore db 0
	dataDiv db 100,10,1
;-------------------------------------------
;Pantalla de Game_Loop
	bienvenida db "Bienvenidos!",24h
	bienvenida2 db "Presiona cualquier tecla para continuar",24h
	pantallaGame_Loop db "PLAY",0dh,0ah,0dh,0ah
					db 09h,09h,09h,"        SPACE INVADERS",0dh,0ah,0dh,0ah
					db 09h,09h,09h,"      TABLA  DE PUNTAJES",0dh,0ah
					db 09h,09h,09h,09h,"   = ?",0dh,0ah
					db 09h,09h,09h,09h,"   = 30 PUNTOS",0dh,0ah
					db 09h,09h,09h,09h,"   = 20 PUNTOS",0dh,0ah
					db 09h,09h,09h,09h,"   = 10 PUNTOS",0dh,0ah,24h
	
;-------------------------------------------
;Pantalla de Fin
	finJuegoMensaje db "YOU  WIN!!",0dh,0ah,0dh,0ah
			db 09h,09h,09h,"     Desea seguir jugando?",0dh,0ah
			db 09h,09h,09h,"         Press [Space]",24h
	finJuegoMensaje2 db  "Press [Esc] to Exit",24h
	GameOverText db " GAME OVER ",24h
	ERRORText db "S4%HALCFD#&%#=(R%gJEWS$|",24h



.code
	main proc
	mov ax, @data
	mov ds, ax
	
	mov ah, 00h ;Set video mode	
	mov al, 02h ;video mode	(usamos la 02h que tiene solo texto)
	int 10h
	
	call menuInicial

	;Limpia la pantalla
	mov ah, 0Fh
	int 10h
	mov ah, 0
	int 10h

	;limpio los registros para que empiece todo en 0
	xor ax, ax
	xor dx, dx  ; hace falta??

hora_de_aventura:
	mov enemigos_masacrados, 0

	mov color_Enemigo_1, 2
	mov color_Enemigo_2, 2
	mov color_Enemigo_3, 2
	mov color_Enemigo_4, 2
	mov color_Enemigo_5, 2
	mov color_Enemigo_6, 2
		mov renglon_de_Enemigos_nro_1, 3

	mov color_Enemigo_7, 3
	mov color_Enemigo_8, 3
	mov color_Enemigo_9, 3
	mov color_Enemigo_10, 3
	mov color_Enemigo_11, 3
	mov color_Enemigo_12, 3
		mov renglon_de_Enemigos_nro_2, 8


	mov color_Enemigo_13, 4
	mov color_Enemigo_14, 4
	mov color_Enemigo_15, 4
	mov color_Enemigo_16, 4
	mov color_Enemigo_17, 4
	mov color_Enemigo_18, 4
		mov renglon_de_Enemigos_nro_3, 13

Game_Loop:

	call cartelPuntajes ; PREGUNTAR A CATA PORQUE ESTE CARTEL NO SALE TODAS LAS VECES

;-------------------------------------------
;Modulo de impresion de enemigos

	cmp color_Enemigo_1, 0 ;0 es el negro
je noImprime_Enemigo1
	mov dh, renglon_de_Enemigos_nro_1
	mov dl, columna_Enemigo_1 ;=====(Enemigo 1)
	mov bl, color_Enemigo_1
	call imprimeEnemigo
noImprime_Enemigo1:


	cmp color_Enemigo_2, 0
je noImprime_Enemigo2
	mov dh, renglon_de_Enemigos_nro_1
	mov dl, columna_Enemigo_2 ;=====(Enemigo 2)
	mov bl, color_Enemigo_2
	call imprimeEnemigo
noImprime_Enemigo2:


	cmp color_Enemigo_3, 0
je noImprime_Enemigo3
	mov dh, renglon_de_Enemigos_nro_1
	mov dl, columna_Enemigo_3 ;=====(Enemigo 3)
	mov bl, color_Enemigo_3
	call imprimeEnemigo
noImprime_Enemigo3:


	cmp color_Enemigo_4, 0
je noImprime_Enemigo4
	mov dh, renglon_de_Enemigos_nro_1
	mov dl, columna_Enemigo_4 ;=====(Enemigo 4)
	mov bl, color_Enemigo_4
	call imprimeEnemigo
noImprime_Enemigo4:


	cmp color_Enemigo_5, 0
je noImprime_Enemigo5
	mov dh, renglon_de_Enemigos_nro_1
	mov dl, columna_Enemigo_5 ;=====(Enemigo 5)
	mov bl, color_Enemigo_5
	call imprimeEnemigo
noImprime_Enemigo5:


	cmp color_Enemigo_6, 0
je noImprime_Enemigo6
	mov dh, renglon_de_Enemigos_nro_1
	mov dl, columna_Enemigo_6 ;=====(Enemigo 6)
	mov bl, color_Enemigo_6
	call imprimeEnemigo
noImprime_Enemigo6:


	cmp color_Enemigo_7, 0
je noImprime_Enemigo7
	mov dh, renglon_de_Enemigos_nro_2
	mov dl, columna_Enemigo_7 ;=====(Enemigo 7)
	mov bl, color_Enemigo_7
	call imprimeEnemigo
noImprime_Enemigo7:


	cmp color_Enemigo_8, 0
je noImprime_Enemigo8
	mov dh, renglon_de_Enemigos_nro_2
	mov dl, columna_Enemigo_8 ;=====(Enemigo 8)
	mov bl, color_Enemigo_8
	call imprimeEnemigo
noImprime_Enemigo8:


	cmp color_Enemigo_9, 0
je noImprime_Enemigo9
	mov dh, renglon_de_Enemigos_nro_2
	mov dl, columna_Enemigo_9 ;=====(Enemigo 9)
	mov bl, color_Enemigo_9
	call imprimeEnemigo
noImprime_Enemigo9:


	cmp color_Enemigo_10, 0
je noImprime_Enemigo10
	mov dh, renglon_de_Enemigos_nro_2
	mov dl, columna_Enemigo_10 ;=====(Enemigo 10)
	mov bl, color_Enemigo_10
	call imprimeEnemigo
noImprime_Enemigo10:


	cmp color_Enemigo_11, 0
je noImprime_Enemigo11
	mov dh, renglon_de_Enemigos_nro_2
	mov dl, columna_Enemigo_11 ;=====(Enemigo 11)
	mov bl, color_Enemigo_11
	call imprimeEnemigo
noImprime_Enemigo11:


	cmp color_Enemigo_12, 0
je noImprime_Enemigo12
	mov dh, renglon_de_Enemigos_nro_2
	mov dl, columna_Enemigo_12 ;=====(Enemigo 12)
	mov bl, color_Enemigo_12
	call imprimeEnemigo
noImprime_Enemigo12:


	cmp color_Enemigo_13, 0
je noImprime_Enemigo13
	mov dh, renglon_de_Enemigos_nro_3
	mov dl, columna_Enemigo_13 ;=====(Enemigo 13)
	mov bl, color_Enemigo_13
	call imprimeEnemigo
noImprime_Enemigo13:


	cmp color_Enemigo_14, 0
je noImprime_Enemigo14
	mov dh, renglon_de_Enemigos_nro_3
	mov dl, columna_Enemigo_14 ;=====(Enemigo 14)
	mov bl, color_Enemigo_14
	call imprimeEnemigo
noImprime_Enemigo14:


	cmp color_Enemigo_15, 0
je noImprime_Enemigo15
	mov dh, renglon_de_Enemigos_nro_3
	mov dl, columna_Enemigo_15 ;=====(Enemigo 15)
	mov bl, color_Enemigo_15
	call imprimeEnemigo
noImprime_Enemigo15:


	cmp color_Enemigo_16, 0
je noImprime_Enemigo16
	mov dh, renglon_de_Enemigos_nro_3
	mov dl, columna_Enemigo_16 ;=====(Enemigo 16)
	mov bl, color_Enemigo_16
	call imprimeEnemigo
noImprime_Enemigo16:


	cmp color_Enemigo_17, 0
je noImprime_Enemigo17
	mov dh, renglon_de_Enemigos_nro_3
	mov dl, columna_Enemigo_17 ;=====(Enemigo 17)
	mov bl, color_Enemigo_17
	call imprimeEnemigo
noImprime_Enemigo17:


	cmp color_Enemigo_18, 0
je noImprime_Enemigo18
	mov dh, renglon_de_Enemigos_nro_3
	mov dl, columna_Enemigo_18 ;=====(Enemigo 18)
	mov bl, color_Enemigo_18
	call imprimeEnemigo
noImprime_Enemigo18:

;-------------------------------------------


;-------------------------------------------
;Modulo para imprimir forma de Jugador(imprimir a el jugador SIEMPRE despues de los enemigos)
	mov dh, renglon_Jugador  ;en dh recibe la posicion X  (Para posicionamiento del cursor)
	mov dl, columna_Jugador  ;en dl recibe la posicion Y  
	mov bl, 1                ;en bl el color
	call imprime_Jugador
;-------------------------------------------


;-------------------------------------------
;Modulo para comparar existencia de bala 
	cmp flag_bala, 0 	
	jnz balaDisparada 	;Saltar si no es cero
jmp bala_NOdisparada ;Salta de una porque no tiene que ser condicional como estaba antes
;-------------------------------------------


;-------------------------------------------
;Modulo para imprimir y mover la bala
balaDisparada:

	mov dh, reng_bala
	mov dl, col_bala
	mov bl, 7
	mov al, bala
	mov cx, 1
	call imprime

	mov dl, reng_bala
	call movimiento_bala
	mov reng_bala, dl
;-------------------------------------------

;-------------------------------------------
;Modulo de comprobación de asesinato

;===============================================================(Enemigo 1)
	cmp color_Enemigo_1, 0 
je noComprueboColision_Enemigo1
	mov dh, reng_bala
	mov dl, col_bala
	mov ch, renglon_de_Enemigos_nro_1
	mov cl, columna_Enemigo_1
	mov bl, color_Enemigo_1 
	call colisionBala
	mov reng_bala, dh
	
	cmp ah, 0 	;si ah es 0, mata
	jne noComprueboColision_Enemigo1

	mov bl, color_Enemigo_1 
	mov bh, flag_bala
	mov al, enemigos_masacrados

	call matar_Enemigo

	mov color_Enemigo_1, bl 
	mov flag_bala, bh
	mov enemigos_masacrados, al

jmp que_medio_no_hace_falta_pero_hace_el_codigo_mas_eficiente
noComprueboColision_Enemigo1:
;===============================================================

;===============================================================(Enemigo 2)
	cmp color_Enemigo_2, 0 
je noComprueboColision_Enemigo2
	mov dh, reng_bala
	mov dl, col_bala
	mov ch, renglon_de_Enemigos_nro_1
	mov cl, columna_Enemigo_2
	mov bl, color_Enemigo_2
	call colisionBala
	mov reng_bala, dh
	
	cmp ah, 0 	;si ah es 0, mata
	jne noComprueboColision_Enemigo2

	mov bl, color_Enemigo_2 
	mov bh, flag_bala
	mov al, enemigos_masacrados

	call matar_Enemigo

	mov color_Enemigo_2, bl 
	mov flag_bala, bh
	mov enemigos_masacrados, al

jmp que_medio_no_hace_falta_pero_hace_el_codigo_mas_eficiente
noComprueboColision_Enemigo2:
;===============================================================

;===============================================================(Enemigo 3)
	cmp color_Enemigo_3, 0 
je noComprueboColision_Enemigo3
	mov dh, reng_bala
	mov dl, col_bala
	mov ch, renglon_de_Enemigos_nro_1
	mov cl, columna_Enemigo_3
	mov bl, color_Enemigo_3
	call colisionBala
	mov reng_bala, dh
	
	cmp ah, 0 	;si ah es 0, mata
	jne noComprueboColision_Enemigo3

	mov bl, color_Enemigo_3 
	mov bh, flag_bala
	mov al, enemigos_masacrados

	call matar_Enemigo

	mov color_Enemigo_3, bl 
	mov flag_bala, bh
	mov enemigos_masacrados, al

jmp que_medio_no_hace_falta_pero_hace_el_codigo_mas_eficiente
noComprueboColision_Enemigo3:
;===============================================================

;===============================================================(Enemigo 4)
	cmp color_Enemigo_4, 0 
je noComprueboColision_Enemigo4
	mov dh, reng_bala
	mov dl, col_bala
	mov ch, renglon_de_Enemigos_nro_1
	mov cl, columna_Enemigo_4
	mov bl, color_Enemigo_4
	call colisionBala
	mov reng_bala, dh
	
	cmp ah, 0 	;si ah es 0, mata
	jne noComprueboColision_Enemigo4

	mov bl, color_Enemigo_4 
	mov bh, flag_bala
	mov al, enemigos_masacrados

	call matar_Enemigo

	mov color_Enemigo_4, bl 
	mov flag_bala, bh
	mov enemigos_masacrados, al

jmp que_medio_no_hace_falta_pero_hace_el_codigo_mas_eficiente
noComprueboColision_Enemigo4:
;===============================================================

;===============================================================(Enemigo 5)
	cmp color_Enemigo_5, 0 
je noComprueboColision_Enemigo5
	mov dh, reng_bala
	mov dl, col_bala
	mov ch, renglon_de_Enemigos_nro_1
	mov cl, columna_Enemigo_5
	mov bl, color_Enemigo_5
	call colisionBala
	mov reng_bala, dh
	
	cmp ah, 0 	;si ah es 0, mata
	jne noComprueboColision_Enemigo5

	mov bl, color_Enemigo_5 
	mov bh, flag_bala
	mov al, enemigos_masacrados

	call matar_Enemigo

	mov color_Enemigo_5, bl 
	mov flag_bala, bh
	mov enemigos_masacrados, al

jmp que_medio_no_hace_falta_pero_hace_el_codigo_mas_eficiente
noComprueboColision_Enemigo5:
;===============================================================

;===============================================================(Enemigo 6)
	cmp color_Enemigo_6, 0 
je noComprueboColision_Enemigo6
	mov dh, reng_bala
	mov dl, col_bala
	mov ch, renglon_de_Enemigos_nro_1
	mov cl, columna_Enemigo_6
	mov bl, color_Enemigo_6
	call colisionBala
	mov reng_bala, dh
	
	cmp ah, 0 	;si ah es 0, mata
	jne noComprueboColision_Enemigo6

	mov bl, color_Enemigo_6 
	mov bh, flag_bala
	mov al, enemigos_masacrados

	call matar_Enemigo

	mov color_Enemigo_6, bl 
	mov flag_bala, bh
	mov enemigos_masacrados, al

jmp que_medio_no_hace_falta_pero_hace_el_codigo_mas_eficiente
noComprueboColision_Enemigo6:
;===============================================================

;===============================================================(Enemigo 7)
	cmp color_Enemigo_7, 0 
je noComprueboColision_Enemigo7
	mov dh, reng_bala
	mov dl, col_bala
	mov ch, renglon_de_Enemigos_nro_2
	mov cl, columna_Enemigo_7
	mov bl, color_Enemigo_7
	call colisionBala
	mov reng_bala, dh
	
	cmp ah, 0 	;si ah es 0, mata
	jne noComprueboColision_Enemigo7

	mov bl, color_Enemigo_7 
	mov bh, flag_bala
	mov al, enemigos_masacrados

	call matar_Enemigo

	mov color_Enemigo_7, bl 
	mov flag_bala, bh
	mov enemigos_masacrados, al

jmp que_medio_no_hace_falta_pero_hace_el_codigo_mas_eficiente
noComprueboColision_Enemigo7:
;===============================================================

;===============================================================(Enemigo 8)
	cmp color_Enemigo_8, 0 
je noComprueboColision_Enemigo8
	mov dh, reng_bala
	mov dl, col_bala
	mov ch, renglon_de_Enemigos_nro_2
	mov cl, columna_Enemigo_8
	mov bl, color_Enemigo_8
	call colisionBala
	mov reng_bala, dh
	
	cmp ah, 0 	;si ah es 0, mata
	jne noComprueboColision_Enemigo8

	mov bl, color_Enemigo_8 
	mov bh, flag_bala
	mov al, enemigos_masacrados

	call matar_Enemigo

	mov color_Enemigo_8, bl 
	mov flag_bala, bh
	mov enemigos_masacrados, al

jmp que_medio_no_hace_falta_pero_hace_el_codigo_mas_eficiente
noComprueboColision_Enemigo8:
;===============================================================

;===============================================================(Enemigo 9)
	cmp color_Enemigo_9, 0 
je noComprueboColision_Enemigo9
	mov dh, reng_bala
	mov dl, col_bala
	mov ch, renglon_de_Enemigos_nro_2
	mov cl, columna_Enemigo_9
	mov bl, color_Enemigo_9
	call colisionBala
	mov reng_bala, dh
	
	cmp ah, 0 	;si ah es 0, mata
	jne noComprueboColision_Enemigo9

	mov bl, color_Enemigo_9 
	mov bh, flag_bala
	mov al, enemigos_masacrados

	call matar_Enemigo

	mov color_Enemigo_9, bl 
	mov flag_bala, bh
	mov enemigos_masacrados, al

jmp que_medio_no_hace_falta_pero_hace_el_codigo_mas_eficiente
noComprueboColision_Enemigo9:
;===============================================================

;===============================================================(Enemigo 10)
	cmp color_Enemigo_10, 0 
je noComprueboColision_Enemigo10
	mov dh, reng_bala
	mov dl, col_bala
	mov ch, renglon_de_Enemigos_nro_2
	mov cl, columna_Enemigo_10
	mov bl, color_Enemigo_10
	call colisionBala
	mov reng_bala, dh
	
	cmp ah, 0 	;si ah es 0, mata
	jne noComprueboColision_Enemigo10

	mov bl, color_Enemigo_10 
	mov bh, flag_bala
	mov al, enemigos_masacrados

	call matar_Enemigo

	mov color_Enemigo_10, bl 
	mov flag_bala, bh
	mov enemigos_masacrados, al

jmp que_medio_no_hace_falta_pero_hace_el_codigo_mas_eficiente
noComprueboColision_Enemigo10:
;===============================================================

;===============================================================(Enemigo 11)
	cmp color_Enemigo_11, 0 
je noComprueboColision_Enemigo11
	mov dh, reng_bala
	mov dl, col_bala
	mov ch, renglon_de_Enemigos_nro_2
	mov cl, columna_Enemigo_11
	mov bl, color_Enemigo_11
	call colisionBala
	mov reng_bala, dh
	
	cmp ah, 0 	;si ah es 0, mata
	jne noComprueboColision_Enemigo11

	mov bl, color_Enemigo_11 
	mov bh, flag_bala
	mov al, enemigos_masacrados

	call matar_Enemigo

	mov color_Enemigo_11, bl 
	mov flag_bala, bh
	mov enemigos_masacrados, al

jmp que_medio_no_hace_falta_pero_hace_el_codigo_mas_eficiente
noComprueboColision_Enemigo11:
;===============================================================

;===============================================================(Enemigo 12)
	cmp color_Enemigo_12, 0 
je noComprueboColision_Enemigo12
	mov dh, reng_bala
	mov dl, col_bala
	mov ch, renglon_de_Enemigos_nro_2
	mov cl, columna_Enemigo_12
	mov bl, color_Enemigo_12
	call colisionBala
	mov reng_bala, dh
	
	cmp ah, 0 	;si ah es 0, mata
	jne noComprueboColision_Enemigo12

	mov bl, color_Enemigo_12 
	mov bh, flag_bala
	mov al, enemigos_masacrados

	call matar_Enemigo

	mov color_Enemigo_12, bl 
	mov flag_bala, bh
	mov enemigos_masacrados, al

jmp que_medio_no_hace_falta_pero_hace_el_codigo_mas_eficiente
noComprueboColision_Enemigo12:
;===============================================================

;===============================================================(Enemigo 13)
	cmp color_Enemigo_13, 0 
je noComprueboColision_Enemigo13
	mov dh, reng_bala
	mov dl, col_bala
	mov ch, renglon_de_Enemigos_nro_3
	mov cl, columna_Enemigo_13
	mov bl, color_Enemigo_13
	call colisionBala
	mov reng_bala, dh
	
	cmp ah, 0 	;si ah es 0, mata
	jne noComprueboColision_Enemigo13

	mov bl, color_Enemigo_13 
	mov bh, flag_bala
	mov al, enemigos_masacrados

	call matar_Enemigo

	mov color_Enemigo_13, bl 
	mov flag_bala, bh
	mov enemigos_masacrados, al

jmp que_medio_no_hace_falta_pero_hace_el_codigo_mas_eficiente
noComprueboColision_Enemigo13:
;===============================================================

;===============================================================(Enemigo 14)
	cmp color_Enemigo_14, 0 
je noComprueboColision_Enemigo14
	mov dh, reng_bala
	mov dl, col_bala
	mov ch, renglon_de_Enemigos_nro_3
	mov cl, columna_Enemigo_14
	mov bl, color_Enemigo_14
	call colisionBala
	mov reng_bala, dh
	
	cmp ah, 0 	;si ah es 0, mata
	jne noComprueboColision_Enemigo14

	mov bl, color_Enemigo_14 
	mov bh, flag_bala
	mov al, enemigos_masacrados

	call matar_Enemigo

	mov color_Enemigo_14, bl 
	mov flag_bala, bh
	mov enemigos_masacrados, al

jmp que_medio_no_hace_falta_pero_hace_el_codigo_mas_eficiente
noComprueboColision_Enemigo14:
;===============================================================

;===============================================================(Enemigo 15)
	cmp color_Enemigo_15, 0 
je noComprueboColision_Enemigo15
	mov dh, reng_bala
	mov dl, col_bala
	mov ch, renglon_de_Enemigos_nro_3
	mov cl, columna_Enemigo_15
	mov bl, color_Enemigo_15
	call colisionBala
	mov reng_bala, dh
	
	cmp ah, 0 	;si ah es 0, mata
	jne noComprueboColision_Enemigo15

	mov bl, color_Enemigo_15 
	mov bh, flag_bala
	mov al, enemigos_masacrados

	call matar_Enemigo

	mov color_Enemigo_15, bl 
	mov flag_bala, bh
	mov enemigos_masacrados, al

jmp que_medio_no_hace_falta_pero_hace_el_codigo_mas_eficiente
noComprueboColision_Enemigo15:
;===============================================================

;===============================================================(Enemigo 16)
	cmp color_Enemigo_16, 0 
je noComprueboColision_Enemigo16
	mov dh, reng_bala
	mov dl, col_bala
	mov ch, renglon_de_Enemigos_nro_3
	mov cl, columna_Enemigo_16
	mov bl, color_Enemigo_16
	call colisionBala
	mov reng_bala, dh
	
	cmp ah, 0 	;si ah es 0, mata
	jne noComprueboColision_Enemigo16

	mov bl, color_Enemigo_16 
	mov bh, flag_bala
	mov al, enemigos_masacrados

	call matar_Enemigo

	mov color_Enemigo_16, bl 
	mov flag_bala, bh
	mov enemigos_masacrados, al

jmp que_medio_no_hace_falta_pero_hace_el_codigo_mas_eficiente
noComprueboColision_Enemigo16:
;===============================================================

;===============================================================(Enemigo 17)
	cmp color_Enemigo_17, 0 
je noComprueboColision_Enemigo17
	mov dh, reng_bala
	mov dl, col_bala
	mov ch, renglon_de_Enemigos_nro_3
	mov cl, columna_Enemigo_17
	mov bl, color_Enemigo_17
	call colisionBala
	mov reng_bala, dh
	
	cmp ah, 0 	;si ah es 0, mata
	jne noComprueboColision_Enemigo17

	mov bl, color_Enemigo_17 
	mov bh, flag_bala
	mov al, enemigos_masacrados

	call matar_Enemigo

	mov color_Enemigo_17, bl 
	mov flag_bala, bh
	mov enemigos_masacrados, al

jmp que_medio_no_hace_falta_pero_hace_el_codigo_mas_eficiente
noComprueboColision_Enemigo17:
;===============================================================

;===============================================================(Enemigo 18)
	cmp color_Enemigo_18, 0 
je noComprueboColision_Enemigo18
	mov dh, reng_bala
	mov dl, col_bala
	mov ch, renglon_de_Enemigos_nro_3
	mov cl, columna_Enemigo_18
	mov bl, color_Enemigo_18
	call colisionBala
	mov reng_bala, dh
	
	cmp ah, 0 	;si ah es 0, mata
	jne noComprueboColision_Enemigo18

	mov bl, color_Enemigo_18 
	mov bh, flag_bala
	mov al, enemigos_masacrados

	call matar_Enemigo

	mov color_Enemigo_18, bl 
	mov flag_bala, bh
	mov enemigos_masacrados, al

jmp que_medio_no_hace_falta_pero_hace_el_codigo_mas_eficiente
noComprueboColision_Enemigo18:
;===============================================================


que_medio_no_hace_falta_pero_hace_el_codigo_mas_eficiente:
;-------------------------------------------

bala_NOdisparada:


;-------------------------------------------
;"Modulo" comprobar si hay pulsaciones
	call pulsacion
;-------------------------------------------


;-------------------------------------------
;"Modulo" de retrasados, digo de retardos
	;Solo poner retardos, en cualquier otro lugar no sirven
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	call retardo
	
;-------------------------------------------


;-------------------------------------------
;Modulo para movimiento de enemigos

	cmp flag_movimiento, 0
	je incrementacion
	cmp flag_movimiento, 1
	je decrementacion

incrementacion:
	inc columna_Enemigo_1
	inc columna_Enemigo_2
	inc columna_Enemigo_3
	inc columna_Enemigo_4
	inc columna_Enemigo_5
	inc columna_Enemigo_6

	inc columna_Enemigo_7
	inc columna_Enemigo_8
	inc columna_Enemigo_9
	inc columna_Enemigo_10
	inc columna_Enemigo_11
	inc columna_Enemigo_12

	inc columna_Enemigo_13
	inc columna_Enemigo_14
	inc columna_Enemigo_15
	inc columna_Enemigo_16
	inc columna_Enemigo_17
	inc columna_Enemigo_18


	inc contador_de_desplazamiento

	cmp contador_de_desplazamiento, 20
	je bajar_renglon_flag_1
	jmp no_hacer_nada

decrementacion:
	dec columna_Enemigo_1
	dec columna_Enemigo_2
	dec columna_Enemigo_3
	dec columna_Enemigo_4
	dec columna_Enemigo_5
	dec columna_Enemigo_6

	dec columna_Enemigo_7
	dec columna_Enemigo_8
	dec columna_Enemigo_9
	dec columna_Enemigo_10
	dec columna_Enemigo_11
	dec columna_Enemigo_12

	dec columna_Enemigo_13
	dec columna_Enemigo_14
	dec columna_Enemigo_15
	dec columna_Enemigo_16
	dec columna_Enemigo_17
	dec columna_Enemigo_18


	inc contador_de_desplazamiento

	cmp contador_de_desplazamiento, 20
	je bajar_renglon_flag_0
	jmp no_hacer_nada

bajar_renglon_flag_1:
	inc renglon_de_Enemigos_nro_1
	inc renglon_de_Enemigos_nro_2
	inc renglon_de_Enemigos_nro_3
	mov contador_de_desplazamiento, 0
	mov flag_movimiento, 1
jmp no_hacer_nada ;estos jmp si que hicieron algo obviamente

bajar_renglon_flag_0:
	;inc renglon_de_Enemigos_nro_1
	;inc renglon_de_Enemigos_nro_2 		;si baja de los dos lados es imposible
	;inc renglon_de_Enemigos_nro_3
	mov contador_de_desplazamiento, 0
	mov flag_movimiento, 0
jmp no_hacer_nada

no_hacer_nada:

;-------------------------------------------

	mov ah, 0Fh ;Get current video mode	
	int 10h
	mov ah, 0
	int 10h
	
	xor dx, dx
	xor cx, cx

	cmp enemigos_masacrados, 18 ;lo comparas con la cantidad de enemigos que hay
	je findelmalditoJuego

jmp Game_Loop

findelmalditoJuego: ;No cambiar etiqueta en honor a cata
	call fin_masacre_total

Hasta_que_ponganteclavalida:

	mov ah, 8
	int 21h
	
	cmp al ,1bh ;(ESC)
	je fin_REAL_del_juego ;No cambiar etiqueta en honor a maxi ¯\_(ツ)_/¯
	cmp al ,20h ;(space) 
	je outatime

jmp Hasta_que_ponganteclavalida

outatime:
	jmp hora_de_aventura

fin_REAL_del_juego:

	mov ax, 4c00h
	int 21h

main endp


menuInicial proc
	;primer mensaje de bienvenida
	mov bh, 0 ;pagina
	mov dh, 10 ;renglon
	mov dl, 34 ;columna
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, bienvenida
	int 21h

	;segundo mensaje
	mov dh, 12 ;renglon
	mov dl, 21 ;columna
	mov ah, 2
	int 10h
	
	mov ah, 9
	lea dx, bienvenida2
	int 21h

	mov ah, 00h
	int 16h
	
	;Limpia la pantalla
	mov ah, 0Fh
	int 10h
	mov ah, 0
	int 10h

	;MENU INICIAL
	call cartelPuntajes

 ; PANTALLA INFO
	mov bh, 0 ;pagina
	mov dh, 8 ;renglon
	mov dl, 37 ;columna
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, pantallaGame_Loop
	int 21h

  ;ENEMIGOS COLORES
	mov dh, 16  ;en dh recibe la posicion X  (Para posicionamiento del cursor)
	mov dl, 32  ;en dl recibe la posicion Y  
	mov bl, 4   ;en bl el color (rojo)
	mov al, 42  ;Ascii a imprimir
	mov cx, 1   ;cantidad de veces que se imprime(Los imprime para la derecha)
	call imprime
	mov dh, 15 
	mov dl, 32 
	mov bl, 3  ;(cyan)
	mov al, 42 
	mov cx, 1 
	call imprime
	mov dh, 14 
	mov dl, 32 
	mov bl, 2  ;(verde)
	mov al, 42 
	mov cx, 1 
	call imprime
	mov dh, 13 
	mov dl, 32 
	mov bl, 5  ;(magenta)
	mov al, 42
	mov cx, 1 
	call imprime

	;segundo mensaje OTRA VEZ
	mov dh, 20 ;renglon
	mov dl, 21 ;columna
	mov ah, 2
	int 10h
	
	mov ah, 9
	lea dx, bienvenida2
	int 21h

	mov ah, 00h
	int 16h

ret 
menuInicial endp


cartelPuntajes proc

	;Puntajes
	mov dh, 0  ;en dh recibe la posicion X  (Para posicionamiento del cursor)
	mov dl, 25 ;en dl recibe la posicion Y
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, textoScore
	int 21h
	
	mov dh, 0 
	mov dl, 40 
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, textoHighscore
	int 21h

	mov dh, 0 
	mov dl, 33 
	mov ah, 2
	int 10h
	
	mov ah, 9
	lea dx, scoreAscii
	int 21h

	mov dh, 0 
	mov dl, 52 
	mov ah, 2
	int 10h
	
	mov ah, 9
	lea dx, highscoreAscii
	int 21h

ret 
cartelPuntajes endp


imprime proc
	
	mov bh, 0 	;BH = Page Number
	mov ah, 02h ;Set cursor position, con los parametros de dh y dl
	int 10h

	mov ah, 09h ;Write character and attribute at cursor position
	int 10h

ret
imprime endp

imprimeEnemigo proc 

;   ▄█▄█▄
;   █▄█▄█
;    ▀ ▀ 

	mov al, 219
	mov cx, 1               
	call imprime
	add dl, 1
	mov al, 220 
	mov cx, 1 
	call imprime
	add dl, 1
	mov al, 219 
	mov cx, 1 
	call imprime
	add dl, 1
	mov al, 220 
	mov cx, 1 
	call imprime
	add dl, 1
	mov al, 219 
	mov cx, 1 
	call imprime
	sub dh, 1
	mov al, 220 
	mov cx, 1 
	call imprime
	sub dl, 1
	mov al, 219 
	mov cx, 1 
	call imprime
	sub dl, 1
	mov al, 220 
	mov cx, 1 
	call imprime
	sub dl, 1
	mov al, 219 
	mov cx, 1 
	call imprime
	sub dl, 1
	mov al, 220 
	mov cx, 1 
	call imprime
	add dh, 2
	add dl, 1
	mov al, 223 
	mov cx, 1 
	call imprime
	add dl, 2
	mov al, 223 
	mov cx, 1 
	call imprime

ret
imprimeEnemigo endp


imprime_Jugador proc

;  ▄█▄

	mov al, 219    ;Ascii a imprimir
	mov cx, 1      ;cantidad de veces que se imprime(Los imprime para la derecha)
	call imprime
	sub dl, 1
	mov al, 220 
	mov cx, 1
	call imprime
	add dl, 2
	mov al, 220 
	mov cx, 1
	call imprime

ret
imprime_Jugador endp


colisionBala proc

	mov ah, ch
	mov al, cl

	mov cx, 5
Game_LoopCompBala:
	cmp dl, al ;comparo las columnas
	je comparaRengBala
	inc al ;sino comparo la proxima
loop Game_LoopCompBala

	mov cx, 5
Game_LoopCompBalaIzq:
	cmp dl, al ;comparo las columnas
	je comparaRengBala
	dec al ;sino comparo la proxima
loop Game_LoopCompBalaIzq

jmp nadaBala

comparaRengBala:
	cmp dh, ah
	je choqueBala
jmp nadaBala

choqueBala:
	mov dh, 22   ;Pongo la bala en la fila original
	mov ah, 0 		;le mando un "flag" en ah si es 0 mata
	call contPuntaje
	mov cx, 4500 ; TONO 
	mov bx, 15   ; DURACION
	call sonido
	mov cx, 4000 
	mov bx, 15  
	call sonido
	mov cx, 3500 
	mov bx, 15  
	call sonido
	mov cx, 3000
	mov bx, 15 
	call sonido
ret

	nadaBala:
	mov ah, 1 		;le mando un "flag" en ah si es 1 no mata

ret
colisionBala endp

matar_Enemigo proc

	mov bl, 0 
	mov bh, 0   ;para que no se siga imprimiendo en el proximo ciclo
	inc al

ret
matar_Enemigo endp


pulsacion proc

	push ax
	xor ax, ax

	mov ah, 01H ;Get the State of the keyboard buffer
	int 16h
	jz no_se_presiono_tecla
	mov ah, 00H ;Si encuentra una tecla, la obtiene y la manda a AL
	int 16h
	cmp al, 'w' ;cambio la tecla de disparo al espacio
	je dispara
	cmp al, 'W'
	je dispara 
	cmp al,'A'
	je izquierda
	cmp al,'a'
	je izquierda
	cmp al,'D'
	je derecha
	cmp al,'d'
	je derecha
	cmp al, 27 ;decimal: [ESC]
	je toco_ESC
	jmp no_se_presiono_tecla
toco_ESC:
	call fin_con_ERROR_o_ESC

no_se_presiono_tecla:
	pop ax
ret

margen:
	jmp no_se_presiono_tecla

dispara:
	cmp flag_bala, 1
	je no_volver_a_mover_de_lugar_la_bala ;se explica sola la etiqueta no?
	mov cx, 10000 ; TONO 
	mov bx, 30  ; DURACION
	call sonido

	mov flag_bala, 1 ;cambia el flag de la bala a uno para el proximo ciclo
	mov dl, columna_Jugador 
	mov col_bala, dl ;cargo la columna de la bala con la columna del cuadrado azul
	
no_volver_a_mover_de_lugar_la_bala:

	pop ax
ret

izquierda:
	cmp columna_Jugador, 0
	je margen
	sub columna_Jugador, 2
	pop ax
ret

derecha:
	cmp columna_Jugador, 78
	je margen
	add columna_Jugador, 2
	pop ax

ret
pulsacion endp

movimiento_bala proc 
;compara si llega arriba de todo
	cmp dl, 0
	je top
jmp subir_bala

top:
	dec flag_bala ;si llega, el flag vuelve a ser cero
	mov dl, 22	  ;y el renglon 22
jmp finalTop

subir_bala:
	sub dl, 1

finalTop:

ret
movimiento_bala endp


fin_con_ERROR_o_ESC proc

	mov ah, 0Fh
	int 10h
	mov ah, 0
	int 10h


	mov dh, 12 ;en dh recibe la posicion Y } Para posicionamiento del cursor
	mov dl, 35 ;en dl recibe la posicion X  }
	mov bl, 4 ;en bl el color
	mov cx, 1 ;cantidad de veces que se imprime(Los imprime para la derecha)
	mov si, 0
ImprimirGameOver:
	cmp si, 24
	je finImprimirGameOVer
	mov al, ERRORText[si] ;forma/figura a imprimir
	call imprime
	; call retardo
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	call animacionMuerte
	; inc dl
	inc si
jmp ImprimirGameOver

finImprimirGameOVer:
	mov cx, 0

; COLOR BLANCO P/ TEXTO
	mov dh, 10 ; posicion Y 
	mov dl, 32 ; posicion X 
	mov bl, 0fh
	mov cx, 10
	mov al, 20
	call imprime
	add dh, 2
	mov cx, 11
	call imprime
	add dh, 1
	add dl, 4
	mov cx, 4
	call imprime

	mov dh, 10 ; posicion Y 
	mov dl, 32 ; posicion X 
	mov ah, 2
	int 10h
	mov cx, 7000 ; TONO 
	mov bx, 20   ; DURACION
	call sonido
	mov cx, 7500
	mov bx, 20  
	call sonido
	mov cx, 8000 
	mov bx, 20  
	call sonido
	mov cx, 8500 
	mov bx, 20  
	call sonido
	mov cx, 9000
	mov bx, 20  
	call sonido
	mov cx, 9500 
	mov bx, 20 
	call sonido
	mov cx, 10000 
	mov bx, 20  
	call sonido

	mov ah, 9
	lea dx, GameOverText
	int 21h

	mov dh, 12 ;renglon
	mov dl, 31 ;columna
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, textoHighscore
	int 21h

	mov cx, 9500 
	mov bx, 20 
	call sonido
	mov cx, 9000
	mov bx, 20  
	call sonido
	mov cx, 8500 
	mov bx, 20  
	call sonido
	mov cx, 8000 
	mov bx, 20  
	call sonido
	mov cx, 7500
	mov bx, 20  
	call sonido
	mov cx, 7000 
	mov bx, 20 
	call sonido
	
	mov dh, 13 ;renglon
	mov dl, 36 ;columna
	mov ah, 2
	int 10h

	; flag para cargar highscore
	mov al, 1
	call contPuntaje
	
	mov ah, 9
	lea dx, highscoreAscii
	int 21h

	mov cx, 7500
	mov bx, 20  
	call sonido
	mov cx, 8000 
	mov bx, 20  
	call sonido
	mov cx, 8500 
	mov bx, 20  
	call sonido
	mov cx, 9000
	mov bx, 20  
	call sonido
	mov cx, 9500 
	mov bx, 20 
	call sonido
	mov cx, 10000 
	mov bx, 100  
	call sonido
	mov cx, 19000 
	mov bx, 250  
	call sonido

	mov ax, 4c00h
	int 21h
fin_con_ERROR_o_ESC endp

fin_masacre_total proc
	mov ah, 0Fh
	int 10h
	mov ah, 0
	int 10h

	call imprimeCorona

	mov bh, 0 ;pagina
	mov dh, 10 ;renglon
	mov dl, 35 ;columna
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, finJuegoMensaje
	int 21h
; COLOR VERDE:
	mov dh, 15 ;renglon
	mov dl, 34 ;columna
	mov bl, 2
	mov cx, 11
	mov al, 20
	call imprime
; ---------------
	mov dh, 15 ;renglon
	mov dl, 33 ;columna
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, textoHighscore
	int 21h

	mov cx, 3500 ; TONO 
	mov bx, 40   ; DURACION
	call sonido
	
	mov dh, 16 ;renglon
	mov dl, 38 ;columna
	mov ah, 2
	int 10h

	; flag para cargar highscore
	mov al, 1
	call contPuntaje
	
	mov ah, 9
	lea dx, highscoreAscii
	int 21h

	mov cx, 3000
	mov bx, 45  
	call sonido

	mov dh, 18 ;renglon
	mov dl, 30 ;columna
	mov ah, 2
	int 10h

	mov ah, 9
	lea dx, finJuegoMensaje2
	int 21h
	
	mov cx, 2500 
	mov bx, 50 
	call sonido

	mov cx, 2200 
	mov bx, 110  
	call sonido

 ret
fin_masacre_total endp

retardo proc
	push cx
	mov cx, 9FFFh
	decrementa:
	cmp cx, 0
	je incrementa
	dec cx
	jmp decrementa		;Este retardo es bastante choto hay que preguntarle al porfe
	incrementa:
	cmp cx, 9FFFh
	je finDec
	inc cx
	jmp incrementa

	finDec:
	pop cx
	ret
retardo endp


contPuntaje proc
	push dx
	push ax
	push bx

	mov dl, bl
lea bx, scoreAscii
call limpiarVariableAscii

	cmp al, 1
	je asciiHighscore	
 
	cmp dl, 4   ; ROJO
	je scoreRojo
	cmp dl, 3 ; CYAN
	je scoreCyan
	cmp dl, 2 ; VERDE
	je scoreVerde
	cmp dl, 5  ; MAGENTA
	je scoreMag
	jne ningunColor

	xor dh, dh
scoreRojo:
	add score, 1
	jmp asciiScore
scoreCyan:
	add score, 2
	jmp asciiScore
scoreVerde:
	add score, 3
	jmp asciiScore
scoreMag:
	add score, 5
	jmp asciiScore

asciiScore:
	mov dl, score
	lea bx, scoreAscii
	jmp ascii
asciiHighscore:
	lea bx, highscoreAscii
	call limpiarVariableAscii
	mov dl, score
	lea bx, highscoreAscii
ascii:
	call regToAscii

ningunColor:

	pop bx
	pop ax
	pop dx

ret 
contPuntaje endp

animacionMuerte proc

	mov cx, 9FFFh
	decrementaAnimacion:
	cmp cx, 0
	je incrementaAnimacion
	dec cx
	jmp decrementaAnimacion
	incrementaAnimacion:
	cmp cx, 9FFFh
	je finDecAnimacion
	inc cx
	jmp incrementaAnimacion

	finDecAnimacion:

	ret
animacionMuerte endp

regToAscii proc

    push ax
    push dx
    push cx
    push si
    push bx

    xor si,si
    xor ax, ax
    mov al, dl ;MUEVO EL NUMERO(reg) A al PARA HACER LA DIVISION

    mov cx, 3
rta: ;("Reg.To.Ascii" = rta)
    mov dl, dataDiv[si] ; [si] -> dataDivMul
    div dl 
    add [bx],al     ; Se suma porque [bx] es "000", o sea: 30h, 30h, 30h
    xchg al, ah     ;INTERCAMBIA VALORES
    xor ah, ah 
    inc bx 
    inc si
 loop rta
        
    pop bx
	pop si
    pop cx
    pop dx
    pop ax

ret
regToAscii endp

limpiarVariableAscii proc
	push bx
	push cx 

    mov cx, 4  
 limpiarNroAscii:
    mov [bx], byte ptr 30h
    inc bx
loop limpiarNroAscii

	pop cx
	pop bx
 ret 
limpiarVariableAscii endp

imprimeCorona proc 
	push dx
	push cx 
	push ax
	push bx

;	▄   █   ▄
;	██▄███▄██
;	█████████

	mov dh, 8 ;renglon
	mov dl, 35 ;columna
	mov bl, 0eh ; AMARILLO

	mov al, 219
	mov cx, 9               
	call imprime
	sub dh, 1
	mov al, 219 
	mov cx, 2
	call imprime
	add dl, 2
	mov al, 220 
	mov cx, 1 
	call imprime
	add dl, 1
	mov al, 219 
	mov cx, 3 
	call imprime
	add dl, 3
	mov al, 220 
	mov cx, 1 
	call imprime
	add dl, 1
	mov al, 219 
	mov cx, 2 
	call imprime
	sub dh, 1
	add dl, 1
	mov al, 220 
	mov cx, 1 
	call imprime
	sub dl, 4
	mov al, 219 
	mov cx, 1 
	call imprime
	sub dl, 4
	mov al, 220 
	mov cx, 1 
	call imprime

	pop bx
	pop ax
	pop cx
	pop dx
ret
imprimeCorona endp
; ------------------------------------------------------------------
; http://muruganad.com/8086/8086-assembly-language-program-to-play-sound-using-pc-speaker.html
; os_play_sound -- Play a single tone using the pc speaker
; IN: CX = tone, BX = duration

sonido proc
	push ax
    push cx
    push bx
    mov     ax, cx

    ; ACTIVA EL SONIDO
    out     42h, al
    mov     al, ah
    out     42h, al
    in      al, 61h

    or      al, 00000011b
    out     61h, al

    pause1:
        mov cx, 65535

    pause2:
        dec cx
        jne pause2
        dec bx
        jne pause1

    ; DESACTIVA EL SONIDO
        in  al, 61h
        and al, 11111100b
        out 61h, al
        
    pop bx
    pop cx
    pop ax

    ret
sonido endp

end