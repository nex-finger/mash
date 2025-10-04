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
