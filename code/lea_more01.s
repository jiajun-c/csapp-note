	.file	"lea_more.c"
	.text
	.p2align 4
	.globl	add
	.type	add, @function
add:
.LFB23:
	.cfi_startproc
	endbr64
	addl	%esi, %edi
	movl	8(%rsp), %eax
	addl	%edx, %edi
	addl	%ecx, %edi
	addl	%r8d, %edi
	addl	%r9d, %edi
	addl	%edi, %eax
	addl	16(%rsp), %eax
	addl	24(%rsp), %eax
	addl	32(%rsp), %eax
	addl	40(%rsp), %eax
	ret
	.cfi_endproc
.LFE23:
	.size	add, .-add
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"%d"
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB24:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movl	$66, %edx
	movl	$1, %edi
	xorl	%eax, %eax
	leaq	.LC0(%rip), %rsi
	call	__printf_chk@PLT
	xorl	%eax, %eax
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE24:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
