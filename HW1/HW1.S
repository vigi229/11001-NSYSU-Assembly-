@this is comment

@the information that tells arm-none-eabi-as what arch. to assemble to 
	.cpu arm926ej-s
	.fpu softvfp

@this is code section
@note, we must have the main function for the simulator's linker script
	.text
	.align	2   @align 4 byte
	.global	main
main:
	stmfd	sp!, {r0,r1,r4,r5,fp,lr}	@store original register content
	mov	r5,r1				@store before printf, otherwise r1 would be changed! Remember!!!
	ldr	r0,=string0			@print "reversed resault:"
	bl	printf	
	ldr	r0,[r5,#4]			@load string in r0
	bl	strlen				@use strlen to know the length of string(use gcc c code ->assembly file)
	subs	r4,r0,#1			@as c-code, the last word is at length-1 (It will use r0 later,so store the place-flag in r4)
LOOP:
	ldr	r1,[r5,#4]			@load the string again in r1(must do it in LOOP because r1 would be changed at "bl putchar")
	ldrb	r0,[r1,r4]			@pick one word
	cmp	r0,#'A'				@compare: not capital->branch
	blt	NOTCAPITAL
	cmp	r0,#'Z'
	bgt	NOTCAPITAL
	add	r0,r0,#32			@capital: +32 to become lower-case
NOTCAPITAL:
	bl	putchar				@print one char(can't use printf [gcc c code ->assembly file])
	subs	r4,r4,#1
	bge	LOOP
FINISH:
	ldmfd	sp!, {r0,r1,r4,r5,fp,lr}	@load original register content to recover
	bx	lr
string0:
	.ascii	"reversed resault:\0"
