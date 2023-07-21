# *********************************************************************************
# * Program name: my_printf                                                       *
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
    putchar: jmp _putchar
    exit: jmp _exit
#endif

.text


.global my_main
.global my_printf


my_main:
    pushq   %rbp
    movq    %rsp, %rbp
    
    call    my_printf

    jmp     end

my_printf:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $48, %rsp
    
    movq    %rdi, -48(%rbp)
    movq    %rsi, -40(%rbp)
    movq    %rdx, -32(%rbp)
    movq    %rcx, -24(%rbp)
    movq    %r8,  -16(%rbp)
    movq    %r9,  -8(%rbp)

    cmpq     $1, -48(%rbp)
    je       end_my_printf

    movq    $0, %rbx
    movq    $-48, %r15
    
loop:
    movq    -48(%rbp), %rdi
    cmpb    $37, (%rbx, %rdi)
    je      loop2
    
    cmpb    $0, (%rbx, %rdi)
    je      end_my_printf

    movq    (%rbx, %rdi), %rdi
    call    putchar
    incq    %rbx
    jmp     loop

loop2:
    incq    %rbx
    cmpb    $100, (%rbx, %rdi)
    je      int_or_string
    
    cmpb    $117, (%rbx, %rdi)
    je      int_or_string

    cmpb    $115, (%rbx, %rdi)
    je      int_or_string

    cmpb    $37, (%rbx, %rdi)
    je      percentage_print
    
    jmp     percentage_print

int_or_string:
    addq    $8, %r15
    cmpq    $0, %r15
    je      special_index
    
    cmpb    $100, (%rbx, %rdi)
    je      integer
    
    cmpb    $117, (%rbx, %rdi)
    je      integer

    cmpb    $115, (%rbx, %rdi)
    je      string
    
special_index:
    addq    $8, %r15
    jmp     int_or_string
    
string:
    incq    %rbx
    movq    (%r15, %rbp), %r11
    movq    $0, %r12
    jmp     string_print

string_print:
    movq    (%r12, %r11), %rdi
    call    putchar

    incq    %r12
    cmpb    $0, (%r12, %r11)
    je      loop

    jmp     string_print
    
integer:
    cmpq    $0, (%r15, %rbp)
    jl      negative_integer

    incq    %rbx
    movq    (%r15, %rbp), %r12
    movq    $1, %r13
    movq    $10, %r14
    cmpq    $0, %r12
    jne     integer_loop

    addq    $48, %r12
    movq    %r12, %rdi
    call    putchar
    jmp     loop

negative_integer:
    movq    $45, %rdi
    call    putchar

    movq    $-1, %r12
    movq    (%r15, %rbp), %rax
    mulq    %r12
    movq    %rax, (%r15, %rbp)
    jmp     integer
    
integer_loop:
    movq    (%r15, %rbp), %rax
    movq    $0, %rdx
    divq    %r13
    movq    %rax, %r12
    cmpq    $10, %r12
    jl      integer_print

    movq    %r13, %rax
    mulq    %r14
    movq    %rax, %r13
    jmp     integer_loop
    
integer_print:
    cmpq    $0, %r13
    je      loop

    movq    (%r15, %rbp), %rax
    movq    $0, %rdx
    divq    %r13
    addq    $48, %rax

    movq    %rax, %rdi
    call    putchar

    subq    $48, %rax
    mulq    %r13
    subq    %rax, (%r15, %rbp)
    movq    %r13, %rax
    movq    $0, %rdx
    divq    %r14
    movq    %rax, %r13
    jmp     integer_print
    
percentage_print:
    incq    %rbx
    movq    $37, %rdi
    call    putchar
    jmp     loop

end_my_printf:
    movq    %rbp, %rsp
    popq    %rbp
    ret
    
end:
    mov     $0, %rdi
    call    exit
