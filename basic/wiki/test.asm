section .data
section .text
    global main
main:
  mov rax,1
  mov rsi,2
  mov esi,5
  lea eax, [rax + rsi*1]
  mov eax,1
