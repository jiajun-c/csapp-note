	.file	"hello.c"
	.intel_syntax noprefix
	.text
	.globl	add
	.type	add, @function
add:
.LFB23:
	.cfi_startproc
	endbr64
	ret
	.cfi_endproc
.LFE23:
	.size	add, .-add
	.globl	main
	.type	main, @function
main:
.LFB24:
	.cfi_startproc
	endbr64
	mov	eax, 0
	ret
	.cfi_endproc
.LFE24:
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
