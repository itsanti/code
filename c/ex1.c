#include <stdio.h>

void one_three(void);
void two(void);

int main(void) {
    printf("��������:\n");
    one_three();
    printf("�������!");
    return 0;
}

void one_three(void) {
    printf("����\n");
    two();
    printf("���\n");
}

void two(void) {
    printf("���\n");
}