# *********************************************************************************
# * Program name: Hello World                                                     *
# * Description : set mystr variable. Load direction to mystr's address then print. Load program exit code, 0, then exit program Added *
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
    exit: jmp _exit
#endif

.text
mystr: .asciz "Assignment 1"

.global my_main                         # make my_main accessible globally

my_main:
    pushq   %rbp
    movq    %rsp, %rbp

    movq    $0, %rax
    leaq    mystr(%rip), %rdi
	call    printf
    jmp     end

end:
    mov     $0, %rdi
    call    exit
