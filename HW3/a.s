	.file	"a.c"
	.text
	.def	__main;	.scl	2;	.type	32;	.endef
	.section .rdata,"dr"
.LC0:
	.ascii "%ld,%s\0"
	.text
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
	pushq	%rbp
	.seh_pushreg	%rbp
	movq	%rsp, %rbp
	.seh_setframe	%rbp, 0
	subq	$64, %rsp
	.seh_stackalloc	64
	.seh_endprologue
	call	__main
	movl	$960049440, -10(%rbp)
	movw	$53, -6(%rbp)
	leaq	-24(%rbp), %rdx
	leaq	-10(%rbp), %rax
	movl	$10, %r8d
	movq	%rax, %rcx
	call	strtol
	movl	%eax, -4(%rbp)
	movq	-24(%rbp), %rdx
	movl	-4(%rbp), %eax
	movq	%rdx, %r8
	movl	%eax, %edx
	leaq	.LC0(%rip), %rcx
	call	printf
	movl	$0, %eax
	addq	$64, %rsp
	popq	%rbp
	ret
	.seh_endproc
	.ident	"GCC: (x86_64-posix-seh-rev0, Built by MinGW-W64 project) 8.1.0"
	.def	strtol;	.scl	2;	.type	32;	.endef
	.def	printf;	.scl	2;	.type	32;	.endef
