#include <stdio.h>
#include <stdlib.h>

/* 変数の連結リスト */
typedef struct node
{
    char name[8];
    unsigned short data;
    unsigned char type;
    unsigned char size;
    struct node* next;
} Node;

void newNode(Node **head, char *name, unsigned short data);
void freeNode(Node *head, char *name);
void setNode(Node **head, char *name, unsigned short data);
void getNode(Node *head, char *name);
void listNode(Node *head);

static Node *sNode = NULL;

/* 変数の新規作成 */
void newNode(Node **head, char *name, unsigned short data)
{

}

/* 変数の解放 */
void freeNode(Node *head, char *name)
{

}

/* 変数の更新 */
void setNode(Node **head, char *name, unsigned short data)
{

}

/* 指定の変数表示 */
void getNode(Node *head, char *name)
{

}

/* 変数の一覧表示 */
void listNode(Node *head)
{

}

/* エントリポイント */
int main(void)
{
    char aCommand;
    char aName[8];
    unsigned short aData;

    while(1)
    {
        scanf(" %c", &aCommand);

        if(aCommand == 'n')
        {   /* new */
            puts("new, name?");
            scanf("%s", aName);

        }
        else if(aCommand == 'f')
        {   /* free */
            puts("free, name?");
            scanf("%s", aName);

        }
        else if(aCommand == 's')
        {   /* set */
            puts("set, name? data?");
            scanf("%s", aName);
            scanf("%d", &aData);

            printf("%s %d\n", aName, aData);

        }
        else if(aCommand == 'g')
        {   /* get */
            puts("get, name?");
            scanf("%s", aName);

        }
        else if(aCommand == 'l')
        {   /* list */
            puts("list");

        }
        else
        {   /* end */
            puts("end");
            break;
        }
    }

    return 0;
}