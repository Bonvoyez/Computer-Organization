# *********************************************************************************
# * Program name: factorial                                                       *
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
    exit: jmp _exit
#endif

.text
formatstr: .asciz "%ld"

.global my_main
.global factorial


my_main:
    pushq   %rbp
    movq    %rsp, %rbp
     
    call    inout
     
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
    call    factorial

    movq    %rax, %rsi
    leaq    formatstr(%rip), %rdi
    movq    $0, %rax
    call    printf
     
    movq    %rbp, %rsp
    popq    %rbp
    ret

factorial:
    pushq   %rbp
    movq    %rsp, %rbp

    cmpq    $0, %rdi
    je     factorial_base
    decq    %rdi

    movq    %rbp, %rsp
    popq    %rbp
    call    factorial

    incq    %rdi
    mulq    %rdi
    ret

factorial_base:
    movq    $1, %rax
    movq    %rbp, %rsp
    popq    %rbp
    ret
    
end:
    mov $0, %rdi
    call exit
