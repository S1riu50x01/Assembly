section .data
  start: equ 1000
  stop:  equ 0
  step:  equ -1
  enter: db 0xa
  lenter: equ $-enter

section .bss
  lista: resb 10
  buffer: resb 10

section .text
  global _start

_start:
  mov rax, start
  mov rbx, stop
  range:
    cmp rax, rbx
    je end
    push rbx
    push rax

    lea rsi, [buffer]
    call int_to_string

    mov [lista], rax
    mov ecx, [lista]
    mov edx, 10
    call print

    mov ecx, enter
    mov edx, lenter
    call print

    pop rax
    add rax, step

    pop rbx
    jmp range
  end:
    jmp final

print:
  mov rax, 4
  mov rbx, 1
  int 0x80
  ret

final:
  mov rax, 1
  mov rbx, 0
  int 0x80

int_to_string:
  add rsi, 9
  mov byte[rsi], 0
  mov rbx, 10
.prox_digito:
  xor rdx, rdx
  div rbx
  add dl, '0'
  dec rsi
  mov [rsi], dl
  test rax, rax
  jnz .prox_digito ; rax = 0
  mov rax, rsi
  ret
