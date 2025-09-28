/*
 * 1.44MBの .img を作成する
 */

/* ディレクティブ */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* マクロ定義 */
#define PATHLEN     13                  /* ファイル名+'.'+拡張子+'\0'(8+1+4+1 = 13) */
#define COMPMAX     256                 /* 書き込めるbinファイルの上限数 */
#define SECNUM      2880                /* フロッピーのセクタ数 */
#define SECSIZE     512                 /* 1セクタのサイズ */
#define DISKSIZE    SECSIZE*SECNUM      /* フロッピーのデータサイズ */

/*
#define _DEBUG
*/

/* 入力データ構造体 */
struct component
{
    char fileName[13];  /* ファイル名 */
    int secLen;         /* データセクタ数 */
};

/* プロトタイプ */
int get_1line(FILE *inFp, struct component *inData);
int read_conf(struct component *ioData, int *outCnt);
void img_init(unsigned char *in);
int deploy_file(struct component inConfig, int inSec, unsigned char *inImg);


/* 関数ツリー
 * main
 *  ├read_conf
 *  │ └get_1line
 *  ├img_init
 *  ├deploy_file
 *  └out_file
 */

/*
 * 1行のデータ取得(ファイル名とセクタ長)
 * in : *inFp   ファイルポインタ
 * out: *inData 取得データ
 * ret: 0       成功
 *      -1      失敗
 */
int get_1line(FILE *inFp, struct component *inData)
{
    char aBuf[20];
    int aChk;
    int i;
    int aRet;

    /* 1行取得 */
    if (fgets(aBuf, sizeof(aBuf), inFp) != NULL)
    {   /* 1行取得成功 */
        if (sscanf(aBuf, "%[^,], %d", inData->fileName, &inData->secLen) == 2)
        {   /* トークン取得成功 */
#ifdef _DEBUG
            printf("%s, %d\n", inData->fileName, inData->secLen);
#endif
            aRet = 0;
        }
        else
        {   /* トークン取得失敗 */
            aRet = -1;
        }
    }
    else
    {
        aRet = -1;
    }

    return aRet;
}

/*
 * 入力ファイルの読み込み
 * "config.csv"の各行からファイル名とセクタ数を指定する
 * ディスクの頭から順番に書き込む
 * i/o: ioData  読み込んだファイルデータ
 * ret: 0       正常終了
 *      -1      ファイル読み込み異常
 *      -2      ファイル内容異常
 */
int read_conf(struct component *ioData, int *outCnt)
{
    int aRet = 0;
    int aCnt = 0;       /* 取り込む予定のファイル合計 */
    FILE *aFp;
    struct component aOne;

    printf("input ...");
    aFp = fopen("config.csv", "r");
    /* ファイル存在？ */
    if(aFp != NULL)
    {   /* オープン成功 */
        while(aCnt <= COMPMAX)
        {   /* 最大 COMP_MAX 個までのテーブルを許可 */
            if(get_1line(aFp, &aOne) == 0)
            {   /* 取得した1つ分のデータを取得 */
                memcpy(&ioData[aCnt], &aOne, sizeof(aOne));
            }
            else
            {   /* 取得失敗(末尾まで読んだ) */
                printf("done.\n");
                break;
            }

            aCnt++;
        }

        if(aCnt == COMPMAX)
        {   /* 取り込むファイルが多すぎる */
            printf("error!\n");
            aRet = -2;
        }
    }
    else
    {   /* オープン失敗 */
#ifdef _DEBUG
        printf("open error\n");
#endif
        printf("error!\n");
        aRet = -1;
    }

    fclose(aFp);
    *outCnt = aCnt;

    return aRet;
}

/*
 * imgデータ初期化
 * in : in      imgデータ(フロッピー1枚分)
 * ret: (void)
 */
void img_init(unsigned char *in)
{
    int i;
    for(i = 0; i < DISKSIZE; i++)
    {   /* 全クリ */
        in[i] = 0x00;
    }
}

/*
 * ファイル展開
 * in : inConfig    ファイル名、書き込みセクタ数
 *      inSec       書き込み開始セクタ
 * i/o: inImg       ディスクイメージ
 * ret: 0           成功
 *      -1          失敗
 */
int deploy_file(struct component inConfig, int inSec, unsigned char *inImg)
{
    FILE *aFp;
    int aRet = 0;
#ifdef _DEBUG
    int _i;
#endif

    aFp = fopen(inConfig.fileName, "rb");
    if(aFp != NULL)
    {   /* ポインタ取得成功 */
        fread(&inImg[inSec * SECSIZE], 1, inConfig.secLen * SECSIZE, aFp);
    }
    else
    {   /* 取得失敗 */
        aRet = -1;
    }
    fclose(aFp);

#ifdef _DEBUG
    for(_i = 0; _i < 512; _i++)
    {
        printf("%02x ", inImg[inSec * SECSIZE + _i]);
    }
    putchar('\n');
#endif

    return aRet;
}

/*
 * コマンドライン引数のファイル出力
 * in : inName  ファイル名
 *      inBuf   ディスクイメージデータ
 * ret: 0       成功
 *      -1      失敗
 */
int out_file(char *inName, unsigned char *inBuf)
{
    FILE *aFp;
    int aRet = 0;

    aFp = fopen(inName, "wb");
    if(aFp != NULL)
    {   /* 新規作成成功 */
        fwrite(inBuf, DISKSIZE, 1, aFp);
    }
    else
    {   /* 作成失敗 */
        aRet = -1;
    }

    fclose(aFp);

    return aRet;
}

/*
 * エントリポイント
 * in : (なし)
 * out: 出力ファイル名
 */
int main(int argc, char *argv[])
{
    char aOutFileName[PATHLEN*2];
    struct component config[COMPMAX];
    unsigned char aRaw[DISKSIZE];       /* セクタサイズ * セクタ数 */
    int aCnt;                           /* 何個のファイルを取り込むか */
    int aSec;                           /* 何セクタ目のファイルに書き込むか */
    int i;
#ifdef  _DEBUG
    int _i;
#endif

    /* コマンドライン引数確認 */
    if(argc == 2)
    {   /* 入力ファイル適用 */
        memcpy(aOutFileName, argv[1], strlen(argv[1]) + 1);
    }
    else
    {   /* デフォルトファイル適用 */
        memcpy(aOutFileName, "out.img", strlen("out.img") + 1);
    }

#ifdef _DEBUG
    printf("%s\n", aOutFileName);
#endif

    /* 入力ファイル読み込み */
    if(read_conf(config, &aCnt) == 0)
    {   /* 読み込み成功(aCnt個) */
        aSec = 0;
        printf("\ncnt: sector, filename\n");
        img_init(aRaw);

        /* バイナリ書き込み */
        for(i = 0; i < aCnt; i++)
        {   /* 一つずつ書き込んでいく */
            printf("%03d: 0x%04x, %s ...", i, aSec, config[i].fileName);
            if(deploy_file(config[i], aSec, aRaw) == 0)
            {   /* 展開成功 */
                printf("done.\n");
                aSec += config[i].secLen;       /* セクタ前進 */
            }
            else
            {   /* 展開失敗 */
                printf("error!\n");
                return 0;
            }
        }

        printf("%03d: 0x%04x, zero fill ...", i, aSec);
        /* 残りを0埋め */
        for(i = aSec * SECSIZE; i < DISKSIZE; i++)
        {
            aRaw[i] = 0x00;
        }
        printf("done.\n");
    }
    else
    {   /* 読み込み失敗 */
        return 0;
    }

    /* ファイル出力 */
    printf("\noutput ...");
    if(out_file(aOutFileName, aRaw) == 0)
    {
        printf("done!\n");
    }
    else
    {
        printf("error!");
    }

#ifdef _DEBUG
    for(_i = 0; _i < aCnt; _i++)
    {   /* ダンプ */
        printf("%03d, %s, %d\n", _i, config[_i].fileName, config[_i].secLen);
    }
#endif

    return 0;
}