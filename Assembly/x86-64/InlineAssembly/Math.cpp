#include <iostream>

#define ASM_FUNC __attribute__((naked))


ASM_FUNC int add(int a, int b)
{
    // rdi = a;
    // rsi = b;

    __asm__ volatile
    ("\
        .intel_syntax noprefix;\
        push rbx;\
        sub rsp, 16;\
        mov qword [rsp], [rsi];\
        mov qword [rsp+8], [rdi];\
        mov eax, qword [rsp];\
        add eax, qword [rsp + 8];\
        add rsp, 16;\
        pop rbx;\
        ret;\
    ");
}

ASM_FUNC int func()
{
    __asm__ volatile
    ("\
        .intel_syntax noprefix;\
        mov eax, 1;\
        ret;\
    ");
}

int main()
{
    std::cout << func() << '\n';
    std::cout << add(9, 10) << std::endl;

    return 0;
}