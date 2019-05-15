.equ PIXELS, 0x08000000
.equ SIZE, 0x80000
BUFFER:
.space 0xfff

MEMORY:
.space 0xffff

.global _start

.macro DRAW_PIXEL x, y, col
	mov r2, \x
    mov r3, \y
    mov r4, \col
    call WritePixel
.endm

.macro DRAW_LINE x1, y1, x2, y2, col
	mov r2, \x1
    mov r3, \y1
    mov r4, \x2
    mov r5, \y2
    mov r6, \col
    call DrawLine
.endm

.macro DRAW_TRIANGLE x1, y1, x2, y2, x3, y3, col
	DRAW_LINE \x1, \y1, \x2, \y2, \col
	DRAW_LINE \x2, \y2, \x3, \y3, \col
    DRAW_LINE \x3, \y3, \x1, \y1, \col
.endm

.macro POINT_3D x1, y1, z1
	
.endm

.macro CLEAR_SCREEN col
    mov r5, \col
    call ClearScreen
.endm

_start:
	movia sp, [BUFFER]

	movi r22, %lo(0x0000) # color
    CLEAR_SCREEN r22
    
    #br _start0
    movi r20, 125
    movi r21, 45
    movi r22, 125
    movi r23, 195
    movi r24, %lo(0xffff)
    DRAW_LINE r20, r21, r22, r23, r24
    
    movi r20, 50
    movi r21, 120
    movi r22, 200
    movi r23, 120
    movi r24, %lo(0xffff)
    DRAW_LINE r20, r21, r22, r23, r24
    
    movi r20, 70
    movi r21, 55
    movi r22, 70
    movi r23, 105
    movi r24, %lo(0xffff)
    DRAW_LINE r20, r21, r22, r23, r24
    
    movi r20, 145
    movi r21, 55
    movi r22, 145
    movi r23, 105
    movi r24, %lo(0xffff)
    DRAW_LINE r20, r21, r22, r23, r24
    
    movi r20, 150
    movi r21, 165
    movi r22, 190
    movi r23, 165
    movi r24, %lo(0xffff)
    DRAW_LINE r20, r21, r22, r23, r24
    
    movi r20, 90
    movi r21, 130
    movi r22, 90
    movi r23, 180
    movi r24, %lo(0xffff)
    DRAW_LINE r20, r21, r22, r23, r24
    
    movi r20, 70
    movi r21, 130
    movi r22, 70
    movi r23, 180
    movi r24, %lo(0xffff)
    DRAW_LINE r20, r21, r22, r23, r24
    
    movi r20, 145
    movi r21, 130
    movi r22, 145
    movi r23, 180
    movi r24, %lo(0xffff)
    DRAW_LINE r20, r21, r22, r23, r24
    
    movi r20, 170
    movi r21, 65
    movi r22, 170
    movi r23, 105
    movi r24, %lo(0xffff)
    DRAW_LINE r20, r21, r22, r23, r24
    
    br end
    _start0:
    
    movi r17, 10
    movi r18, 10
    movi r19, 100
    movi r20, 20
    movi r21, 25
    movi r22, 200
    movi r23, %lo(0xf00f)
    DRAW_TRIANGLE r17, r18, r19, r20, r21, r22, r23
    
	br end

DrawLine:
    stw r10, 0(sp)
    stw r11, 4(sp)
    stw r12, 8(sp)
    stw r13, 12(sp)
    stw r14, 16(sp)
    stw r15, 20(sp)
    stw r16, 24(sp)
    stw r17, 28(sp)
    stw r18, 32(sp)
    stw r2, 36(sp)
    stw r3, 40(sp)
    stw r4, 44(sp)
    stw r5, 48(sp)
    stw r6, 52(sp)
    stw r19, 56(sp)
    
    movi r10, 0
    
    bgt r4, r2, _dl0
    mov r10, r2
    mov r2, r4
    mov r4, r10
    
    mov r11, r3
    mov r3, r5
    mov r5, r11
    movi r17, 1
    _dl0:
    
    bgt r5, r3, _dl1
    mov r11, r3
    mov r3, r5
    mov r5, r11
    
    movi r19, 1
    _dl1:
    
    sub r10, r4, r2
    sub r11, r5, r3
    mov r14, r2
    mov r15, r3
    
    bgt r11, r10, _dl_vert
    _dl_hori:
    movi r12, 0
    _dl_hori_l:
    addi r12, r12, 1
    
    movi r1, 1
    bgt r17, r1, _dl_hori_l2
    _dl_hori_l1:
    bgt r19, r1, _dl_hori_l2
    
    add r13, r10, r14
   	sub r13, r13, r12
    br _dl_hori_l3
    _dl_hori_l2:
    bgt r1, r19, _dl_hori_l1
    
    add r13, r14, r12
    _dl_hori_l3:
    muli r13, r13, 2
    
    mov r16, r11
    mul r16, r16, r12
    div r16, r16, r10
    add r16, r16, r15
    
    muli r3, r16, 0x400
    add r3, r3, r13
   	movia r18, PIXELS
    add r18, r18, r3
	sthio r6, 0(r18)
    
    bgt r10, r12, _dl_hori_l
    br _dll
    
    _dl_vert:
    movi r12, 0
    
    _dl_vert_l:
    addi r12, r12, 1
    
    mov r16, r12
    mul r16, r16, r10
    div r16, r16, r11
    add r16, r16, r14
    muli r16, r16, 2
    
    movi r1, 1
    bgt r19, r1, _dl_vert_l2
    _dl_vert_l1:
    bgt r17, r1, _dl_vert_l2
    
    add r13, r11, r15
    sub r13, r13, r12
    br _dl_vert_l3
    _dl_vert_l2:
    bgt r1, r17, _dl_vert_l1
    
    add r13, r12, r15
    _dl_vert_l3:
    
    muli r3, r13, 0x400
    add r3, r3, r16
   	movia r18, PIXELS
    add r18, r18, r3
	sthio r6, 0(r18)
    
    bgt r11, r12, _dl_vert_l
    br _dll
_dll: # Draw line loop
	
_dlr: # Draw line return
    ldw r10, 0(sp)
    ldw r11, 4(sp)
    ldw r12, 8(sp)
    ldw r13, 12(sp)
    ldw r14, 16(sp)
    ldw r15, 20(sp)
    ldw r16, 24(sp)
    ldw r17, 28(sp)
    ldw r18, 32(sp)
    ldw r2, 36(sp)
    ldw r3, 40(sp)
    ldw r4, 44(sp)
    ldw r5, 48(sp)
    ldw r6, 52(sp)
    ldw r19, 56(sp)
    
    ret

WritePixel:
    movia ea, PIXELS
    muli r3, r3, 0x400
    add r3, r3, r2
   	add ea, ea, r3
	sthio r4, 0(ea)
    ret

ClearScreen:
	movia r6, PIXELS
    movia r4, SIZE
    subi r4, r4, 2
    
_csl:
    sthio r5, 0(r6)
    subi r4, r4, 2
    
    ble r4, r0, _csr
    addi r6, r6, 2
    
	bgt r4, r0, _csl
_csr:
	movi r6, 0
    ret
    
end:
.end
