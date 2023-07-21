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
inputstr: .asciz "%ld"
outputstr: .asciz "fibonacci number is: %ld\n"

.global my_main
.global fibonacci


my_main:
    pushq   %rbp
    movq    %rsp, %rbp

    movq    $0, %rsi
    call    in

    mov     $0, %rdi
    call    exit

in:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $32, %rsp
    
    movq    %rdx, -24(%rbp)
    movq    %rsi, -16(%rbp)
    
    leaq    -8(%rbp), %rsi
    leaq    inputstr(%rip), %rdi
    movq    $0, %rax
    call    scanf
    
    movq    -24(%rbp), %rdx
    movq    -16(%rbp), %rsi
    movq    -8(%rbp), %rdi
    call    fibonacci
    movq    %rax, %rdx

    cmpq    $0, -8(%rbp)
    je      in_end

    movq    -8(%rbp), %rsi
    cmpq    -16(%rbp), %rsi
    jg      new_max

    movq    -16(%rbp), %rsi
    movq    %rbp, %rsp
    popq    %rbp
    jmp     in

new_max:
    movq    %rbp, %rsp
    popq    %rbp
    jmp     in

in_end:
    movq    %rbp, %rsp
    popq    %rbp
    ret

fibonacci:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $32, %rsp

    cmpq    $0, %rdi
    jl      fibonacci_wrong_in

    cmpq    $0, %rdi
    je      fibonacci_end
    
    cmpq    $2, %rsi
    jl      fibonacci_base

    movq    %rdi, -8(%rbp)
    movq    %rsi, -16(%rbp)
    movq    %rdx, -24(%rbp)

    cmpq    %rsi, %rdi
    jle     fibonacci_calc_end

    shlq    $3, %rdi
    movq    %rdi, %rsi
    movq    -24(%rbp), %rdi
    call    realloc

    movq    %rax, -24(%rbp)
    movq    -24(%rbp), %rdx
    movq    -16(%rbp), %rsi
    movq    -8(%rbp), %rdi
    movq    -8(%rbp), %rcx
    subq    %rsi, %rcx
    decq    %rsi
    
    jmp    fibonacci_calc

fibonacci_wrong_in:
    movq    %rdx, %rax
    movq    %rbp, %rsp
    popq    %rbp
    ret

fibonacci_base:
    movq    %rdi, -8(%rbp)

    movq    $16, %rdi
    call    malloc
    movq    $0, (%rax)
    movq    $1, 8(%rax)

    movq    %rax, %rdx
    movq    $2, %rsi
    movq    -8(%rbp), %rdi

    movq    %rbp, %rsp
    popq    %rbp
    jmp     fibonacci

fibonacci_calc:
    cmpq    $0, %rcx
    jle     fibonacci_calc_end

    movq    %rsi, %rax
    shlq    $3, %rax
    movq    %rax, %rbx
    subq    $8, %rbx
    movq    (%rbx, %rdx), %rbx
    movq    (%rax, %rdx), %rax
    addq    %rbx, %rax
    movq    %rax, %rbx
    movq    %rsi, %rbx
    shlq    $3, %rbx
    addq    $8, %rbx
    movq    %rax, (%rbx, %rdx)
    incq    %rsi
    movq    %rdx, %rax

    decq    %rcx
    jmp     fibonacci_calc

fibonacci_calc_end:
    movq    -16(%rbp), %rsi
    call    out
    movq    -24(%rbp), %rax

fibonacci_end:
    movq    %rbp, %rsp
    popq    %rbp
    ret
    
out:
    pushq   %rbp
    movq    %rsp, %rbp

    decq    %rdi
    shlq    $3, %rdi
    movq    (%rdi, %rdx), %rsi
    leaq    outputstr(%rip), %rdi
    movq    $0, %rax
    call    printf

    movq    %rbp, %rsp
    popq    %rbp
    ret
