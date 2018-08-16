//
//  main.cpp
//  string1
//
//  Created by working on 2018/8/16.
//  Copyright © 2018年 working. All rights reserved.
//  string 代替 char*

#include <iostream>
#include <string>

using namespace std;

// 传统做法
void test_char() {
    char s[] = "abcdefg";
    char b[4];
    
    strncpy(b, s + 2, 3);
    b[3] = '\0';
    std::cout << b << "\n";
}

// string 做法
void test_string() {
    string s = "abcdefg";
    string d(begin(s) + 2, begin(s) + 5);
    std::cout << d << "\n";
}

// 替换子字符串
// 传统做法
// strcpy并不能处理所有缓冲区重叠的情况，所以只能使用memmove。 对于变长或者变短，复制的顺序也要注意。
void test_char2() {
    char a[10] = "abcdefg";
    memmove(a + 6, a + 5, strlen(a + 5) + 1);
    strncpy(a + 2, "XYZW", 4);
    
    std::cout << a << "\n";
    
    char b[10] = "abcdefg";
    strncpy(b + 2, "UV", 2);
    memmove(b + 4, b + 5, strlen(b + 5) + 1);
    
    std::cout << b << "\n";
}

// 替换子字符串
// string 做法
void test_string2() {
    string a = "abcdefg";
    a.replace(begin(a) + 2, begin(a) + 5, "XYZW");
    
    std::cout << a << "\n";
    
    string b = "abcdefg";
    b.replace(begin(b) + 2, begin(b) + 5, "UV");
    
    std::cout << b << "\n";
}

// 查找子字符串
// 传统做法
void test_char3() {
    // strstr()函数：返回字符串中首次出现子串的地址
    char s[] = "abcdefg";
    char *x = strstr(s, "cde");     // x == s + 2
    char *y = strstr(s, "CDE");     // y = nullptr
}

// 查找子字符串
void test_string3() {
    string s = "abcdefg";
    auto x = s.find("cde"); // x == 2
    auto y = s.find("CDE"); // y == string::npos
}



int main(int argc, const char * argv[]) {
    // insert code here...
    test_string2();
    return 0;
}
