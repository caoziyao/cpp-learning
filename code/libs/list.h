#ifndef _list_h_
#define _list_h_

// 双向链表结构如下
struct list_elem
{
    struct list_elem *prev;
    struct list_elem *next;
};

struct list
{
    struct list_elem head;
    struct list_elem tail;
};

struct list_entry {
    struct list_entry *prev, *next;
};

typedef struct list_entry list_entry_t;

#endif // _list_h_
