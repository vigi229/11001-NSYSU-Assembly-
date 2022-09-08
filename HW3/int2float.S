	.cpu arm926ej-s
	.fpu softvfp
	.text
	.align	2   @align 4 byte
	.global	main
main:
	stmfd	sp!, {r4-r9,fp,lr}
	ldr	r4,[r1,#4]
	ldrb	r3,[r4,#0]
	cmp	r3,#'N'
	movne	r5,#0
	bne	NonNeg
	moveq	r5,#1
	moveq	r3,#'0'
	strb	r3,[r4,#0]
NonNeg:
	ldr	r0,[r1,#4]
	mov	r2,#10
	bl	strtol
	mov	r6,r0
	clz	r7,r6
	add	r7,r7,#1
	mov	r9,r6,lsl r7
	mov	r9,r9,lsr r7
	rsb	r7,r7,#32
	add	r8,r7,#127
@print ex:-1995 is coded by
	cmp	r5,#1
	mov	r1,r6
	ldreq	r0,=NEG
	ldrne	r0,=PLUS
	bl	printf
	ldr	r0,=string0
	bl	printf
@print signed bit
	mov	r1,r5		
	ldr	r0,=PLUS
	bl	printf
@print E(+127)
	mov	r0,r8
	mov	r1,#8
	mov	r2,#8
	bl	PrintBinary
@print fraction
	mov	r0,r9
	mov	r1,#23
	mov	r2,r7
	bl	PrintBinary

	ldmfd	sp!, {r4-r9,fp,lr}
	bx	lr
PrintBinary:
	stmfd	sp!, {r4-r7,fp,lr}
	mov	r4,r0
	mov	r5,r1
	mov	r7,r2
LOOP:
	mov	r6,#1
	subs	r7,r7,#1
	movgt	r6,r6,lsl r7
	cmp	r4,r6
	movlt	r0,#'0'
	movge	r0,#'1'
	subge	r4,r4,r6
	bl	putchar
	subs	r5,r5,#1
	bne	LOOP
	ldmfd	sp!, {r4-r7,fp,lr}
	bx	lr

PLUS:
	.ascii	"%d\0"
NEG:
	.ascii	"-%d\0"
string0:
	.ascii	" is coded by \0"

