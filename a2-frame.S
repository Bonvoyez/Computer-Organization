# *********************************************************************************
# * Program name: inout                                                           *
# * Description : Set mystr variable and inoutstr variable inside text. Store the caller's base pointer and initialize the base pointer. Set direction to mystr and print out. Then, set direction to inoutstr and print out. Set the formatstr variable for scanf then receive input from the user using scanf(Copy and pasted from the manual). Add return to inout and my_increment function. At the end of the main, clear the stack by moving base pointer to stack pointer then pop base pointer. Remove mystr and inoutstr. Add subq $8, %rsp which allocates 8 bits of memory. Let my_increment increments value received by a user. Before calling my_increment, move the stack value to rax, increment, then print out. Added the jmp end at the end of the inout since it uses rdi and stores a value.                                                          *
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
mystr: .asciz "Assignment-2: Inout"
formatstr: .asciz "%d"

.global my_main                         # make my_main accessible globally
.global my_increment                    # make my_increment accessible globally

my_main:
        # set up the stack frame
        pushq   %rbp
        movq    %rsp, %rbp

        leaq    mystr(%rip), %rdi
        call    printf

        call    inout

        # clear the stack and return
        jmp     end

inout:
        # read input and increment it using my_increment
        pushq   %rbp
        movq    %rsp, %rbp
        subq    $16, %rsp
        leaq    -8(%rbp), %rsi
        leaq    formatstr(%rip), %rdi
        movq    $0, %rax
        call    scanf
        movq    -8(%rbp), %rdi
        call    my_increment

        # output incremented number
        movq    %rax, %rsi
        leaq    formatstr(%rip), %rdi
        call    printf

        #used rdi so end

        movq    %rbp, %rsp
        popq    %rbp
        ret

        
my_increment:
        pushq   %rbp
        movq    %rsp, %rbp
    
        incq    %rdi
        movq    %rdi, %rax

        movq    %rbp, %rsp
        popq    %rbp
        ret


end:
        mov     $0, %rdi
        call    exit
