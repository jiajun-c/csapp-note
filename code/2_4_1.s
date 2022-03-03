	.file	"2_4.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"%.2x"
	.text
	.globl	show_byte
	.type	show_byte, @function
show_byte:
.LFB34:
	.cfi_startproc
	endbr64
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	testq	%rsi, %rsi
	je	.L2
	movq	%rdi, %rbx
	leaq	(%rdi,%rsi), %rbp
	leaq	.LC0(%rip), %r12
.L3:
	movzbl	(%rbx), %edx
	movq	%r12, %rsi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk@PLT
	addq	$1, %rbx
	cmpq	%rbp, %rbx
	jne	.L3
.L2:
	movl	$10, %edi
	call	putchar@PLT
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE34:
	.size	show_byte, .-show_byte
	.globl	show_int
	.type	show_int, @function
show_int:
.LFB35:
	.cfi_startproc
	endbr64
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movl	%edi, 12(%rsp)
	leaq	12(%rsp), %rdi
	movl	$4, %esi
	call	show_byte
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE35:
	.size	show_int, .-show_int
	.globl	show_float
	.type	show_float, @function
show_float:
.LFB36:
	.cfi_startproc
	endbr64
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movss	%xmm0, 12(%rsp)
	leaq	12(%rsp), %rdi
	movl	$4, %esi
	call	show_byte
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE36:
	.size	show_float, .-show_float
	.globl	show_pointer
	.type	show_pointer, @function
show_pointer:
.LFB37:
	.cfi_startproc
	endbr64
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rdi, 8(%rsp)
	leaq	8(%rsp), %rdi
	movl	$8, %esi
	call	show_byte
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE37:
	.size	show_pointer, .-show_pointer
	.globl	show_long
	.type	show_long, @function
show_long:
.LFB38:
	.cfi_startproc
	endbr64
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rdi, 8(%rsp)
	leaq	8(%rsp), %rdi
	movl	$8, %esi
	call	show_byte
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE38:
	.size	show_long, .-show_long
	.section	.rodata.str1.1
.LC1:
	.string	"mnopqr"
	.text
	.globl	main
	.type	main, @function
main:
.LFB39:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$24, %rsp
	.cfi_def_cfa_offset 48
	movl	$40, %ebp
	movq	%fs:0(%rbp), %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	movl	$305419896, 4(%rsp)
	leaq	4(%rsp), %rbx
	movl	$1, %esi
	movq	%rbx, %rdi
	call	show_byte
	movl	$2, %esi
	movq	%rbx, %rdi
	call	show_byte
	movl	$3, %esi
	movq	%rbx, %rdi
	call	show_byte
	movl	$6, %esi
	leaq	.LC1(%rip), %rdi
	call	show_byte
	movq	8(%rsp), %rax
	xorq	%fs:0(%rbp), %rax
	jne	.L17
	movl	$0, %eax
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L17:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE39:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
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
