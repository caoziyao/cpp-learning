//
//  main.cpp
//  vector1
//
//  Created by working on 2018/8/16.
//  Copyright © 2018年 working. All rights reserved.
//  使用 vector 代替数组

#include <iostream>
#include <vector>

using namespace std;

// 数组用法
void test_array() {
    int a[10];
    int b[10] = {0};
    int c[] = {1, 2, 3, 4, 5};
    int x = c[2];
    c[3] = x;
}

// vector 基本用法
void test_vector() {
    vector<int> a(10);      // int a[10]
    vector<int> b(10, 0);   // int b[10] = {0};
    vector<int> c = {1, 2, 3, 4, 5};  // int b[10] = {0};
    int x = c[2];           // int b[10] = {0};
    c[3] = x;               // int b[10] = {0};
}

// 传统的做法
void test_array1() {
    int a[] = {1, 2, 3, 4, 5};
    int sum = 0;
    for (int i = 0; i < sizeof(a) / sizeof(*a); i++) {
        sum += a[i];
    }
    cout << "a:" << sum << "\n";
}

// vector 的用法
void test_vector1() {
    vector<int> a = {1, 2, 3, 4, 5};
    int sum = 0;
    for (auto x : a) {
        sum += x;
    }
    cout << "a:" << sum << "\n";
}

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    
    test_vector1();

    return 0;
}
