FUNCIONES GENERALIZADAS
ACTUALIZADAS ULTIMA VEZ: 1/6


# CALL IMPRIMIR
=> parametros que recibe la funcion.-
	dh: renglon
	dl: columna
	bl: color
	al: forma/caracter a imprimir
	cx: repeticion
=> codigo.-
	proc imprime
		;rutina de posicionamiento en pantalla
		mov bh, 0 ;pagina
		mov ah, 2 ;posicionamiento del cursor con los parametros de dh y dl
		int 10h
		mov ah, 9h ;imprimo el cuerpo con la rutina 9
		mov bh, 0
		int 10h
		ret
	imprime endp


# CALL PULSACION
=> parametros que recibe la funcion.-
	no recibe parametros
=> codigo.-
	proc pulsacion
		push dx
		xor ax,ax ;limpia el registro
		int 16h	;espera recibir el caracter en al
		cmp al,'W'
		je sube 
		cmp al,'w'
		je sube
		cmp al,'A'
		je izquierda
		cmp al,'a'
		je izquierda
		cmp al,'S'
		je baja
		cmp al,'s'
		je baja
		cmp al,'D'
		je derecha
		cmp al,'d'
		je derecha
		cmp al, 27 ;caracter 'esc'
		je fin
		jmp volver ;si se presiona una tecla no validada, sale
		fin:
		call finDelJuego
		volver:
		pop dx
		ret
		;Esta en el borde, entonces no hago nada
		margen:
		jmp volver
		sube:
		cmp reng, 0
		je margen
		sub reng, 2
		pop dx
		ret
		baja:
		cmp reng, 24
		je margen
		add reng, 2
		pop dx
		ret
		izquierda:
		cmp col, 0
		je margen
		sub col, 2
		pop dx
		ret
		derecha:
		cmp col, 78
		je margen
		add col, 2
		pop dx
		ret
	pulsacion endp


# CALL ACTUALIZAPOS
=> parametros que recibe la funcion.-
	dh: columnas
	dl: renglones
	ch: columnas anteriores
	cl: renglones anteriores
=> codigo.-
	proc actualizaPos
		mov ch, dh
		mov cl, dl
		ret
	actualizaPos endp
=> devuelve.-
	ch: columnas previas actualizadas
	cl: renglones previos actualizados


# CALL BORRADO
=> parametros que recibe la funcion.-
	dh: renglon anterior a donde estoy
	dl: columna anterior a donde estoy
	ch: el renglon actual
	cl: columna actual
	al: forma a imprimir
	bl: color
	cx: repeticion
=> codigo.-
	proc borrado
		;rutina de posicionamiento en pantalla
		mov bh, 0 ;pagina
		mov ah, 2
		int 10h
		;pinto de negro donde estaba el cuadrado
		mov ah, 09h
		mov bh, 0
		int 10h
		ret
	borrado endp


#CALL MOVSECUNDARIO
=> parametros que recibe la funcion.-
	dh: columna donde se encuentra
=> codigo.-
	;La idea es la siguiente: que cuando llegue al margen derecho, sea 0 otra vez
	;y vuelva a empezar
	comparacion:
	cmp dh, 78
	je vuelve
	jmp suma
	vuelve:
	mov dh, 0
	jmp final
	suma:
	add dh, 1
	final:
	ret
movSecundario endp
=> devuelve.-
	dh: columna actualizada


# CALL RETARDO
=> parametros que recibe la funcion.-
	no recibe parametros
=> codigo.-
	proc retardo
		mov cx, 9FFFh
		decrementa:
		cmp cx, 0
		je incrementa
		dec cx
		jmp decrementa
		incrementa:
		cmp cx, 9FFFh
		je decrementa2
		inc cx
		jmp incrementa
		decrementa2:
		cmp cx, 0
		je incrementa2
		dec cx
		jmp decrementa2
		incrementa2:
		cmp cx, 9FFFh
		je decrementa3
		inc cx
		jmp incrementa2
		decrementa3:
		cmp cx, 0
		je finDec
		dec cx
		jmp decrementa3
		finDec:
		ret
	retardo endp

# CALL CAMBIAPAG
=> parametros que recibe la funcion.-
	al: pagina
=> codigo.-
	proc cambiaPag
		mov ah, 05h
		int 10h
		ret
	cambiaPag endp


# CALL COLISION
=> parametros que recibe la funcion.-
	dh: posicion renglon del cuadrado azul
	dl: posicion columna del cuadrado azul
	ch: renglon del cuadrado rojo
	cl: columna del cuadrado rojo
=> codigo.-
	proc colision
		cmp dl, cl
		je comparaReng
		jmp nada
		comparaReng:
		cmp dh, ch
		je choque
		jmp nada
		choque:
		call finDelJuego
		nada:
		ret
	colision endp

# CALL MOVVERTICAL
=> parametros que recibe la funcion.-
	dl: el renglon de la bala
=> codigo.-
	proc movVertical
		push cx
		xor cx, cx
		call retardo
		call retardo
		pop cx
		comparacionTop: ;compara si llega arriba de todo
		cmp dl, 0
		je top
		jmp resta4
		top:
		dec flag_bala ;si llega, el flag vuelve a ser cero
		mov dl, 24	  ;y el renglon 24
		jmp finalTop
		resta4:
		sub dl, 1
		finalTop:
		ret
	movVertical endp
=> devuelve.-
	dl: el renglon nuevo de la bala

# CALL COLISIONBALA
=> parametros que recibe la funcion.-
	dh: el renglon de la bala
	dl: la columna de la bala
	ch: el renglon del enemigo
	cl: la columna del enemigo
=> codigo.-
	proc colisionBala
		mov ah, 1
		cmp dl, cl ;comparo las columnas 
		je comparaRengBala ;si es igual, salta a ver los renglones
		inc cl ;sino comparo la proxima
		cmp dl, cl
		je comparaRengBala
		dec cl
		dec cl ;y la anterior
		cmp dl, cl
		je comparaRengBala
		inc cl
		jmp nadaBala ;sino sale
		comparaRengBala:
		cmp dh, ch ;por ultimo compara los renglones
		je choqueBala
		jmp nadaBala
		choqueBala:
		mov ah, 0 ;muevo ah = 0 como un flag
		ret
		nadaBala:
		ret
	colisionBala endp
=> devuelve.-
	ah: un cero para comparacion
