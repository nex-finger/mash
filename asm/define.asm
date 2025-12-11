%ifndef     __DEFINE_ASM
%define     __DEFINE_ASM

; --- 一般定義 ---
%define     _NULL               0x0000

; --- 画面関連 ---
%define     DISP_COLSIZE        79
%define     DISP_LINESIZE       24

; --- ディレクトリ構造 ---
; root
%define     DIR_ROOT            0x0015

; root一覧
%define     DIR_BIN             0x0016
%define     DIR_USR             0x0017
%define     DIR_README          0x0018

; bin一覧
%define     DIR_TEST            0x0019

; --- ディレクトセクタ ---
; アトリビュート
%define     ATR_EMPTY           0x00
%define     ATR_DIR             0x01
%define     ATR_FILE            0x02

; --- 入出力 ---
; ファイルディスクリプタ
%define     FD_KEYBORD          0x00
%define     FD_DISPLAY          0x01
%define     FD_SERIAL           0x02
%define     FD_FILE0            0x03
%define     FD_FILE1            0x04
%define     FD_FILE2            0x05
%define     FD_FILE3            0x06

; --- シェル変数 ---
; 変数型
%define     TYPE_UINT           0x00
%define     TYPE_SINT           0x01
%define     TYPE_CHAR           0x02
%define     TYPE_ARR            0x10
%define     TYPE_STR            0x12

; --- エラーコード ---
%define     RET_OK              0x00
%define     RET_NG_PRM          0x01    ; パラメータエラー

; --- マクロ ---
; memcpy
; %1 dest(コピー先アドレス)
; %2 src(コピー元アドレス)
; %3 size(コピーサイズ)
%macro MACRO_MEMCPY 3
        PUSH    DI
        PUSH    SI
        PUSH    CX

        MOV     DI, %1
        MOV     SI, %2
        MOV     CX, %3

        CALL    libMemcpy

        POP     CX
        POP     SI
        POP     DI
%endmacro

; memcmp
; AX: 比較結果
; %1 str1(比較対象1)
; %2 str2(比較対象2)
; %3 size(比較バイト数)
%macro MACRO_MEMCMP 3
        PUSH    SI
        PUSH    DI
        PUSH    CX

        MOV     SI, %1
        MOV     DI, %2
        MOV     CX, %3

        CALL    libMemcmp

        POP     CX
        POP     DI
        POP     SI
%endmacro

; strchr
; %1 str(検索する先頭アドレス)
; %2 c(検索する文字)
; %3 ret(発見したアドレス)
%macro MACRO_STRCHR 2
        PUSH    SI
        PUSH    AX

        MOV     SI, %1
        MOV     AX, %2

        CALL    libStrchr

        POP     AX
        POP     SI
%endmacro

; strchr(c89)相当
; in  : SI      探索する文字列
;       AH      区切り文字
; out : DI      null: 区切り文字は存在しない
;               null以外: 最初に発見したアドレス

; シリアル初期化
%macro MACRO_SERIAL_INIT 0
        MOV     AH, 0x00                ; シリアルポート設定
        MOV     AL, 0xe3                ; 0bBBBPPSCC, 9600bps, None, 1bit, 8bit
        MOV     DX, 0x0000              ; 0ch = COM1, xch = COMx+1
        INT     0x14
%endmacro

; シリアル1文字出力
%macro MACRO_SERIAL_PUTC 1
        PUSH    AX
        MOV     AL, %1
        CALL    dbgSingle
        POP     AX
%endmacro

; メモリダンプマクロ
; %1 ダンプするバイト数
; %2 ダンプする先頭アドレス
%macro DEBUG_REGISTER_DUMP 2
        PUSH    AX
        PUSH    DI

        MOV     AX, %1
        MOV     DI, %2
        CALL    dbgDump

        POP     DI
        POP     AX
%endmacro

%endif  ;__DEFINE_ASM