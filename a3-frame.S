# *********************************************************************************
# * Program name: pow                                                             *
# * Description : Set the stack fram and clear the frame for each subroutines                                                                *
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
scanfstr: .asciz "%ld %ld"
printstr: .asciz "%ld"

.global my_main
.global my_pow


my_main:
    pushq   %rbp
    movq    %rsp, %rbp
    
    call    inout

    jmp     end
    
inout:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $16, %rsp
    
    leaq    -8(%rbp), %rdx
    leaq    -16(%rbp), %rsi
    leaq    scanfstr(%rip), %rdi
    movq    $0, %rax
    call    scanf

    movq    -16(%rbp), %rdi
    movq    -8(%rbp), %rsi
    call    my_pow

    movq    %rax, %rsi
    leaq    printstr(%rip), %rdi
    movq    $0, %rax
    call    printf
    
    movq    %rbp, %rsp
    popq    %rbp
    ret

my_pow:
    pushq   %rbp
    movq    %rsp, %rbp
    
    movq    $1, %rax

pow_loop:
    cmpq    $0, %rsi
    jle     end_pow
    
    mul     %rdi
    decq    %rsi
    jmp     pow_loop
    
end_pow:
    movq    %rbp, %rsp
    popq    %rbp
    ret

end:
    mov     $0, %rdi
    call    exit
