# *********************************************************************************
# * Program name: diff                                                            *
# * Description : Line-by-line diff                                               *
# *********************************************************************************

#ifdef MACOS
    .global _diff
    _diff: jmp diff
    fgets: jmp _fgets
    fread: jmp _fread
    fprintf: jmp _fprintf
    fscanf: jmp _fscanf
    printf: jmp _printf
    strcasecmp: jmp _strcasecmp
    strcmp: jmp _strcmp
    strcpy: jmp _strcpy
    strlen: jmp _strlen
    strncasecmp: jmp _strncasecmp
    strncmp: jmp _strncmp 
    strncpy: jmp _strncpy
    strnlen: jmp _strnlen
    exit: jmp _exit
#endif


.text

changestring:
            .ascii "%dc%d\n"
		    .ascii "< %s\n"
		    .ascii "---\n"
		    .asciz "> %s\n"

.global diff

# ************************************************************************
# * Subroutine: diff
# * Description: A simplified line-by-line implementation of diff
# * Specification: int diff(FILE *a, FILE *b, bool i_flag, bool B_flag);         
# ************************************************************************
diff:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $544, %rsp

    movq    %rdi, -8(%rbp)
    movq    %rsi, -16(%rbp)
    movq    %rdx, -24(%rbp)
    movq    %rcx, -32(%rbp)
    movq    $0, %rbx

    jmp     diff_loop

diff_loop:
    incq    %rbx
    movq    $0, -288(%rbp)
    movq    $0, -544(%rbp)
    leaq    -288(%rbp), %r12
    leaq    -544(%rbp), %r13
    movq    $0, %r14
    movq    $0, %r15

diff_loop1:
    movq    -8(%rbp), %rdx
    movq    $2, %rsi
    leaq    (%r14, %r12), %rdi
    call    fgets
    
    leaq    (%r14, %r12), %rcx
    incq    %r14

    cmpb    $10, (%rcx)
    jne     diff_loop1

    movb    $0, (%rcx)

diff_loop2:
    movq    -16(%rbp), %rdx
    movq    $2, %rsi
    leaq    (%r15, %r13), %rdi
    call    fgets

    leaq    (%r15, %r13), %rcx
    incq    %r15

    cmpb    $10, (%rcx)
    jne     diff_loop2

    movb    $0, (%rcx)

diff_loop3:
    leaq    -288(%rbp), %rdi
    call    strlen
    movq    %rax, %r12

    leaq    -544(%rbp), %rdi
    call    strlen
    movq    %rax, %r13

    cmpq    $1, %r12
    jg      diff_blank_check
    
    cmpq    $1, %r13
    jg      diff_blank_check

    jmp     diff_end

diff_blank_check:
    cmpq    $1, %r12
    jle      diff_blank_flag_check

    cmpq    $1, %r13
    jg      diff_blank_flag_check

    jmp     diff_cmp

diff_blank_flag_check:
    cmpq    $0, -32(%rbp)
    jne     diff_loop

    jmp     diff_cmp

diff_cmp:
    leaq    -544(%rbp), %rsi
    leaq    -288(%rbp), %rdi
    cmpq    $0, -24(%rbp)
    jne     diff_casecmp

    call    strcmp
    cmpq    $0, %rax
    je      diff_loop

    jmp     diff_print

diff_casecmp:
    call    strcasecmp
    cmpq    $0, %rax
    je      diff_loop

    jmp     diff_print

diff_print:
    movq    %rbx, %rsi
    movq    %rbx, %rdx
    leaq    -288(%rbp), %rcx
    leaq    -544(%rbp), %r8
    leaq    changestring(%rip), %rdi
    call    printf

    jmp     diff_loop

diff_end:
    mov     $0, %rdi
    call    exit
