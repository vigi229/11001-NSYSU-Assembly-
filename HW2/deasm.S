	.cpu arm926ej-s
	.fpu softvfp
	.text
	.align	2   @align 4 byte
	.global	main
main:
	stmfd	sp!,{r4-r9,fp,lr}
	adr	r4,start_deasm
	mov	r6,#0
        bl      start_deasm		
        .include "test.s"
start_deasm:
	mov	r5, lr
	mov	r9, r5
	cmp	r4,r5
	beq	EXIT
	ldr	r0,=Title
	bl	printf
LOOP:
@print pc
	ldr	r0,=PC
	mov	r1,r6
	bl	printf
	ldr	r7,[r5]
	@ldr	r0,=test
	@mov	r1,r7
	@bl	printf
@print condition
	lsr	r3,r7,#28
	ldr	r0,=Condition
	add	r0,r0,r3,lsl #2
	ldr	r0,[r0,#4]		@why the first one can not print??
	bl	printf
TestBranch:
	lsl	r8,r7,#4
	lsr	r3,r8,#29
	cmp	r3,#5
	bne	TestDataProcess
	lsr	r3,r8,#28
	cmp	r3,#10
	ldreq	r0,=B
	cmp	r3,#11
	ldreq	r0,=BL
	bl	printf
	b	FINISH
TestDataProcess:
	lsr	r3,r8,#30
	cmp	r3,#0
	bne	TestLS
	ands	r3,r7,#0x02000000
	bne	WhichProcess
	ands	r3,r7,#0x00000010
	beq	WhichProcess
	ands	r3,r7,#0x00000080
	bne	Undifined
WhichProcess:
	lsl	r3,r8,#3
	lsr	r3,r3,#28
	ldr	r0,=OP
	add	r0,r0,r3,lsl #2
	ldr	r0,[r0,#4]
	bl	printf
	b	FINISH
TestLS:
	lsr	r3,r8,#30
	cmp	r3,#1
	bne	Undifined
	ands	r3,r7,#0x02000000
	beq	WhichOne
	ands	r3,r7,#0x00000010
	bne	Undifined
WhichOne:
	ands	r3,r7,#0x00500000
	ldreq	r0,=STR
	bleq	printf
	beq	FINISH
	cmp	r3,#0x00100000
	ldreq	r0,=LDR
	cmp	r3,#0x00400000
	ldreq	r0,=STRB
	cmp	r3,#0x00500000
	ldreq	r0,=LDRB
	bl	printf
	b	FINISH
Undifined:
	ldr	r0,=UND
	bl	printf
FINISH:
	add	r6,r6,#4
	add	r5,r9,r6
	cmp	r4,r5	
	bgt	LOOP
EXIT:
	ldmfd	sp!,{r4-r9,fp,lr}
	bx	lr
test:
	.ascii	"code:%x\n\0"
Title:
        .ascii  "PC\tcondition\tinstruction\n\0"
PC:
	.ascii  "%d\t\0"
B:
	.ascii	"B   \n\0"
UND:
	.ascii	"UND\n\0"
Condition:
	.word	Nothing1
        .word   EQ
        .word   NE
        .word   CS
        .word   CC
        .word   MI
        .word   PL
        .word   VS
        .word   VC
        .word   HI
        .word   LS
        .word   GE
        .word   LT
        .word   GT
        .word   LE
        .word   AL
	.word	NV
Nothing1:
	.ascii	"\0"
EQ:
        .ascii  "EQ   \t\t\0"
NE:
        .ascii  "NE   \t\t\0"
CS:
        .ascii  "CS/HS\t\t\0"
CC:
        .ascii  "CC/LO\t\t\0"
MI:
        .ascii  "MI   \t\t\0"
PL:
        .ascii  "PL   \t\t\0"
VS:
        .ascii  "VS   \t\t\0"
VC:
        .ascii  "VC   \t\t\0"
HI:
        .ascii  "HI   \t\t\0"
LS:
        .ascii  "LS   \t\t\0"
GE:
        .ascii  "GE   \t\t\0"
LT:
        .ascii  "LT   \t\t\0"
GT:
        .ascii  "GT   \t\t\0"
LE:
        .ascii  "LE   \t\t\0"
AL:
        .ascii  "AL   \t\t\0"
NV:
        .ascii  "NV   \t\t\0"
BL:
	.ascii	"BL  \n\0"
OP:
	.word	Nothing2
	.word   AND
        .word   EOR
        .word   SUB
        .word   RSB
        .word   ADD
        .word   ADC
        .word   SBC
        .word   RSC
        .word   TST
        .word   TEQ
        .word   CMP
        .word   CMN
        .word   ORR
        .word   MOV
        .word   BIC
        .word   MVN
Nothing2:
	.ascii	"\n\0"
AND:
        .ascii  "AND \n\0"
EOR:
        .ascii  "EOR \n\0"
SUB:
        .ascii  "SUB \n\0"
RSB:
        .ascii  "RSB \n\0"
ADD:
        .ascii  "ADD \n\0"
ADC:
        .ascii  "ADC \n\0"
SBC:
        .ascii  "SBC \n\0"
RSC:
        .ascii  "RSC \n\0"
TST:
        .ascii  "TST \n\0"
TEQ:
        .ascii  "TEQ \n\0"
CMP:
        .ascii  "CMP \n\0"
CMN:
        .ascii  "CMN \n\0"
ORR:
        .ascii  "ORR \n\0"
MOV:
        .ascii  "MOV \n\0"
BIC:
        .ascii  "BIC \n\0"
MVN:
        .ascii  "MVN \n\0"
LDR:
	.ascii	"LDR \n\0"
LDRB:
	.ascii	"LDRB\n\0"
STR:
	.ascii	"STR \n\0"
STRB:
	.ascii	"STRB\n\0"
.end
