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
	ldr r0, [r1] @print execute prog name
	ldr r6, [r1,#4] @r0 store argc; r1 store command line

	bl printf 
	adr r0, label @print result:
	bl printf

	mov r5, #0 @counter
loop2:
	ldrb r3, [r6], #1
	cmp r3, #0
	beq end
	cmp r3, #'z'
	bgt loop2
	cmp r3, #'A'
	blt loop2
	cmp r3, #'Z'
	ble case 
	cmp r3, #'a'
	blt loop2
stor:	
	strb r3, [r0, r5]
	add r5, r5, #1
	b loop2
end:
	strb r3, [r0, r5]
	bl printf

	@epilogue
	sub	sp, fp, #4
	ldmfd	sp!, {fp, lr}
	bx	lr

@another function
case:
	add r3, r3, #32
	b stor

@data section
label:
	.ascii " result: "
