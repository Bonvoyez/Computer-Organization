# *********************************************************************************
# * Program name: fibonacci                                                       *
# * Description :                                                                 *
# *********************************************************************************

#ifndef MACOS
.ifndef CODEGRADE
    .global main
    main: jmp my_main
.endif
#else
    .global _main
    _main: jmp my_main
    printf: jmp _printf
    scanf: jmp _scanf
    malloc: jmp _malloc
    calloc: jmp _calloc
    realloc: jmp _realloc
    free: jmp _free
    exit: jmp _exit
#endif

.text
formatstr: .asciz "%ld"

.global my_main
.global fibonacci


my_main:
    pushq   %rbp
    movq    %rsp, %rbp

    call inout

    movq    %rbp, %rsp
    popq    %rbp
    jmp     end

inout:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $16, %rsp

    leaq    -8(%rbp), %rsi
    leaq    formatstr(%rip), %rdi
    movq    $0, %rax
    call    scanf

    movq    -8(%rbp), %rdi
    call    fibonacci

    movq    %rax, %rsi
    leaq    formatstr(%rip), %rdi
    call    printf

    movq    %rbp, %rsp
    popq    %rbp
    ret

fibonacci:
    pushq   %rbp
    movq    %rsp, %rbp

    cmpq    $1, %rdi
    jle     fibonacci_base

    decq    %rdi
    call    fibonacci

    movq    %rax, %rdx
    addq    %rsi, %rax
    movq    %rdx, %rsi

    jmp     fibonacci_end

fibonacci_base:
    movq    $0, %rax
    movq    $1, %rsi
    
fibonacci_end:
    movq    %rbp, %rsp
    popq    %rbp
    ret

end:
    mov     $0, %rdi
    call exit
