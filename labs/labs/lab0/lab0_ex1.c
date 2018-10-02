//
//  lab0_ex1.c
//  labs
//
//  Created by working on 2018/9/30.
//  Copyright © 2018年 working. All rights reserved.
//  gcc -S -m32 lab0_ex1.c


int count = 1;
int value = 1;
int buf[10];

int main() {
    asm(
        "cld \n\t"
        "rep \n\t"
        "stosl"
    );
    
}

