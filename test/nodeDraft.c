#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

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

/* トークン切り */
void myToken(char *inP, char *outP)
{
    char *aIn = inP;
    char *aOut = outP;
    while(1)
    {   /* 区切り文字ではなくなるまで読み飛ばし */
        if(ispunct(*aIn) == 0)
        {
            aIn++;
        }
        else
        {
            break;
        }
    }
    
    outP = aOut;

    while(1)
    {   /* 区切り文字が来るまで格納 */
        if(ispunct(*aIn) != 0)
        {
            *outP = *inP;
            aOut++;
            aIn++;
        }
        else
        {
            *outP = 0x00;
            break;
        }
    }
}

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
    char aCommand[256];
    char aName[8];
    unsigned short aData;

    int i;
    char _tmpc;

    while(1)
    {
        i = 0;
        while(1)
        {
            scanf("%c", &_tmpc);
            if(_tmpc != '\n')
            {
                aCommand[i] = _tmpc;
                i++;
            }
            else
            {
                aCommand[i] = 0x00;
                break;
            }
        }

        printf("%s\n", aCommand);
    }

    return 0;
}