; --- 画面関連 ---
%define     DISP_COLSIZE    79
%define     DISP_LINESIZE   24

; --- ディレクトリ構造 ---
; root
%define     DIR_ROOT        0x0015

; root一覧
%define     DIR_BIN         0x0016
%define     DIR_USR         0x0017
%define     DIR_README      0x0018

; bin一覧
%define     DIR_TEST        0x0019

; --- ディレクトセクタ ---
; アトリビュート
%define     ATR_EMPTY       0x00
%define     ATR_DIR         0x01
%define     ATR_FILE        0x02

; --- 入出力 ---
; ファイルディスクリプタ
%define     FD_KEYBORD      0x00
%define     FD_DISPLAY      0x01
%define     FD_SERIAL       0x02
%define     FD_FILE0        0x03
%define     FD_FILE1        0x04
%define     FD_FILE2        0x05
%define     FD_FILE3        0x06

; --- マクロ ---
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
