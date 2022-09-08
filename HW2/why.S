	.align	2
	.global	main
	.type	main, %function
main:
        push    {r4-r9, lr}
        bl      start_deasm
        .include "test.s"
start_deasm:
        mov     r4, lr
        # 總共為 r6 行
        sub     r6, pc, #12
        subs    r6, r6, r4
        ble     EXIT
        # r5 為 i
        mov     r5, #0
        ldr     r0, WORD
        bl      printf
LOOP:
        # r7 為 此行的地址
        add     r7, r4, r5
        # r8 = *r7
	ldr	r0,=test
        ldr     r8, [r7]
	mov	r1,r8
	bl	printf
	
        # printf pc
        mov     r1, r5
        ldr     r0, WORD+4
        bl      printf
        # printf cond
        lsr     r3, r8, #28
        ldr     r0, WORD+28
        add     r0, r0, r3, lsl #2
        ldr     r0, [r0]
        bl      printf
        # 若此行不為 data processing
        lsr     r3, r8, #26
        ands    r3, r3, #3
        ldrne   r0, WORD+40
        blne    printf
        cmp     r3, #0
        bne     L0
        # printf instruction
        lsr     r9, r8, #21
        and     r9, r9, #0xF
        ldr     r0, WORD+32
        add     r0, r0, r9, lsl #2
        ldr     r0, [r0]
        bl      printf
        # printf dstreg
        lsr     r3, r9, #2
        cmp     r3, #2
        lsrne   r1, r8, #12
        andne   r1, r1, #0xF
        ldrne   r0, WORD+8
        ldreq   r0, WORD+12
        bl      printf
        # printf 1st-op
        cmp     r9, #12
        movle   r3, #0
        andgt   r3, r9, #1
        cmp     r3, #0
        lsreq   r1, r8, #16
        andeq   r1, r1, #0xF
        ldreq   r0, WORD+8
        ldrne   r0, WORD+12
        bl      printf
        # printf 2nd-op
        tst     r8, #0x2000000
        beq     L1
        and     r1, r8, #0xFF
        and     r3, r8, #0xF00
        ror     r1, r1, r3, lsr #8
        ldr     r0, WORD+16
        bl      printf
        b       L0
L1:
        #25==0
        and     r1, r8, #0xF
        ldr     r0, WORD+20
        bl      printf
        lsr     r3, r8, #5
        and     r3, r3, #3
        tst     r8, #0x10
        bne     L2
        #4==0
        lsr     r9, r8, #7
        cmp     r3, #3
        beq     L3
        ands    r9, r9, #0x1F
        beq     L0
        ldr     r0, WORD+36
        add     r0, r0, r3, lsl #2
        ldr     r0, [r0]
        bl      printf
        mov     r1, r9
        ldr     r0, WORD+16
        bl      printf
        b       L0
L3:
        #RRX ROR
        ldr     r0, WORD+36
        add     r0, r0, r3, lsl #2
        ldr     r0, [r0]
        ands    r9, r9, #0x1F
        addne   r0, r0, #4
        ldr     r0, [r0]
        bl      printf
        cmp     r9, #0
        movne   r1, r9
        ldrne   r0, WORD+16
        blne    printf
        b       L0
L2:
        #4==1
        ldr     r0, WORD+36
        add     r0, r0, r3, lsl #2
        ldr     r0, [r0]
        cmp     r3, #3
        addeq   r0, r0, #4
        ldreq   r0, [r0]
        bl      printf
        lsr     r1, r8, #8
        and     r1, r1, #0xF
        ldr     r0, WORD+8
        bl      printf
L0:
        # printf '\n'
        add     r5, r5, #4
        cmp     r5, r6
        ldrlt   r0, WORD+24
        bllt    printf
        cmp     r5, r6
        blt     LOOP
EXIT:
        pop     {r4-r9, pc}
test:
	.ascii	"test:%x\0"
WORD:
        .word   STRING0
        .word   STRING1
        .word   STRING2
        .word   STRING3
        .word   STRING4
        .word   STRING5
        .word   STRING6
        .word   COND
        .word   INSTR
        .word   SH
        .word   NOTDATA
STRING0:
        .asciz  "PC\tcondition\tinstruction\tdstreg\t\t1st-op\t\t2nd-op\000"
STRING1:
        .asciz  "%d\t\000"
STRING2:
        .asciz  "r%d\t\t\000"
STRING3:
        .asciz  "NA\t\t\000"
STRING4:
        .asciz  "#%d\000"
STRING5:
        .asciz  "r%d\000"
STRING6:
        .asciz  "\n\000"
COND:
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
        .word   NV
EQ:
        .asciz  "EQ\t\t\000"
NE:
        .asciz  "NE\t\t\000"
CS:
        .asciz  "CS/HS\t\t\000"
CC:
        .asciz  "CC/LO\t\t\000"
MI:
        .asciz  "MI\t\t\000"
PL:
        .asciz  "PL\t\t\000"
VS:
        .asciz  "VS\t\t\000"
VC:
        .asciz  "VC\t\t\000"
HI:
        .asciz  "HI\t\t\000"
LS:
        .asciz  "LS\t\t\000"
GE:
        .asciz  "GE\t\t\000"
LT:
        .asciz  "LT\t\t\000"
GT:
        .asciz  "GT\t\t\000"
LE:
        .asciz  "LE\t\t\000"
AL:
        .asciz  "AL\t\t\000"
NV:
        .asciz  "NV\t\t\000"
INSTR:
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
AND:
        .asciz  "AND\t\t\000"
EOR:
        .asciz  "EOR\t\t\000"
SUB:
        .asciz  "SUB\t\t\000"
RSB:
        .asciz  "RSB\t\t\000"
ADD:
        .asciz  "ADD\t\t\000"
ADC:
        .asciz  "ADC\t\t\000"
SBC:
        .asciz  "SBC\t\t\000"
RSC:
        .asciz  "RSC\t\t\000"
TST:
        .asciz  "TST\t\t\000"
TEQ:
        .asciz  "TEQ\t\t\000"
CMP:
        .asciz  "CMP\t\t\000"
CMN:
        .asciz  "CMN\t\t\000"
ORR:
        .asciz  "ORR\t\t\000"
MOV:
        .asciz  "MOV\t\t\000"
BIC:
        .asciz  "BIC\t\t\000"
MVN:
        .asciz  "MVN\t\t\000"
SH:
        .word   LSL
        .word   LSR
        .word   ASR
        .word   R
LSL:
        .asciz  ", LSL \000"
LSR:
        .asciz  ", LSR \000"
ASR:
        .asciz  ", ASR \000"
R:
        .word   RRX
        .word   ROR
RRX:
        .asciz  ", RRX\000"
ROR:
        .asciz  ", ROR \000"
NOTDATA:
        .asciz  "xxx\000"
