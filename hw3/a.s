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
	ldr r0, =START @print title
    bl printf
    bl start_deasm
    .include "test.s"
start_deasm:
	ldr r8, =start_deasm
    mov r4, lr @r4 store first pc in test.s
	mov r5, r4 @r5 store pc in test.s
LOOP:
	cmp r8, r5 @exit loop if pc run whole test.s
	ble EXIT

	ldr r0, =COUNTER @print pc
	sub r1, r5, r4
	bl printf

	ldr r6, [r5], #4 @r6 store content of r5

	mov r7, r6, lsr #28 @r7 store content of condition
	cmp r7, #0
	ldreq r0, =CONDITION0
	cmp r7, #1
	ldreq r0, =CONDITION1 
	cmp r7, #2
	ldreq r0, =CONDITION2  
	cmp r7, #3
	ldreq r0, =CONDITION3 
	cmp r7, #4
	ldreq r0, =CONDITION4 
	cmp r7, #5
	ldreq r0, =CONDITION5 
	cmp r7, #6
	ldreq r0, =CONDITION6 
	cmp r7, #7
	ldreq r0, =CONDITION7  
	cmp r7, #8
	ldreq r0, =CONDITION8 
	cmp r7, #9
	ldreq r0, =CONDITION9 
	cmp r7, #10
	ldreq r0, =CONDITION10
	cmp r7, #11
	ldreq r0, =CONDITION11
	cmp r7, #12
	ldreq r0, =CONDITION12
	cmp r7, #13
	ldreq r0, =CONDITION13
	cmp r7, #14
	ldreq r0, =CONDITION14
	cmp r7, #15
	ldreq r0, =CONDITION15 
	bl printf

	@see which type is the instruction
	mov r7, r6, lsl #4
	mov r7, r7, lsr #28
	cmp r7, #10
	ldreq r0, =BRANCH0
	beq BRANCH
	cmp r7, #11
	ldreq r0, =BRANCH1
	bne PROCESS
BRANCH:
	bl printf
	mov r7, r6, lsl #8
	mov r7, r7, lsr #31
	cmp r7, #1
	bleq COMPLEMENT
	bleq printf
	beq LOOP
	and r7, r6, #0x00FFFFFF
	add r7, r7, #1
	add r1, r5, r7, lsl #2
	ldr r0 ,=DESTINATION_B
	bl printf
	b LOOP



PROCESS:
	mov r7, r6, lsl #4 
	mov r7, r7, lsr #30
	cmp r7, #0
	ldrne r0, =ELSE
	bne LOO

	mov r7, r6, lsl #7
	mov r7, r7, lsr #28
	cmp r7, #0
	ldreq r0, =PROCESSING0
	cmp r7, #1
	ldreq r0, =PROCESSING1
	cmp r7, #2
	ldreq r0, =PROCESSING2
	cmp r7, #3
	ldreq r0, =PROCESSING3
	cmp r7, #4
	ldreq r0, =PROCESSING4
	cmp r7, #5
	ldreq r0, =PROCESSING5
	cmp r7, #6
	ldreq r0, =PROCESSING6
	cmp r7, #7
	ldreq r0, =PROCESSING7
	cmp r7, #8
	ldreq r0, =PROCESSING8
	bleq printf
	beq DEST
	cmp r7, #9
	ldreq r0, =PROCESSING9
	bleq printf
	beq DEST
	cmp r7, #10
	ldreq r0, =PROCESSING10
	bleq printf
	beq DEST
	cmp r7, #11
	ldreq r0, =PROCESSING11
	bleq printf
	beq DEST
	cmp r7, #12
	ldreq r0, =PROCESSING12
	cmp r7, #13
	ldreq r0, =PROCESSING13
	cmp r7, #14
	ldreq r0, =PROCESSING14
	cmp r7, #15
	ldreq r0, =PROCESSING15
	bl printf

	mov r7, r6, lsl #11
	mov r7, r7, lsr #30
	cmp r7, #0
	ldr r0, =PROCESS_NOS
	bleq printf
	beq DEST
	ldr r0, =PROCESS_S
	bl printf

DEST:
	mov r1, r6
	mov r7, r6, lsl #16
	mov r1, r7, lsr #28
	ldr r0, =DESTINATION
	bl printf

	b LOOP

EXIT:
	@epilogue
	sub	sp, fp, #4
	ldmfd	sp!, {fp, lr}
	bx	lr

@another function
COMPLEMENT:
	mov r10, #0
	ldr r12, =0x00FFFFFF
	and r7, r6, r12
	eor r7, r7, r12
	sub r7, r10, r7
	add r1, r5, r7, lsl #2
	ldr r0 ,=DESTINATION_B
	bx lr
LOO:
	bl printf
	b LOOP
@data section
START:
	.asciz "PC\tcondition\tinstruction\tdestination\n"
COUNTER:
	.asciz "%d\t"
CONDITION0:
	.asciz "EQ\t\t"
CONDITION1:
	.asciz "NE\t\t"
CONDITION2:
	.asciz "CS/HQ\t\t"
CONDITION3:
	.asciz "CC/HS\t\t"
CONDITION4:
	.asciz "MI\t\t"
CONDITION5:
	.asciz "PL\t\t"
CONDITION6:
	.asciz "VS\t\t"
CONDITION7:
	.asciz "VC\t\t"
CONDITION8:
	.asciz "HI\t\t"
CONDITION9:
	.asciz "LS\t\t"
CONDITION10:
	.asciz "GE\t\t"
CONDITION11:
	.asciz "LT\t\t"
CONDITION12:
	.asciz "GT\t\t"
CONDITION13:
	.asciz "LE\t\t"
CONDITION14:
	.asciz "AL\t\t"
CONDITION15:
	.asciz "NV\t\t"
PROCESSING0:
	.asciz "AND"
PROCESSING1:
	.asciz "EOR"
PROCESSING2:
	.asciz "SUB"
PROCESSING3:
	.asciz "RSB"
PROCESSING4:
	.asciz "ADD" 
PROCESSING5:
	.asciz "ADC"
PROCESSING6:
	.asciz "SBC"
PROCESSING7:
	.asciz "RSC"
PROCESSING8:
	.asciz "TST\t\t"
PROCESSING9:
	.asciz "TEQ\t\t"
PROCESSING10:
	.asciz "CMP\t\t"
PROCESSING11:
	.asciz "CMN\t\t"
PROCESSING12:
	.asciz "ORR"
PROCESSING13:
	.asciz "MOV"
PROCESSING14:
	.asciz "BIC"
PROCESSING15:
	.asciz "MVN"
BRANCH0:
	.asciz "B\t\t"
BRANCH1:
	.asciz "BL\t\t"
DESTINATION:
	.asciz "r%d\n"
DESTINATION_B:
	.asciz "%d\n"
PROCESS_S:
	.asciz "S\t\t"
PROCESS_NOS:
	.asciz "\t\t"
ELSE:
	.asciz "\n"
