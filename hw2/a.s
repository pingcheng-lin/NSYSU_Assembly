@the information that tells arm-none-eabi-as what arch. to assemble to 
	.cpu arm926ej-s
	.fpu softvfp

@this is code section
@note, we must have the main function for the simulator's linker script
	.text
	.align	2   @align 4 byte
	.global	main
main:
    @prologue
	stmfd	sp!, {fp, lr}
	add	fp, sp, #4

    @code body
	ldr r6, [r1, #4] @load string
	ldr r7, [r1, #8]
	ldr r12, [r1, #12]
	cmp r12, #0
	beq LACKOP
	cmp r7, #0
	beq LACKB
	cmp r12, #0
	beq LACKA
	mov r4, r6
	mov r5, r7
	@r1: judge input 0
	@r3: string of intA
	@r4: string of intB
	@r5: string of op
	@r6: total number of A	
	@r7: total number of B
	@r8: 1.judge weird input 2.total number of op
	mov r8, #0

	@get intA and convert to int------------
	mov r10, #0 @r10: counter
LOOPA:
	ldrb r9, [r4], #1
	cmp r9, #' '
	cmpne r9, #0
	beq ENDLOOPA
	cmp r9, #'0'
	blt ADDA
	cmpge r9, #'9'
	ble OKA
ADDA:
	cmp r8, #0
	addle r8, r8, #1
OKA:
	strb r9, [r3, r10]
	add r10, r10, #1
	b LOOPA
ENDLOOPA:
	mov r2, #0
	strb r2, [r3, r10]
	
	cmp r8, #0 @prevent occur "." or "-"
	bne NEXTB

	mov r6, #0 @r6 = result
	mov r9, #10 @r9 = for multiply 10
CONVERTA:
	ldrb r10, [r3], #1 @r10 = each byte in string
	cmp r10, #0 @to see if it need to terminate
	mulne r4, r6, r9 @result = result * 10
	movne r6, r4
	subne r10, r10, #'0' @r10 change to int
	addne r6, r6, r10 @ result = result + num
	bne CONVERTA

	mov r1, #0
	cmp r6, #0 @prevent occur "arithm 0 x x"
	addeq r1, r1, #1

	@get intB and convert to int-------------
NEXTB:
	mov r10, #0
LOOPB:
	ldrb r9, [r5], #1
	cmp r9, #' '
	cmpne r9, #0
	beq ENDLOOPB
	cmp r9, #'0'
	blt ADDB
	cmpge r9, #'9'
	ble OKB
ADDB:
	cmp r8, #1
	addle r8, r8, #2
OKB:
	strb r9, [r4, r10]
	add r10, r10, #1
	b LOOPB
ENDLOOPB:
	mov r2, #0
	strb r2, [r4, r10]

	cmp r8, #0
	bne ERROR

	mov r3, r4 @purpose: op7

	mov r7, #0
	mov r9, #10 
CONVERTB:
	ldrb r10, [r4], #1 
	cmp r10, #0 
	mulne r5, r7, r9
	movne r7, r5
	subne r10, r10, #'0'
	addne r7, r7, r10
	bne CONVERTB

	cmp r7, #0 @prevent occur "arithm x 0 x"
	addeq r1, #2
	cmp r1, #0
	bne ERROR0

	@get op and convert to int-----------
	ldrb r9, [r12], #1
	strleb r9, [r5]
	ldrb r9, [r12], #1
	cmp r9, #0
	bne ERROROP
	strb r9, [r5, #1]

	ldrb r10, [r5]
	sub r8, r10, #'0'
	cmp r8, #0
	blt ERROROP
	cmp r8, #8
	bgt ERROROP
	@-------end convert------

	@r3: store string of B
	@r4: result
	@r5: temp
	@r6: total number of A	
	@r7: total number of B
	@r8: total number of op
	@r9: temp
	@r10: temp
	@r12: temp
	@get intA and convert to int

	ldr r12, =JUMPTABLE
	cmp r8 ,#8
	addls pc, r12, r8, lsl #2
	b EXIT
L1:
	add r3, r6, r7 @compute
	ldr r0, =STR1
	mov r1, r6
	mov r2, r7
	bl printf
	b EXIT
L2:
	sub r3, r6, r7 @compute
	ldr r0, =STR2
	mov r1, r6
	mov r2, r7
	bl printf
	b EXIT
L3:
	mov r2, #0 @start compute
	mov r9, r6
	mov r10, #0
TO32:
	movs r9, r9, lsr #1
	adc r2, r2, #0
	cmp r10, #31
	addne r10, r10, #1
	movne r2, r2, lsl #1
	bne TO32 @end compute
	ldr r0, =STR3
	mov r1, r6
	bl printf
	b EXIT
L4:
	mov r9, r6 @start compute
	mov r3, #0 
LOOP4:
	mov r10, r7
	cmp r9, r10
	subge r9, r9, r10
	addge r3, r3, #1
	bge LOOP4 @end compute
	ldr r0, =STR4
	mov r1, r6
	mov r2, r7
	bl printf
	b EXIT
L5:
	cmp r6, r7 @start compute
	movge r3, r6
	movlt r3, r7 @end compute
	ldr r0, =STR5
	mov r1, r6
	mov r2, r7
	bl printf
	b EXIT
L6:
	mov r10, r7 @start compute
	mov r3, #1 
LOOP6:	
	cmp r10, #0
	subne r10, r10, #1
	movne r9, r3
	mulne r3, r9, r6 
	bne LOOP6 @end compute
	ldr r0, =STR6
	mov r1, r6
	mov r2, r7
	bl printf
	b EXIT
L7:
	mov r10, r6
	mov r12, r7
LOOP7: @start compute
	cmp r10, r12 
	movlt r9, r10
	movlt r10, r12
	movlt r12, r9
	sub r10, r10, r12
	cmp r10, #0
	bne LOOP7
	mov r3, r12 @end compute
	ldr r0, =STR7
	mov r1, r6
	mov r2, r7
	bl printf
	b EXIT
L8:
	ldr r0, =STR8
	mov r1, r6
	mov r2, r7
	mul r3,r6,r7 @compute
	bl printf
	b EXIT
L9:
	mul r5, r6, r7 @a*b
	mov r10, r6 @gcd
	mov r12, r7
LOOP91:
	cmp r10, r12 
	movlt r9, r10
	movlt r10, r12
	movlt r12, r9
	sub r10, r10, r12
	cmp r10, #0
	bne LOOP91
	mov r3, #0 @a*b/gcd
LOOP92:
	cmp r5, r12
	subge r5, r5, r12
	addge r3, r3, #1
	bge LOOP92 @end compute
	ldr r0, =STR9
	mov r1, r6
	mov r2, r7
	bl printf
	b EXIT
	
EXIT:
	@epilogue
	sub	sp, fp, #4
	ldmfd	sp!, {fp, lr}
	bx	lr

@another function
JUMPTABLE: 
	b L1
	b L2
	b L3
	b L4
	b L5
	b L6
	b L7
	b L8
	b L9
ERROR:
	cmp r8, #1
	ldreq r0, =ERR1_1
	mov r1, r6
	bleq printf
	beq EXIT

	cmp r8, #2
	ldreq r0, =ERR1_2
	mov r1, r7
	bleq printf
	beq EXIT

	cmp r8, #3
	ldreq r0, =ERR2
	mov r1, r6
	mov r2, r7
	bleq printf
	beq EXIT

	b EXIT
ERROROP:
	ldr r0, =ERROP
	bl printf
	b EXIT
LACKA:
	ldr r0, =LACA
	bl printf
	b EXIT
LACKB:
	ldr r0, =LACB
	bl printf
	b EXIT
LACKOP:
	ldr r0, =LACOP
	bl printf
	b EXIT

ERROR0:
	cmp r1, #1
	ldreq r0, =A0
	bleq printf
	beq EXIT

	cmp r1, #2
	ldreq r0, =B0
	bleq printf
	beq EXIT

	cmp r1, #3
	ldreq r0, =AB0
	bleq printf
	beq EXIT

@data section
STR1:
	.asciz "Fuction 0: addtion of %d and %d is %d."
STR2:
	.asciz "Fuction 1: subtraction of %d and %d is %d."
STR3:
	.asciz "Fuction 2: bit-reverse of %d is %d."
STR4:
	.asciz "Fuction 3: division of %d and %d is %d."
STR5:
	.asciz "Fuction 4: maximum of %d and %d is %d."
STR6:
	.asciz "Fuction 5: exponent of %d and %d is %d."
STR7:
	.asciz "Fuction 6: greatest common divisor of %d and %d is %d."
STR8:
	.asciz "Fuction 7: multiplication of %d and %d is %d"
STR9:
	.asciz "Fuction 8: least common multiply of %d and %d is %d."
ERR1_1:
	.asciz "Invalid input operands: %s"
ERR1_2:
	.asciz "Invalid input operands: %s"
ERR2:
	.asciz "Invalid input operands: %s, %s"
ERROP:
	.asciz "Invalid op."
LACA:
	.asciz "Lack of intA, intB, and op."
LACB:
	.asciz "Lack of intB and op."
LACOP:
	.asciz "Lack of op."
A0:
	.asciz "IntA cannot be 0."
B0:
	.asciz "IntB cannot be 0."
AB0:
	.asciz "IntA and IntB cannot be 0."
