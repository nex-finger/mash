; mash
; TAB=4

; memo
; 実機で動かす場合相手側のシリアルポートと接続しないと動作がとても遅くなるので注意！

; ロゴ
; https://jp.mathworks.com/matlabcentral/fileexchange/181715-makebanner-big-ascii-style-comment-generator

%ifndef     __MASH_ASM
%define     __MASH_ASM

; --- ファイルインクルード ---
%include        "../asm/define.asm"
%define         __DEBUG                 ; デバッグ時に有効

        ORG     0x4000
        JMP     mashInit

; //////////////////////////////////////////////////////////////////////////// ;
; --- 定数 ---
;  ██████╗ ██████╗ ███╗  ██╗ ██████╗████████╗
; ██╔════╝██╔═══██╗████╗ ██║██╔════╝╚══██╔══╝
; ██║     ██║   ██║██╔██╗██║╚█████╗    ██║   
; ██║     ██║   ██║██║╚████║ ╚═══██╗   ██║   
; ╚██████╗╚██████╔╝██║ ╚███║██████╔╝   ██║   
;  ╚═════╝ ╚═════╝ ╚═╝  ╚══╝╚═════╝    ╚═╝   
; //////////////////////////////////////////////////////////////////////////// ;
cMashLogo:                              ; ロゴ(35x6 = 210byte)
        ;       ███╗   ███╗                                                        █████╗                                          ██████╗                                        ██╗  ██╗
        ;       ████╗ ████║                                                       ██╔══██╗                                        ██╔════╝                                        ██║  ██║
        ;       ██╔████╔██║                                                       ██║  ██║                                        ╚█████╗                                         ███████║
        ;       ██║╚██╔╝██║                                                       ███████║                                         ╚═══██╗                                        ██╔══██║
        ;       ██║ ╚═╝ ██║                                                       ██╔══██║                                        ██████╔╝                                        ██║  ██║
        ;       ╚═╝     ╚═╝                                                       ╚═╝  ╚═╝                                        ╚═════╝                                         ╚═╝  ╚═╝
        ;       M                                                                 A                                               S                                               H                                             
        DB      0xdb, 0xdb, 0xdb, 0xbb, 0x20, 0x20, 0x20, 0xdb, 0xdb, 0xdb, 0xbb, 0x20, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xbb, 0x20, 0x20, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xbb, 0xdb, 0xdb, 0xbb, 0x20, 0x20, 0xdb, 0xdb, 0xbb
        DB      0xdb, 0xdb, 0xdb, 0xdb, 0xbb, 0x20, 0xdb, 0xdb, 0xdb, 0xdb, 0xba, 0xdb, 0xdb, 0xc9, 0xcd, 0xcd, 0xdb, 0xdb, 0xbb, 0xdb, 0xdb, 0xc9, 0xcd, 0xcd, 0xcd, 0xcd, 0xbc, 0xdb, 0xdb, 0xba, 0x20, 0x20, 0xdb, 0xdb, 0xba
        DB      0xdb, 0xdb, 0xc9, 0xdb, 0xdb, 0xdb, 0xdb, 0xc9, 0xdb, 0xdb, 0xba, 0xdb, 0xdb, 0xba, 0x20, 0x20, 0xdb, 0xdb, 0xba, 0xc8, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xbb, 0x20, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xba
        DB      0xdb, 0xdb, 0xba, 0xc8, 0xdb, 0xdb, 0xc9, 0xbc, 0xdb, 0xdb, 0xba, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xba, 0x20, 0xc8, 0xcd, 0xcd, 0xcd, 0xdb, 0xdb, 0xbb, 0xdb, 0xdb, 0xc9, 0xcd, 0xcd, 0xdb, 0xdb, 0xba
        DB      0xdb, 0xdb, 0xba, 0x20, 0xc8, 0xcd, 0xbc, 0x20, 0xdb, 0xdb, 0xba, 0xdb, 0xdb, 0xc9, 0xcd, 0xcd, 0xdb, 0xdb, 0xba, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xc9, 0xbc, 0xdb, 0xdb, 0xba, 0x20, 0x20, 0xdb, 0xdb, 0xba
        DB      0xc8, 0xcd, 0xbc, 0x20, 0x20, 0x20, 0x20, 0x20, 0xc8, 0xcd, 0xbc, 0xc8, 0xcd, 0xbc, 0x20, 0x20, 0xc8, 0xcd, 0xbc, 0xc8, 0xcd, 0xcd, 0xcd, 0xcd, 0xcd, 0xbc, 0x20, 0xc8, 0xcd, 0xbc, 0x20, 0x20, 0xc8, 0xcd, 0xbc

cVersionLen:                            ; 版数文字列の長さ
        DW      18

cVersionStr:                            ; 版数文字列の内容
        DB      "mash system v0.2.1"

; //////////////////////////////////////////////////////////////////////////// ;
; --- 変数 ---
;  ██████╗████████╗ █████╗ ████████╗██╗ ██████╗
; ██╔════╝╚══██╔══╝██╔══██╗╚══██╔══╝██║██╔════╝
; ╚█████╗    ██║   ██║  ██║   ██║   ██║██║     
;  ╚═══██    ██║   ███████║   ██║   ██║██║     
; ██████╔╝   ██║   ██╔══██║   ██║   ██║╚██████╗
; ╚═════╝    ╚═╝   ╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝
; //////////////////////////////////////////////////////////////////////////// ;

; 表示関連
sXpos:
        DB      0x00                    ; 表示xカーソル
sYpos:
        DB      0x09                    ; 表示yカーソル
sColorNormal:
        DB      0x0f                    ; 表示色(初期値: 白)
sColorError:
        DB      0x01                    ; 表示色(初期値: 赤?)

; 入出力関連
sStdInput:                              ; 標準入力
        DB      FD_KEYBORD
sStdOut:                                ; 標準出力
        DB      FD_DISPLAY
sStdErrout:                             ; 標準エラー出力
        DB      FD_DISPLAY
sOneLineBuf:
        times   0x0100 DB 0x00          ; 入力バッファ(256byte)
sOneLineSeek:
        DW      0x0000                  ; シークオフセット

sNowDir:
        DW      DIR_ROOT                ; 現在いるディレクトリ

; シェル変数関連
sTopValAddr:
        DW      0x0000                  ; シェル変数の連結リストの先頭アドレス

; //////////////////////////////////////////////////////////////////////////// ;
; --- 初期化プログラム ---
; ██╗███╗  ██╗██╗████████╗
; ██║████╗ ██║██║╚══██╔══╝
; ██║██╔██╗██║██║   ██║   
; ██║██║╚████║██║   ██║   
; ██║██║ ╚███║██║   ██║   
; ╚═╝╚═╝  ╚══╝╚═╝   ╚═╝   
; //////////////////////////////////////////////////////////////////////////// ;

mashInit:
        MOV     AX, 0x0000              ; レジスタセット
        MOV     DS, AX
        MOV     SS, AX
        MOV     ES, AX
        MOV     SP, 0x3fff              ; ｾｸﾞﾎﾟ

        CALL    rInitMalloc             ; 動的確保メモリ初期化

        CALL    cmdVer                  ; ロゴ+版数表示

        MOV WORD [sTopValAddr], 0x0000  ; 変数チェーン初期化

        ; 番兵変数定義
        MOV     AH, 0x00
        MOV     SI, .aInitialValue
        CALL    sysDim

        ; デバッグ ---->
                MOV     AH, 0x00                ; テスト変数
                MOV     SI, .aTestValue01
                CALL    sysDim                  ; 定義

                MOV     AH, 0x10                ; テスト変数
                MOV     AL, 3                   ; 要素数は3
                MOV     SI, .aTestValue02
                CALL    sysDim                  ; 定義

                MOV     AH, 0x01                ; テスト変数
                MOV     SI, .aTestValue03
                CALL    sysDim                  ; 定義

                MOV     AH, 0x02                ; テスト変数
                MOV     SI, .aTestValue04
                CALL    sysDim                  ; 定義

                MOV     AH, 0x12                ; テスト変数
                MOV     AL, 3                   ; 要素数は3
                MOV     SI, .aTestValue05
                CALL    sysDim   

                CALL    sysList                 ; 一覧表示

                ; 比較結果確認 ---->
                        ;MOV     SI, .aTestValue03
                        ;MOV     DI, .aTestValue05
                        ;MACRO_MEMCMP SI, DI, 8
                        ;CALL    dbgPrint16bit           ; デバッグ
                ;.dbgLoop:
                        ;JMP     .dbgLoop
                ; <----

                ; メモリ確認 ---->
                        PUSH    AX
                        PUSH    SI
                        PUSH    DI

                        MOV     SI, .aInitialValue
                        CALL    rShellGet               ; 戻り値はDI
                        MOV     AX, DI
                        CALL    dbgPrint16bit           ; デバッグ

                        MOV     SI, .aTestValue01
                        CALL    rShellGet               ; 戻り値はDI
                        MOV     AX, DI
                        CALL    dbgPrint16bit           ; デバッグ

                        MOV     SI, .aTestValue02
                        CALL    rShellGet               ; 戻り値はDI
                        MOV     AX, DI
                        CALL    dbgPrint16bit           ; デバッグ

                        MOV     SI, .aTestValue03
                        CALL    rShellGet               ; 戻り値はDI
                        MOV     AX, DI
                        CALL    dbgPrint16bit           ; デバッグ

                        MOV     SI, .aTestValue04
                        CALL    rShellGet               ; 戻り値はDI
                        MOV     AX, DI
                        CALL    dbgPrint16bit           ; デバッグ

                        MOV     SI, .aTestValue04
                        CALL    rShellGet               ; 戻り値はDI
                        MOV     AX, DI
                        CALL    dbgPrint16bit           ; デバッグ

                        MOV     SI, mashLoop
                        CALL    rShellGet               ; 戻り値はDI
                        MOV     AX, DI
                        CALL    dbgPrint16bit           ; デバッグ

                        POP     DI
                        POP     SI
                        POP     AX
                ; <----
        ; <----
        
        JMP     mashLoop                ; ループ処理へ移行

.aInitialValue:                         ; 番兵の変数名
        DB      "__init  "
.aTestValue01:
        DB      "test_ui "
.aTestValue02:
        DB      "test_arr"
.aTestValue03:
        DB      "test_si "
.aTestValue04:
        DB      "test_ch "
.aTestValue05:
        DB      "test_str"

; //////////////////////////////////////////////////////////////////////////// ;
; --- ループプログラム ---
; ██╗      ██████╗  ██████╗ ██████╗ 
; ██║     ██╔═══██╗██╔═══██╗██╔══██╗
; ██║     ██║   ██║██║   ██║██████╔╝
; ██║     ██║   ██║██║   ██║██╔═══╝ 
; ███████╗╚██████╔╝╚██████╔╝██║     
; ╚══════╝ ╚═════╝  ╚═════╝ ╚═╝     
; //////////////////////////////////////////////////////////////////////////// ;

mashLoop:
        ; シェル変数の定義
        MOV     AH, "0"
.dimLoop:
        ; 設定する
        PUSH    AX

        MOV     AH, 0x12
        MOV     AL, 0x20
        MOV     SI, [.aTokenName]

        CALL    sysDim

        ; ループ制御
        POP     AX
        CMP     AH, "0"
        JZ      .input
        INC     AH
        JMP     .dimLoop

.input:
        ;CALL    libSetCursolNextLine    ; 改行
        ;CALL    rOneLineClear           ; 

        ; デバッグ(512バイト)
        DEBUG_REGISTER_DUMP 0x0100, 0x8000
        
        MOV     AL, "\"        
        CALL    libPutchar
        CALL    libSetCursolNextCol
        MOV     AL, ">"
        CALL    libPutchar
        CALL    libSetCursolNextCol
.inputLoop:
        ; 入力ループ(1文字事にループ)

        ; debug ---->
        ; in  : AX      ダンプするバイト数
        ;     : DS:DI   ダンプ開始アドレス
        ;MOV     DI, sOneLineBuf-8
        ;CALL    dbgDump
        ; <---- debug

        CALL    rOneLineInput           ; キーボード入力 → バッファ+出力
        ;PUSH    AX
        ;POP     AX
        CMP     AH, 0x00
        JZ      .inputLoop              ; 続ける

.parseBuf:
        ; バッファ解析
        MOV     AX, 0x0000

        ; puts
        MOV     BP, .aTestPuts          ; 識別文字列
        CALL    libPuts
        MOV     BP, sOneLineBuf         ; 入力バッファ
        CALL    libPuts

        ; sparse
        MOV     BP, .aTestsParse        ; 識別文字列
        CALL    libPuts
        MOV     BP, sOneLineBuf         ; 入力バッファ
        CALL    libsParse

        ; トークン分離
        MOV     CX, 0x0100              ; メモリ確保
        CALL    sysMalloc
        PUSH    BP

        MOV     SI, sOneLineBuf
        MOV     DI, BP
        MOV     CX, 0x0100

        CALL    libMemcpy

        CALL    libPuts

        POP     BP
        CALL    sysFree

        ; バッファクリア
        CALL    rOneLineClear
        JMP     mashLoop

        ; バッファトークン用の変数を解放

        
        JMP     mashLoop                ; 永遠にループする
.aTestPuts:
        DB      "puts", 0x00
.aTestsParse:
        DB      "sparse", 0x00

.aTokenName:                            ; 入力バッファトークン変数名
        DB      "_buftok"
.aTokenNum:                             ; 連番(aTokenNameと連続したメモリに置くこと)
        DB      "0"

; //////////////////////////////////////////////////////////////////////////// ;
; --- ビルトインコマンド ---
;  ██████╗ ██████╗ ███╗   ███╗███╗   ███╗ █████╗ ███╗  ██╗██████╗ 
; ██╔════╝██╔═══██╗████╗ ████║████╗ ████║██╔══██╗████╗ ██║██╔══██╗
; ██║     ██║   ██║██╔████╔██║██╔████╔██║██║  ██║██╔██╗██║██║  ██║
; ██║     ██║   ██║██║╚██╔╝██║██║╚██╔╝██║███████║██║╚████║██║  ██║
; ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║ ╚═╝ ██║██╔══██║██║ ╚███║██████╔╝
;  ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚══╝╚═════╝ 
; //////////////////////////////////////////////////////////////////////////// ;

; dim コマンド
; シェル変数を追加する
; 最新変数に位置し、次の変数へのチェーンポインタに現在の最新変数が格納される。
; 重複した同じ変数名を許容する(undimするまで最新以外の変数へはアクセスできなくなる)
; in  : AH      変数型
;               0x00: 符号なし整数型
;               0x01: 符号付き整数型
;               0x02: 文字型
;               0x10: 符号なし整数配列
;               0x12: 文字配列型
;       AL      要素数(配列型の場合のみ有効)
;       SI      変数文字列先頭アドレス
; out : CH      エラーコード
sysDim:
        CALL    rPushReg                ; レジスタ退避

        ; 確保メモリ確認 ---->
                ;PUSH    AX
                ;MOV WORD AX, 0x0001
                ;CALL    dbgPrint16bit           ; デバッグ
                ;POP     AX

                ;PUSH    AX
                ;MOV WORD AX, SI
                ;CALL    dbgPrint16bit           ; デバッグ
                ;POP     AX
        ; <----

        MOV BYTE [.aRet], RET_OK        ; 戻り値設定

        ; 格納できる内容はこの時点で入れておく
        MOV BYTE [.aType], AH
        MOV BYTE [.aLen], AL            ; 使わない型の場合参照しないので一旦入れておく

        ; デバッグ ---->
                ;DEBUG_REGISTER_DUMP 8, SI
        ; <----

        MACRO_MEMCPY .aName, SI, 8

        ; デバッグ ---->
                ;DEBUG_REGISTER_DUMP 8, .aName
        ; <----

        ; 変数を記録するメモリサイズを計算する
        ; サイズが判明した後のコールバック関数も登録しておく
        MOV BYTE AH, [.aType]
        CMP     AH, TYPE_UINT
        JZ      .type_uint
        CMP     AH, TYPE_SINT
        JZ      .type_sint
        CMP     AH, TYPE_CHAR
        JZ      .type_char
        CMP     AH, TYPE_ARR
        JZ      .type_arr
        CMP     AH, TYPE_STR
        JZ      .type_str
        JMP     .type_error             ; 型エラー

.type_uint:                             ; 符号なし整数型
        MOV BYTE [.aSize], 14           ; 整数型は14バイト固定
        MOV WORD SI, .fill_uint
        MOV WORD [.func_call], SI       ; コールバックアドレス登録
        JMP     .alloc_mem
.type_sint:                             ; 符号付き整数型
        MOV BYTE [.aSize], 14           ; 整数型は14バイト固定
        MOV WORD SI, .fill_sint
        MOV WORD [.func_call], SI
        JMP     .alloc_mem
.type_char:
        MOV BYTE [.aSize], 13           ; 文字型は13バイト固定
        MOV WORD SI, .fill_char
        MOV WORD [.func_call], SI
        JMP     .alloc_mem
.type_arr:
        MOV BYTE AL, [.aLen]            ; 整数配列のサイズは 2n+14 バイト
        SHL     AL, 1
        ADD     AL, 14
        MOV BYTE [.aSize], AL
        MOV WORD SI, .fill_arr
        MOV WORD [.func_call], SI
        JMP     .alloc_mem
.type_str:
        MOV BYTE AL, [.aLen]            ; 文字配列のサイズは n+14 バイト
        ADD     AL, 14
        MOV BYTE [.aSize], AL
        MOV WORD SI, .fill_str
        MOV WORD [.func_call], SI
        JMP     .alloc_mem
.type_error:
        MOV BYTE [.aRet], RET_NG_PRM
        JMP     .exit

.alloc_mem:
        ; 必要な分のメモリを動的確保する
        ; free時に断片化が起きないよう一括取得を優先する
        MOV     CH, 0x00
        MOV BYTE CL, [.aSize]
        CALL    sysMalloc               ; 確保メモリはBP
        MOV WORD [.aAddr], BP           ; 先頭アドレス保存

        ; 現在の最新アドレスを一つ前へ
        MOV WORD SI, [sTopValAddr]
        MOV WORD [.aNext], SI

        ; 確保メモリ確認 ---->
                ;PUSH    AX
                ;MOV WORD AX, 0x0002
                ;CALL    dbgPrint16bit           ; デバッグ
                ;POP     AX

                ;PUSH    AX
                ;MOV WORD AX, [.aAddr]
                ;CALL    dbgPrint16bit           ; デバッグ
                ;POP     AX
        ; <----

        ; チェーン確認 ---->
                ;PUSH    AX
                ;MOV WORD AX, 0x0003
                ;CALL    dbgPrint16bit           ; デバッグ
                ;POP     AX

                ;PUSH    AX
                ;MOV WORD AX, [.aNext]
                ;CALL    dbgPrint16bit           ; デバッグ
                ;POP     AX
        ; <----

.fill_common1:                          ; 代入処理(共通)
        ; データを格納していく
        MOV WORD BP, [.aAddr]           ; 先頭アドレス
        MOV BYTE AH, [.aSize]           ; 変数型

        MOV BYTE [BP], AH               ; BP: 変数サイズ
        ADD     BP, 1
        MOV BYTE AH, [.aType]
        MOV BYTE [BP], AH               ; BP+1: 変数型
        ADD     BP, 1

        MACRO_MEMCPY BP, .aName, 8      ; BP+2: 変数名

        JMP     [.func_call]            ; コールバック呼び出し(void)

.fill_uint:                             ; 符号なし整数 代入コールバック
.fill_sint:                             ; 符号付き整数 代入コールバック
.fill_char:                             ; 文字 代入コールバック
        JMP .fill_common2

.fill_arr:                              ; 配列 代入コールバック
.fill_str:                              ; 文字列 代入コールバック
        MOV WORD BP, [.aAddr]           ; 先頭アドレス
        MOV BYTE AH, [.aLen]
        ADD     BP, 10
        MOV BYTE [BP], AH               ; BP+10: 要素数
        JMP .fill_common2

.fill_common2:
        MOV WORD BP, [.aAddr]           ; 先頭アドレス
        MOV     BH, 0x00
        MOV BYTE AH, [.aSize]
        ADD     BL, AH
        ADD     BP, BX
        SUB     BP, 2
        MOV WORD AX, [.aNext]
        MOV WORD [BP], AX
        ; 宣言した変数のポインタを最新ポインタに記録する
        MOV WORD BP, [.aAddr]
        MOV WORD [sTopValAddr], BP
        JMP     .exit

.exit:
        CALL    rPopReg                 ; レジスタ取得
        MOV BYTE CH, [.aRet]
        RET
.func_call:                             ; コールバックアドレス
        DW      0x0000
.aSize:                                 ; 変数メモリサイズ
        DB      0x00
.aType:                                 ; 変数型
        DB      0x00
.aName:                                 ; 変数名(最大8文字)
        DB      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
.aLen:                                  ; 要素数
        DB      0x00
.aAddr:                                 ; 本変数の先頭アドレス
        DW      0x0000
.aNext:                                 ; 次の変数へのチェーンアドレス
        DW      0x0000
.aRet:                                  ; エラーコード
        DB      0x00

; undim コマンド
; シェル変数を解放する
sysUndim:
        CALL    rPushReg                ; レジスタ退避

        CALL    rPopReg                 ; レジスタ取得
        RET

; set コマンド
; シェル変数の値を更新する
; in  : SI      変数文字列先頭アドレス
;       AL      要素数(配列型の場合のみ有効)
; out : CH      エラーコード
sysSet:
        CALL    rPushReg                ; レジスタ退避

        ; 入力変数名と一致する変数を発見する(strstr使用？)

        ; 発見した変数の型を取得する

        ; シェルから入力された文字列を数値に変換する

        ; 数値をセットする

        CALL    rPopReg                 ; レジスタ取得
        RET

; list コマンド
; シェル変数のチェーンを列挙する
sysList:
        CALL    rPushReg                ; レジスタ退避

        MOV     BP, .aTmp_string
        ADD     BP, 8
        MOV BYTE [BP], 0x00             ; 変数文字列の最後をnullに

        MOV     BP, .aLabel_intro
        CALL    libsParseNoCRLF         ; 説明文表示(sParse必須)

        MOV     BP, .aLabel_newest
        CALL    libsParseNoCRLF         ; 説明文表示(sParse必須)

        MOV     SI, [sTopValAddr]       ; 変数構造体のポインタを取得する
        MOV WORD [.aStruct_p], SI

.listLoop:
        ; アドレス、変数名、値の表示する
        MOV WORD AX, [.aStruct_p]       ; アドレスを表示
        MOV     SI, .aTmp_long
        CALL    libitox
        MOV     BP, .aTmp_long
        CALL    libPutsNoCRLF
        
        MOV     BP, .aSample_colon
        CALL    libPutsNoCRLF    

        MOV     BP, .aSample_tab        ; タブ
        CALL    libsParseNoCRLF        

        MOV WORD SI, [.aStruct_p]       ; 変数型を表示
        ADD     SI, 1
        MOV BYTE AH, [SI]
.cmp_uint:
        CMP     AH, 0x00
        JNZ     .cmp_array
        MOV     BP, .aLabel_uint
        JMP     .cmp_exit
.cmp_array:
        CMP     AH, 0x10
        JNZ     .cmp_sint
        MOV     BP, .aLabel_array
        JMP     .cmp_exit
.cmp_sint:
        CMP     AH, 0x01
        JNZ     .cmp_char
        MOV     BP, .aLabel_sint
        JMP     .cmp_exit
.cmp_char:
        CMP     AH, 0x02
        JNZ     .cmp_string
        MOV     BP, .aLabel_char
        JMP     .cmp_exit
.cmp_string:
        CMP     AH, 0x12
        JNZ     .cmp_error
        MOV     BP, .aLabel_string
        JMP     .cmp_exit
.cmp_error:                             ; 一旦エラー処理はなし
.cmp_exit:
        MOV BYTE [.aStruct_type], AH
        CALL    libPutsNoCRLF

        MOV     BP, .aSample_tab        ; タブ
        CALL    libsParseNoCRLF

        MOV     SI, [.aStruct_p]        ; 変数名表示
        ADD     SI, 2
        MACRO_MEMCPY .aTmp_string, SI, 8
        MOV     BP, .aTmp_string
        CALL    libPutsNoCRLF

        MOV     BP, .aSample_space      ; 空白(タブだと離れすぎ)
        CALL    libsParseNoCRLF

        MOV BYTE AH, [.aStruct_type]    ; 値を表示
        CMP     AH, 0x00                ; 変数型により分岐
        JZ      .aPrintUint
        CMP     AH, 0x01
        JZ      .aPrintSint
        CMP     AH, 0x02
        JZ      .aPrintChar
        CMP     AH, 0x10
        JZ      .aPrintArray
        CMP     AH, 0x12
        JZ      .aPrintString
        JMP     .aPrintError
.aPrintUint:                            ; 符号なし16ビット 16進表示
        MOV WORD BP, [.aStruct_p]       ; 16進4文字
        ADD     BP, 10
        MOV WORD AX, [BP]
        MOV     SI, .aTmp_string
        MOV     BH, 0x01                ; "0x"あり
        CALL    libitox                 ; 数値→文字列
        MOV     BP, .aTmp_string
        CALL    libPutsNoCRLF
        JMP     .aPrintNext
.aPrintSint:                            ; 符号あり16ビット 10進表示
        MOV WORD BP, [.aStruct_p]       ; 10進8文字
        ADD     BP, 10
        MOV WORD AX, [BP]
        MOV     SI, .aTmp_string
        CALL    libitod                 ; 数値→文字列
        MOV     BP, .aTmp_string
        CALL    libPutsNoCRLF
        JMP     .aPrintNext
.aPrintChar:                            ; 文字 16進表示
        MOV WORD BP, [.aStruct_p]       ; 16進2文字
        ADD     BP, 10
        MOV BYTE AH, [BP]
        MOV     SI, .aTmp_string
        MOV     BH, 0x01                ; "0x"あり
        CALL    libitob                 ; 数値→文字列
        MOV     BP, .aTmp_string
        CALL    libPutsNoCRLF
        JMP     .aPrintNext
.aPrintArray:                           ; 配列 16進表示の繰り返し
        MOV WORD BP, [.aStruct_p]       ; 16進4文字の繰り返し
        ADD     BP, 10
        MOV BYTE AH, [BP]
        PUSH    AX
        INC     BP                      ; 現在BP = .aStruct_p + 11
        PUSH    BP

        MOV     AL, "{"                 ; 最初の括弧
        CALL    libPutchar
        CALL    libSetCursolNextCol
.aPrintArrayLoop:
        ; この時点で BPには変数の先頭ポインタ
        MOV WORD AX, [BP]
        MOV     SI, .aTmp_string
        MOV     BH, 0x01                ; "0x"あり
        CALL    libitox                 ; 数値→文字列
        MOV     BP, .aTmp_string        ; BPはPUSHしているので捨てて良い
        CALL    libPutsNoCRLF

        POP     BP                      ; BP, AH更新
        POP     AX
        DEC     AH
        ADD     BP, 2
        PUSH    AX
        PUSH    BP

        CMP     AH, 0x00
        JZ      .aPrintArrayNext        ; 回数をこなしたら終了
        MOV     AL, ","
        CALL    libPutchar
        CALL    libSetCursolNextCol
        MOV     AL, " "
        CALL    libPutchar
        CALL    libSetCursolNextCol
        JMP     .aPrintArrayLoop        ; 要素数だけ繰り返す

.aPrintArrayNext:
        POP     BP
        POP     AX

        MOV     AL, "}"                 ; 最後の括弧とじ
        CALL    libPutchar
        CALL    libSetCursolNextCol

        JMP     .aPrintNext
.aPrintString:                          ; 文字列 文字表示
        MOV WORD BP, [.aStruct_p]
        ADD     BP, 10
        MOV BYTE AH, [BP]

        MOV     AL, 0x22                ; 最初の "
        CALL    libPutchar
        CALL    libSetCursolNextCol
.aPrintStringLoop:
        ; この時点で BPには文字列の先頭ポインタ、 AHには残り表示文字数
        MOV BYTE AL, [BP]               ; 1文字表示
        CALL    libPutchar
        CALL    libSetCursolNextCol

        DEC     AH                      ; 次の1文字にフォーカス
        INC     BP

        ; null文字が来るか、変数の最後まで到達したら終わり
        CMP     AH, 0x00
        JZ      .aPrintStringNext       ; 回数をこなしたら終了
        CMP     AL, 0x00
        JZ      .aPrintStringNext       ; null文字が来たら終了
        JMP     .aPrintStringLoop       ; 要素数だけ繰り返す

.aPrintStringNext:

        MOV     AL, 0x22                ; 最後の "
        CALL    libPutchar
        CALL    libSetCursolNextCol
        JMP     .aPrintNext
.aPrintError:                           ; 異常値 一旦無限ループ
        JMP     .aPrintError

.aPrintNext:
        MOV     BP, .aSample_next
        CALL    libsParseNoCRLF         ; 改行

        ; チェーン情報をAXに格納する
        ; デバッグ ---->
        ;JMP     .exit
        ; <----

        MOV     BP, [.aStruct_p]        ; 変数チェーンを確認、nullなら終了
        MOV BYTE BL, [BP]
        MOV     AX, BP
        ADD     AL, BL
        SUB     AX, 2                   ; チェーンは変数構造体の末尾2バイト
        MOV     BP, AX

        ; メモリ確認 ---->
        ;PUSH    AX
        ;MOV     AX, [BP]
        ;CALL    dbgPrint16bit           ; デバッグ
        ;POP     AX
        ; <----

        MOV     AX, [BP]
        CMP     AX, 0x0000
        JZ      .exit
        MOV WORD [.aStruct_p], AX       ; 次の変数のポインタをセット
        ;MOV BYTE [.DebugCnt], 0x01 ;デバッグ
        JMP     .listLoop

.exit:
        MOV     BP, .aLabel_oldest
        CALL    libsParseNoCRLF         ; 説明文表示(sParse必須)

        CALL    rPopReg                 ; レジスタ取得
        RET
.aLabel_intro:                          ; １行目の説明
        DB      "ADDRESS\tTYPE\tNAME\t VALUE\n", 0x00
.aLabel_newest:                         ; ２行目の説明
        DB      "(", 0x18, " faster-hot!!)\n", 0x00
.aLabel_oldest:                         ; 最終行の説明
        DB      "(", 0x19, " slower-cold...)\n", 0x00
.aLabel_uint:
        DB      "uint16", 0x00
.aLabel_array:
        DB      "array", 0x00
.aLabel_sint:
        DB      "sint16", 0x00
.aLabel_char:
        DB      "char", 0x00
.aLabel_string:
        DB      "string", 0x00
.aSample_tab:
        DB      "\t", 0x00
.aSample_next:
        DB      "\n", 0x00
.aSample_space:
        DB      " ", 0x00
.aSample_colon:
        DB      ":", 0x00
.aStruct_p:                             ; 変数構造体のポインタ
        DW      0x0000
.aStruct_type:                          ; 変数の型
        DB      0x00
.aTmp_byte:                             ; 1文字 + null
        DB      0x00, 0x00
.aTmp_word:                             ; 2文字 + null
        DW      0x00, 0x00, 0x00
.aTmp_long:                             ; 4文字 + null
        DB      0x00, 0x00, 0x00, 0x00, 0x00
.aTmp_string:                           ; 8文字 + null
        DB      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

; dir コマンド
; 現在のディレクトリのフォルダ、ファイルを表示する
sysDir:
        CALL    rPushReg                ; レジスタ退避

        MOV     CX, 0x0200              ; 現在のディレクトリ用のメモリを取得
        CALL    sysMalloc
        MOV WORD [.allocAddr1], BP
        MOV     CX, 0x0200              ; リンク先のディレクトリ用のメモリを取得
        CALL    sysMalloc
        MOV WORD [.allocAddr2], BP

        CALL    rPopReg                 ; レジスタ取得
        RET
.allocAddr1:
        DB      0x00, 0x00
.allocAddr2:
        DB      0x00, 0x00

; pwd コマンド
; 現在のディレクトリを標準出力に渡す
sysPwd:
        CALL    rPushReg                ; レジスタ退避
        CALL    rPopReg                 ; レジスタ取得
        RET

; echo コマンド
; 文字列の表示(エスケープシーケンスあり)
; in  : BP      表示する文字列の先頭ポインタ
; out : 画面表示
sysEcho:
        CALL    rPushReg                ; レジスタ退避
        CALL    rPopReg                 ; レジスタ取得
        RET

; malloc コマンド
; 指定されたバイト数の確保した先頭アドレスを返却する
; 実際の確保は16バイト単位で行われる
; 一度に確保できるのは 4080(255* 16)バイト まで
;
; アロケーションメモリ: 0x0800 ~ 0x0fff
; アロケーションテーブル: 0x8000 ~ 0xffff
;
; in  : CX      確保したいメモリ容量(バイト)
; out : AX      結果 0成功 1失敗
;     : BP      確保した先頭ポインタ(確保に成功した場合)
sysMalloc:
        CALL    rPushReg                ; レジスタ退避

        CMP     CX, 0x1000              ; 確保メモリ上限チェック
        JAE     .retError
        CMP     CX, 0x0000              ; 0バイトかチェック
        JZ      .retError
        ADD     CX, 0x000f              ; 確保するブロック数(1ブロック16バイト) = (確保したいバイト + 15) /16
        SHR     CX, 0x04
        MOV BYTE [.aSize], CL
        MOV WORD [.aFAdr], 0x0800       ; テーブルの先頭ポインタは 0x0800
        MOV BYTE [.aCnt], 0x00
        MOV WORD [.aRet], 0x0800
.mallocLoop:
        MOV WORD DI, [.aFAdr]           ; シークしている番地が0か確認
        MOV BYTE AH, [DI]
        CMP     AH, 0x00
        JZ      .cntChk
        MOV BYTE [.aCnt], 0x00         ; シーク番地が0ではないので連続数をリセット
        MOV WORD AX, [.aFAdr]           ; アロケーションテーブルをシーク
        INC     AX
        MOV WORD [.aFAdr], AX
        MOV WORD [.aRet], AX            ; シーク以前には確保できる領域がないため次へ
.exitChk:
        MOV WORD AX, [.aFAdr]           ; テーブルの末尾まで行ったらもう見込みなし
        CMP     AX, 0x1000              ; 末尾は 0x0fff
        JNZ     .mallocLoop             ; 末尾ではないなら次の1バイトを
        JMP     .retError
.cntChk:
        MOV BYTE BH, [.aCnt]            ; 連続空きブロックカウントをカウントアップ
        INC     BH                      ; AHには連続空きブロック
        MOV BYTE [.aCnt], BH
        MOV BYTE CH, [.aSize]           ; 連続空きブロックで注文した領域を充足するか？
        CMP     BH, CH                  ; ALには注文されたブロック数(AHには連続空きブロック)
        JZ      .fillTbl
        MOV WORD AX, [.aFAdr]           ; まだ充足しないため検索を続ける(連続空きブロックは継続)
        INC     AX
        MOV WORD [.aFAdr], AX
        JMP     .exitChk                ; 末尾チェックへ
.fillTbl:
        MOV WORD AX, [.aFAdr]           ; 連続空きブロックの先頭アドレスを取得
        MOV     DI, AX                  ; 以後空きブロックのアドレスは DI にて参照
        MOV BYTE AH, [.aCnt]            ; 以後注文されたブロック数は AH にて参照
        MOV     CL, 0x00
.fillLoop:
        INC     CL                      ; aCnt++
        MOV BYTE [DS:DI], CL            ; free用に意味のある値を格納
        DEC     DI                      ; aFAdr--
        CMP     AH, CL                  ; 注文されたブロック数だけ書き込んだら終了
        JNZ     .fillLoop
        MOV WORD AX, [.aRet]            ; 呼び出し元に返却するのは (連続空きブロックの先頭アドレス) * 16
        SHL     AX, 0x04
        MOV WORD [.aRet], AX
        JMP     .return
.retError:
        MOV WORD [.aRet], 0xffff        ; とりあえずゴミデータ
.return:
        CALL    rPopReg                 ; レジスタ取得
        MOV WORD BP, [.aRet]            ; 取得した先頭アドレスを格納

        RET                             ; 呼び出し元へ     
.aFAdr:                                 ; テーブル内シークアドレス
        DB      0x00, 0x00
.aCnt:                                  ; 現時点の連続空きブロック
        DB      0x00
.aSize:                                 ; 検索するべき連続空きブロック
        DB      0x00
.aRet:                                  ; 返却するアロケーションメモリアドレス
        DB      0x00, 0x00

; free コマンド
; 指定されたアドレスを含む確保領域を解放する
; 実際の確保は16バイト単位で行われる
;
; アロケーションメモリ: 0x1000:0x0000 ~ 0x1000:0xffff
; アロケーションテーブル: 0x0000:0x1000 ~ 0x0000:0x1fff
;
; in  : BP      解放したいアドレス(確保した領域内ならどこでも)
; out : AX      結果 0成功 1失敗
sysFree:
        CALL    rPushReg                ; レジスタ退避
        MOV     DI, BP                  ; DI ← (BP / 16)
        SHR     DI, 0x04

.freeLoop:                              ; 確保した先頭まで戻る
        MOV BYTE AH, [DI]            ; sTbl[DI]
        CMP     AH, 0x00                ; 値が 0x00 なら異常メモリを入力している
        JZ      .next
        MOV BYTE [DI], 0x00
        INC     DI
        CMP     AH, 0x01                ; 値が 0x01 まで続ける
        JNZ     .freeLoop
.next:
        CALL    rPopReg                 ; レジスタ取得
        RET

; printf 等の文字列解析+文字出力(エスケープシーケンスあり)
; 256文字まで(終端文字含む)
; %c: 文字, %s: 文字列, %d: 10進数, %x: 16進数(小文字), %X: 16進数(大文字)
; \a: 警報音, \n: 復帰改行, \r: 復帰, \t: タブ, \o: 更新なしで次の文字へ, \\, \?, \', \": 1文字, \0: 文字列終了
; \Uxx: カーソルをxx(10新2桁)行上, \Dxx: 下, \Rxx: 右, \Lxx: 左
; \Xxx: カーソルのx座標をxx(10新2桁)に移動, \Yxx: カーソルのx座標をxx(10新2桁)に移動, 
; in  : AX 出力先ファイルディスクリプタ
;     : SI 文字列の先頭ポインタ
;     : DI 変数の先頭ポインタ(DI:1つ目の変数, DI+4:2つ目の変数...)
sysPrintf:
        CALL    rPushReg                ; レジスタ退避

        CALL    rPopReg                 ; レジスタ取得
        RET

; 文字列の表示
; 終端文字(0x00)を確認するまで文字を表示し続ける
; in  : BX      表示する文字列
;       DS:BX   データポインタ
; out : AX      表示結果
;                   0: 成功
;                   1: 256文字以上の文字列を表示しようとした
;                   2: その他の失敗
sysPrint:
        CALL    rPushReg                ; レジスタ退避



        CALL    rPopReg                 ; レジスタ取得
        RET

; 単一の文字出力
; カーソル位置の更新も行う
; in  : AL      表示する文字
sysPutChar:

; //////////////////////////////////////////////////////////////////////////// ;
; --- ライブラリ ---
; ██╗     ██╗██████╗ ██████╗  █████╗ ██████╗ ██╗   ██╗
; ██║     ██║██╔══██╗██╔══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝
; ██║     ██║██████╔╝██████╔╝██║  ██║██████╔╝ ╚████╔╝ 
; ██║     ██║██╔══██╗██╔══██╗███████║██╔══██╗  ╚██╔╝  
; ███████╗██║██████╔╝██║  ██║██╔══██║██║  ██║   ██║   
; ╚══════╝╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   
; //////////////////////////////////////////////////////////////////////////// ;

; 文字分類マクロ
; type.asm
%include        "../asm/lib/type.asm"

; 画面カーソル制御マクロ
; cursol.asm
%include        "../asm/lib/cursol.asm"

; 配列操作マクロ
; array.asm
%include        "../asm/lib/array.asm"

; 型変換マクロ
; cast.asm
%include        "../asm/lib/cast.asm"

; //////////////////////////////////////////////////////////////////////////// ;
; stdio.h                                                                      ;
;       libPutchar      libPuts         libsParse       libsPrintf             ;
; //////////////////////////////////////////////////////////////////////////// ;

; 1文字出力
; static変数の座標を参照する
; putchar(c89) 相当
; in  : AL      asciiコード
; out : (なし)
libPutchar:
        CALL    rPushReg                ; レジスタ退避

        MOV BYTE [.aChar], AL

        MOV     AH, 0x13
        MOV     AL, 0x00
        MOV     BH, 0x00
        MOV BYTE BL, [sColorNormal]
        MOV     CX, 0x0001
        MOV BYTE DL, [sXpos]
        MOV BYTE DH, [sYpos]
        MOV     BP, .aChar
        INT     0x10

        CALL    rPopReg                 ; レジスタ取得
        RET
.aChar:                                 ; 表示文字
        DB      0x00

; 文字列出力(エスケープシーケンスなし)
; \0 (0x00) を確認し次第改行して終了
; puts(c89) 相当
; in  : DS:BP   表示する文字列ポインタ
; out : なし
libPuts:
        CALL    rPushReg                ; レジスタ退避

        CALL    libPutsNoCRLF
        CALL    libSetCursolNextLine    ; 改行

        CALL    rPopReg                 ; レジスタ取得
        RET

; 改行なし文字列出力(エスケープシーケンス)
; \0 (0x00) を確認し次第改行して終了
; puts(c89)の改行なしver
; in  : BP      表示する文字列ポインタ
; out : なし
libPutsNoCRLF:
        CALL    rPushReg                ; レジスタ退避

.chk:
        ; 1文字取得 ---->
        MOV BYTE AL, [BP]
        CMP     AL, 0x00
        JZ      .exit
        JMP     .put
        ; <---- 1文字取得

.put:
        CALL    libPutchar
        CALL    libSetCursolNextCol

        INC     BP
        JMP     .chk

.exit:
        CALL    rPopReg                 ; レジスタ取得
        RET

; 文字列出力(エスケープシーケンスあり)
; \0 (0x00) を確認し次第改行して終了
; '\'を確認し次第エスケープシーケンス確認
; puts(c89) 相当
; in  : SS:BP   表示する文字列ポインタ
; out : なし
libsParse:
        CALL    rPushReg                ; レジスタ退避   

        CALL    libsParseNoCRLF
        CALL    libSetCursolNextLine    ; 改行

        CALL    rPopReg                 ; レジスタ取得
        RET

; 文字列出力(エスケープシーケンスあり)
; 上記 libsParse の改行なしver
libsParseNoCRLF:
        CALL    rPushReg

.chk:
        ; 1文字取得 ---->
        MOV BYTE AL, [BP]
        CMP     AL, 0x00
        JZ      .exit
        JMP     .put
        ; <---- 1文字取得

.put:
        CMP     AL, "\"
        JZ      .parse
.print:
        CALL    libPutchar
        CALL    libSetCursolNextCol

        INC     BP
        JMP     .chk
.parse:
        INC     BP
        MOV BYTE AL, [BP]            ; '\'の次の1文字を取得

        ; \b: バックスペース
.bs:
        CMP     AL, "b"
        JNZ     .tab
        MOV BYTE AH, [sXpos]
        CMP     AH, 0x00
        JZ      .bsNext
        DEC     AH
        MOV BYTE [sXpos], AH
.bsNext:
        MOV     AL, " "
        CALL    libPutchar

        JMP     .parseend

        ; \t: タブ
.tab:
        CMP     AL, "t"
        JNZ     .lf
.tabLoop:
        MOV     AL, " "
        CALL    libPutchar
        CALL    libSetCursolNextCol

        MOV BYTE AH, [sXpos]
        AND     AH, 0x07
        CMP     AH, 0x00
        JZ      .tabNext
        JMP     .tabLoop
.tabNext:
        JMP     .parseend

        ; \n: 改行
.lf:
        CMP     AL, "n"
        JNZ     .cr
        CALL    libSetCursolNextLine

        JMP     .parseend

        ; \r: キャリッジリターン
.cr:
        CMP     AL, "r"
        JNZ     .bslash
        MOV BYTE [sXpos], 0x00
        JMP     .parseend

        ; \\: バックスラッシュ
.bslash:
        CMP     AL, "\"
        JNZ     .null

        MOV     AL, "\"
        CALL    libPutchar
        CALL    libSetCursolNextCol

        JMP     .parseend

        ; 0x00: 出力中断
.null:
        CMP     AL, 0x00
        JNZ     .exit
.parseend:
        INC     BP
        JMP     .chk

.exit:

        CALL    rPopReg
        RET

libsPrintf:
        CALL    rPushReg                ; レジスタ退避
        
        CALL    rPopReg                 ; レジスタ取得
        RET

; //////////////////////////////////////////////////////////////////////////// ;
; --- サブルーチン ---
;  ██████╗██╗   ██╗██████╗      ██████╗  ██████╗ ██╗   ██╗████████╗██╗███╗  ██╗███████╗
; ██╔════╝██║   ██║██╔══██╗     ██╔══██╗██╔═══██╗██║   ██║╚══██╔══╝██║████╗ ██║██╔════╝
; ╚█████╗ ██║   ██║██████╔╝     ██████╔╝██║   ██║██║   ██║   ██║   ██║██╔██╗██║███████╗
;  ╚═══██╗██║   ██║██╔══██╗     ██╔══██╗██║   ██║██║   ██║   ██║   ██║██║╚████║██╔════╝
; ██████╔╝╚██████╔╝██████╔╝     ██║  ██║╚██████╔╝╚██████╔╝   ██║   ██║██║ ╚███║███████╗
; ╚═════╝  ╚═════╝ ╚═════╝      ╚═╝  ╚═╝ ╚═════╝  ╚═════╝    ╚═╝   ╚═╝╚═╝  ╚══╝╚══════╝
; //////////////////////////////////////////////////////////////////////////// ;

; カーソル表示更新
; in  : (なし)
; out : (なし)
rSetCursol:
        CALL    rPushReg                ; レジスタ退避

        MOV     AH, 0x02
        MOV     BH, 0x00
        MOV BYTE DL, [sXpos]
        MOV BYTE DH, [sYpos]
        INT     0x10

        CALL    rPopReg                 ; レジスタ取得
        RET

; シェル入力をディスプレイとバッファに格納する
; in  : (なし)
; out : AH      0: 続ける
;               1: 終了(enterキー)
;               2: バッファオーバーフロー
rOneLineInput:
        CALL    rPushReg                ; レジスタ退避
        MOV BYTE [.aChar], 0x00         ; 戻り値設定

        ; 入力から1文字取得 ---->
        MOV     AH, 0x00                ; 1文字取得
        INT     0x16
        ; <---- 入力から1文字取得

        ; 印字可能文字の判定 ---->
        CMP     AL, 0x0d                ; enterで終了
        JZ      .caseEnter
        CALL    libIsprint              ; 印字可能文字か判定
        CMP     AH, 0x00
        JZ      .caseNotEnter
        ; <---- 印字可能文字の判定

        ; 画面への反映 ---->
        MOV BYTE [.aChar], AL
        CALL    libPutchar              ; 1文字出力
        JMP     .caseNotEnter
        ; <---- 画面への反映

        ; カーソル位置更新 ---->
.caseEnter:                             ; enterを入力した場合
        CALL    libSetCursolNextLine    ; 改行用のカーソル移動
        MOV BYTE [.aRet], 0x01         ; 戻り値設定
        JMP     .exitLoutine            ; 格納せず終了
.caseNotEnter:                          ; enter以外を入力した場合
        CALL    libSetCursolNextCol     ; 通常用のカーソル移動
        MOV BYTE [.aRet], 0x00         ; 戻り値設定
        JMP     .setBuf                 ; バッファに格納
        ; <---- カーソル位置更新
.setBuf:                                ; バッファに文字を格納する
        ; debug ---->
        ;JMP     .exitLoutine
        ; <---- debug

        ; バッファに格納 ---->
        MOV     AX, sOneLineBuf
        ADD WORD AX, [sOneLineSeek]     ; 配列のオフセット
        MOV     BP, AX
        MOV BYTE AH, [.aChar]
        MOV BYTE [BP], AH            ; 格納
        ; <---- バッファに格納

        ; オフセットシーク ---->
        MOV WORD CX, [sOneLineSeek]
        INC     CX
        MOV WORD [sOneLineSeek], CX
        ; <---- オフセットシーク
        
        JMP     .exitLoutine
.exitLoutine:
        CALL    rPopReg                 ; レジスタ取得
        MOV BYTE AH, [.aRet]
        RET
.aChar:                                 ; 取得文字
        DB      0x00
.aRet:                                  ; 戻り値
        DB      0x00

; 入力バッファをクリアする
; in  : (なし)
; out : (なし)
rOneLineClear:
        CALL    rPushReg                ; レジスタ退避

        MOV WORD DI, sOneLineBuf
        MOV     CX, 0x0000
.clearLoop:                             ; 0埋め
        MOV BYTE [DI], 0x00
        INC     CX
        INC     DI
        CMP     CX, 0x0100
        JNZ     .clearLoop

        MOV WORD [sOneLineSeek], 0x0000 ; バッファシークリセット
        ;MOV WORD DI, [sOneLineBuf]

        CALL    rPopReg                 ; レジスタ取得
        RET

; malloc 用のアロケーションメモリとアロケーションテーブルを初期化
; アロケーションメモリ 0x0800 ~ 0x0fff
; アロケーションテーブル 0x8000 ~ 0xffff
; in  : なし
; out : なし
rInitMalloc:
        CALL    rPushReg                ; レジスタ退避

        MOV     BP, 0x0800
.initLoop:
        MOV BYTE [BP], 0x00
        INC     BP
        CMP     BP, 0x1000
        JNZ     .initLoop

        MOV     ES, AX
%ifdef __DEBUG
        ;MOV     CX, 0x0012              ; 動的確保テスト
        ;CALL    sysMalloc
        ;MOV     CX, 0x0034
        ;CALL    sysMalloc
        ;PUSH    BP
        ;MOV     CX, 0x0056
        ;CALL    sysMalloc
        ;POP     BP
        ;CALL    sysFree
        ;MOV     AX, 0x1010
        ;MOV     BP, AX
        ;CALL    sysFree
        
        ;PUSH    DS                      ; アロケーションテーブル
        ;MOV     AX, 0x0000
        ;MOV     DS, AX
        ;MOV     AX, 0x0200
        ;MOV     DI, 0x1000
        ;CALL    dbgDump
        ;POP     DS
%endif
        CALL    rPopReg                 ; レジスタ取得
        RET

; mashのバージョン表示
; ロゴとバージョンについて記載する
; in  : なし
; out : なし
cmdVer:
        CALL    rPushReg                ; レジスタ退避
        MOV     AX, 0x0000
        MOV     BP, cMashLogo           ; ロゴの表示
        MOV     CX, 0x0000
.loophead:
        PUSH    CX                      ; ループ変数格納
        MOV     AH, 0x13
        MOV     AL, 0x01
        MOV     BH, 0
        MOV     BL, [DS:sColorNormal]
        MOV     CX, 35                  ; 1行35文字
        MOV     DH, [DS:sYpos]
        MOV     DL, [DS:sXpos]
        INT     0x10

        ADD     BP, 35                  ; 1行35文字
        POP     CX                      ; ループ変数取得
        MOV BYTE [sXpos], 0x00
        INC BYTE [sYpos]
        INC     CX
        CMP     CX, 0x0006
        JNZ     .loophead    
.next:
        MOV     BP, cVersionStr
        MOV     AH, 0x13                ; 版数の表示
        MOV     AL, 0x01
        MOV     BH, 0
        MOV     BL, [sColorNormal]
        MOV     CX, [cVersionLen]
        MOV     DH, [sYpos]
        MOV     DL, [sXpos]
        INT     0x10
        MOV BYTE [sXpos], 0x00
        INC BYTE [sYpos]
        CALL    rPopReg                 ; レジスタ取得
        RET

; シェル変数を検索し、先頭ポインタを返却する
; in  : SI      検索する変数名
; out : DI      null以外: 発見した変数ポインタ
;               null: 見つからなかった
rShellGet:
        CALL    rPushReg                ; レジスタ退避

        MACRO_MEMCPY .inName, SI, 8     ; 入力文字列を0埋め8バイトに格納
        MOV     BH, 0x00                ; null来たら 0x01 になる
        MOV     BP, .inName
        MOV     CX, 0x0000
.inputLoop:
        MOV BYTE AH, [BP]
        CMP     AH, 0x00
        JNZ     .inputNotNull           ; nullじゃないなら変化なし(過去にnullが来ていてもフラグは保持)
        MOV     BH, 0x01                ; nullならフラグ立てる
.inputNotNull:
        CMP     BH, 0x00
        JZ      .inputNullFillNext
        MOV BYTE [BP], 0x20
.inputNullFillNext:
        INC     BP
        INC     CX
        CMP     CX, 0x0008              ; 変数型は8文字で終了
        JNZ     .inputLoop

        MOV WORD BP, [sTopValAddr]      ; 変数チェーンの先頭から文字列が一致するまで検索する
        MOV     BX, 0x0000
.searchLoop:
        MOV BYTE BL, [BP]               ; 変数サイズ取得
        ADD     BP, 2                   ; 変数名先頭ポインタ = BP + 2

        MACRO_MEMCMP BP, .inName, 8     ; AXに比較結果

        CMP     AX, 0x0000
        JZ      .discoverValue          ; 文字列一致
        SUB     BP, 2

        ADD     BP, BX                  ; 次の変数ポインタを確認
        SUB     BP, 2
        MOV WORD BP, [BP]

        CMP     BP, _NULL
        JZ      .noDiscoverValue        ; チェーンの最後まで見つからなかった
        JMP     .searchLoop             ; まだチェーンの途中なので次行く

.discoverValue:                         ; 発見できた
        SUB     BP, 2                   ; BPを次の変数ポインタから先頭に戻す
        MOV WORD [.aRet], BP
        JMP     .exit
.noDiscoverValue:                       ; 発見できなかった
        MOV WORD [.aRet], 0x0000
        JMP     .exit

.exit:
        CALL    rPopReg                 ; レジスタ取得
        MOV WORD DI, [.aRet]
        RET
.inName:                                ; 変数名(空白埋め8文字+番兵のnull)
        DB      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
.aRet:                                  ; 戻り値
        DW      0x0000
        
; 全レジスタの退避
; 呼んだあと必ず rPopReg を呼ぶこと
; 呼ぶ前 SP <- サブルーチンへのポインタ
; 呼び後 SP <- BP <- DI <- SI <- DX <- CX <- BX <- AX
; in  : reg     レジスタ
; out : なし
                                        ; tempAX    retAddr AX  stack
rPushReg:                               ; ??        ??      AX  ret
        MOV     [.tempAX], AX           ; AX        ??      AX  ret
        POP     AX                      ; AX        ??      ret (空)
        MOV WORD    [.retAddr], AX      ; AX        ret     ret (空)
        MOV     AX, [.tempAX]           ; AX        ret     AX  (空)

        PUSH    AX                      ; AX        ret     AX  AX
        PUSH    BX                      ; AX        ret     AX  BX)AX
        PUSH    CX                      ; AX        ret     AX  CX)BX)AX
        PUSH    DX                      ; AX        ret     AX  DX)CX)BX)AX
        PUSH    SI                      ; AX        ret     AX  SI)DX)CX)BX)AX
        PUSH    DI                      ; AX        ret     AX  DI)SI)DX)CX)BX)AX
        PUSH    BP                      ; AX        ret     AX  BP)DI)SI)DX)CX)BX)AX

        MOV WORD    AX, [.retAddr]      ; AX        ret     AX  BP)DI)SI)DX)CX)BX)AX
        PUSH    AX                      ; AX        ret     ret ret)BP)DI)SI)DX)CX)BX)AX
        MOV     AX, [.tempAX]           ; AX        ret     AX  ret)BP)DI)SI)DX)CX)BX)AX
        RET                             ; AX        ret     ret BP)DI)SI)DX)CX)BX)AX
.tempAX:                                ; AXレジスタを一時的に格納
        DB      0x00, 0x00
.retAddr:                               ; ルーチンのリターンアドレス
        DB      0x00, 0x00

; レジスタの復帰
; 呼ぶ前に必ず rPushReg を呼ぶこと
; 呼ぶ前 SP <- サブルーチンへのポインタ <- BP <- DI <- SI <- DX <- CX <- BX <- AX
; 呼び後 SP
; in  : なし
; out : reg     レジスタ
                                        ; tempAX    retAddr AX  stack
rPopReg:                                ; ??        ??      AX  ret)BP)DI)SI)DX)CX)BX)AX
        POP     AX                      ; ??        ??      ret BP)DI)SI)DX)CX)BX)AX
        MOV WORD    [.retAddr], AX      ; ??        ret     ret BP)DI)SI)DX)CX)BX)AX

        POP     BP                      ; ??        ret     ret DI)SI)DX)CX)BX)AX
        POP     DI                      ; ??        ret     ret SI)DX)CX)BX)AX
        POP     SI                      ; ??        ret     ret DX)CX)BX)AX
        POP     DX                      ; ??        ret     ret CX)BX)AX
        POP     CX                      ; ??        ret     ret BX)AX
        POP     BX                      ; ??        ret     ret AX
        POP     AX                      ; ??        ret     AX  (なし)

        MOV     [.tempAX], AX           ; AX        ret     AX  (なし)
        MOV WORD    AX, [.retAddr]      ; AX        ret     ret (なし)
        PUSH    AX                      ; AX        ret     ret ret
        MOV     AX, [.tempAX]           ; AX        ret     AX  ret
        RET                             ; AX        ret     AX
.tempAX:                                ; AXレジスタを一時的に格納
        DB      0x00, 0x00
.retAddr:                               ; ルーチンのリターンアドレス
        DB      0x00, 0x00

; ビープ音出力
; in : なし
; out: ビープ音
putBeep:
        MOV     AH, 0x0e
        MOV     AL, 0x41
        MOV     BH, 0x00
        MOV     BL, 0x01
        INT     0x10
        RET

; シリアル1文字出力
; in  : AL      ascii
; out : (なし)
dbgSingle:
        CALL    rPushReg                ; レジスタ退避

        MOV     AH, 0x01                ; 書き込み(ALreg)
        MOV     DX, 0x0000
        INT     0x14

        CALL    rPopReg                 ; レジスタ取得
        RET



; デバッグ用ダンプ
; COM1を使って指定番地から指定バイトをダンプする
; in  : AX      ダンプするバイト数
;     : DS:DI   ダンプ開始アドレス
; out : なし
dbgDump:
        CALL    rPushReg                ; レジスタ退避

        MOV     BX, DS
        MOV WORD [.focusSeg], BX
        MOV WORD [.focusAddr], DI
        MOV WORD [.byteCnt], AX

        MOV     AH, 0x00                ; シリアルポート設定
        MOV     AL, 0xe3                ; 0bBBBPPSCC, 9600bps, None, 1bit, 8bit
        MOV     DX, 0x0000              ; 0ch = COM1, xch = COMx+1
        INT     0x14

        MOV     AL, 0x0a                ; 改行文字
        CALL    .putchar

        MOV     CX, 0x0000
.dumpLoop:
        PUSH    CX
        MOV     BX, [.focusSeg]         ; asciiプリント
        MOV     DS, BX
        MOV     DI, [.focusAddr]
        MOV     AL, [DS:DI]

        PUSH    AX
        SHR     AL, 0x04                ; 上4bitプリント
        AND     AL, 0x0f
        CMP     AL, 0x0a
        JAE     .upperaf
        ADD     AL, 0x30                ; 0~9
        JMP     .upperNext
.upperaf:
        ADD     AL, 0x37                ; a~f
.upperNext:
        CALL    .putchar

        POP     AX
        AND     AL, 0x0f                ; 下4bitプリント
        CMP     AL, 0x0a
        JAE     .loweraf
        ADD     AL, 0x30                ; 0~9
        JMP     .lowerNext
.loweraf:
        ADD     AL, 0x37                ; a~f
.lowerNext:
        CALL    .putchar

        MOV     AL, 0x20                ; 空白文字
        CALL    .putchar

        INC     DI
        MOV WORD [.focusAddr], DI
        POP     CX
        INC     CX
        CMP WORD CX, [.byteCnt]
        JNZ     .dumpLoop

        MOV     AL, 0x0d                ; \r
        CALL    .putchar

        MOV     AL, 0x0a                ; \n
        CALL    .putchar

        CALL    rPopReg                 ; レジスタ取得
        RET
.putchar:                               ; 1文字出力(ALreg)
        PUSH    AX
        PUSH    DX
        MOV     AH, 0x01                ; 書き込み
        MOV     DX, 0x0000
        INT     0x14
        POP     DX
        POP     AX
        RET
.focusSeg:                              ; ダンプするセグメント
        DB      0x00, 0x00
.focusAddr:                             ; ダンプするアドレス
        DB      0x00, 0x00
.byteCnt:                               ; ダンプするバイト数
        DB      0x00, 0x00

; レジスタダンプ
; 内部で sysMalloc sysFree dbgDump を使用
; in  : AX, BX, CX, DX, SI, DI, BP, SP, DS, ES, SS
dbgRegDump:
        CALL    rPushReg                ; レジスタ退避
        PUSH    DS

        PUSH    SS
        PUSH    ES
        PUSH    DS
        PUSH    SP
        PUSH    BP
        PUSH    DI
        PUSH    SI
        PUSH    DX
        PUSH    CX
        PUSH    BX
        PUSH    AX

        MOV     CX, 22                  ; メモリ確保
        CALL    sysMalloc
        MOV WORD [.allocAddr], BP

        MOV     AX, 0x0000
        MOV     DS, AX
        MOV     CX, 0x0000
.popLoop:                               ; 2wordずつ格納
        POP     AX
        XOR     AH, AL                  ; リトルエンディアン → ビッグエンディアン
        XOR     AL, AH
        XOR     AH, AL
        MOV WORD [DS:BP], AX
        ADD     BP, 0x0002
        INC     CX
        CMP     CX, 11
        JNZ     .popLoop

        MOV     AX, 22                  ; dbgDump で 表示
        MOV     DI, [.allocAddr]
        CALL    dbgDump

        MOV WORD BP, [.allocAddr]       ; メモリ解放
        CALL    sysFree

        POP     DS
        CALL    rPopReg                 ; レジスタ取得
        RET
.allocAddr:
        DB      0x00, 0x00

; 16ビット値をシリアル出力
; in  : AX      出力する値
dbgPrint16bit:
        ; 確保したポインタを表示テスト
        CALL    rPushReg
        
        MOV     SI, .aDebugStr

        MOV     BX, 0x00                ; "0x"なし
        CALL    libitox                 ; AXレジスタの値を4文字に変換

        MOV     CX, 0x0000
.debugLoop:
        MOV     SI, .aDebugStr
        ADD     SI, CX
        MOV BYTE AL, [SI]

        CALL    dbgSingle               ; ALを出力

        CMP     CX, 0x0003
        JZ      .debugNext
        ADD     CX, 0x0001
        JMP     .debugLoop

.debugNext:        
        MOV     AL, 0x0a                ; 改行
        CALL    dbgSingle

        CALL    rPopReg
        RET

.aDebugStr:
        DB      0x00, 0x00, 0x00, 0x00

mashHlt:
        JMP     mashHlt

; --- 0埋め ---
secEnd:
        times 0x4000-($-$$) DB 0        ; mash常駐は16セクタ

%endif  ; __MASH_ASM
