/* mallocのテスト c89 */

#include <stdio.h>

#define MEMSIZE     (256)
#define ALIGN       (16)
#define TBLSIZE     (MEMSIZE / ALIGN)

static unsigned char sMem[MEMSIZE];     /* アロケーションメモリ */
static unsigned char sTbl[TBLSIZE];     /* アロケーションテーブル */
static int sFre;                        /* 使用可能メモリ */

void init(void)
{
    int i;
    for(i = 0 ; i < MEMSIZE; i++) sMem[i] = 0x00;
    for(i = 0 ; i < TBLSIZE; i++) sTbl[i] = 0x00;
    sFre = MEMSIZE;
}

void putStatus(void)
{
    int i;
    for(i = 0; i < TBLSIZE; i++) printf("%d ", sTbl[i]);
    putchar('\n');
}

unsigned short myMalloc(unsigned short CX)
{
    unsigned short AX, DX, BP;
    unsigned char BH, BL;

    AX = 0x0000;
    BH = 0x00;
    BL = 0x00;
    DX = 0x0000;

    if(CX == 0)
    {
        return 0;
    }

    while(1)
    {
        BL = sTbl[DX];
        if(BL == 0x00)
        {
            BH++;
            if((BH * 16) >= CX)
            {
                BP = AX;
                for(CX = 0; CX < BH; CX++)
                {
                    sTbl[AX + CX] = BH - CX;
                }
                return BP;
            }
            else
            {
                DX++;
            }
        }
        else
        {
            DX++;
            AX = DX;
            BH = 0x00;
        }
    }

    return BP;
}

void myFree(unsigned short BP)
{
    unsigned char AH = 0x00;
    unsigned char AL = 0x00;

    BP = BP >> 4;
    AH = sTbl[BP];
    for(AL = 0; AL < AH; AL++)
    {
        sTbl[BP + AL] = 0x00;
    }
}

int main(void)
{
    unsigned short CX=0, BP=0;
    init();                             /* rInitMalloc 相当 */

    while(1)
    {   /* 状態確認、入力、確保 */
        putStatus();
        scanf("%d", &CX);
        printf("%02x\n", myMalloc(CX));
        scanf("%d", &BP);
        myFree(BP);
    }

    return 0;
}