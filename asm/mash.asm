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
        DB      "mash system v0.5.0"

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

; シェル変数関連
sTopValAddr:
        DW      0x0000                  ; シェル変数の連結リストの先頭アドレス

; 現在アクティブなセクタ
sActiveSector:
        DW      0x0000

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

        ; アクティブセクタをrootに設定
        MOV WORD [sActiveSector], DIR_BIN

        ; デバッグ ---->
                ;MOV     AH, 0x00                ; テスト変数
                ;MOV     SI, .aTestValue01
                ;CALL    sysDim                  ; 定義

                ;MOV     AH, 0x10                ; テスト変数
                ;MOV     AL, 3                   ; 要素数は3
                ;MOV     SI, .aTestValue02
                ;CALL    sysDim                  ; 定義

                ;MOV     AH, 0x01                ; テスト変数
                ;MOV     SI, .aTestValue03
                ;CALL    sysDim                  ; 定義

                ;MOV     AH, 0x02                ; テスト変数
                ;MOV     SI, .aTestValue04
                ;CALL    sysDim                  ; 定義

                ;MOV     AH, 0x12                ; テスト変数
                ;MOV     AL, 0x15                ; 要素数は3
                ;MOV     SI, .aTestValue05
                ;CALL    sysDim    

                ;CALL    sysList                 ; 一覧表示
        ; <----

        ; デバッグ ---->
                ;MOV     CX, 512                 ; メモリ確保
                ;CALL    sysMalloc

                ;MOV     SI, BP                  ; セクタ読み込み
                ;MOV     AX, 0x0013
                ;CALL    libReadSector

                ;MOV     CX, 0x0012              ; 編集
                ;MOV     AH, 0x00
                ;CALL    libDiskBitSet

                ;MOV     CX, 0x0023
                ;MOV     AH, 0x01
                ;CALL    libDiskBitSet

                ;MOV     AX, 0x0013              ; セクタ書き込み
                ;CALL    libWriteSector

                ;MOV     CX, 0x0023              ; ダミー
                ;MOV     AH, 0x00
                ;CALL    libDiskBitSet

                ;MOV     AX, 0x0013              ; セクタ再度読み込み
                ;CALL    libReadSector

                ;MOV     CX, 0x0000
        ;.testLoop:
                ;CALL    libDiskBitGet

                ;MOV     AL, AH
                ;ADD     AL, 0x30
                ;CALL    libPutchar
                ;CALL    libSetCursolNextCol

                ;INC     CX
                ;CMP     CX, 64
                ;JNZ     .testLoop
        ;.testHlt:
                ;JMP     .testHlt
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
        ; デバッグ(512バイト)
        ;DEBUG_REGISTER_DUMP 0x0100, 0x8000
        
        CALL    sysInputCommand         ; コマンドライン入力受け付け

        MOV     SI, sOneLineBuf
        CALL    sysInputParseToken      ; コマンドライン引数に分離
        CALL    sysCheckAndRunCommand   ; コマンドの実行
        CALL    sysReleaseToken         ; コマンドライン引数の解放

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

; dim
; __argc : 3 or 4
; __argv0: "dim"固定
; __argv1: 変数型
;               符号なし16bit整数: "uint"
;               符号付き16bit整数: "sint"
;               文字(符号なし8bit整数): "char"
;               uint配列: "array"
;               char配列: "string"
; __argv2: 要素数(array, string時のみ有効)
;               "0" ~ "255"の範囲
; __argv3: 変数名
;               最大8文字まで、"__"からは宣言不可
comDim:
        CALL    rPushReg

        ; コマンドライン引数の個数を確認
        CALL    sysGetCmdLineCnt        ; __argcをセット
        MOV     SI, BP
        CALL    sysShellGet             ; DIに変数の内容の先頭ポインタが返却
        ADD     DI, 10
        MOV WORD DI, [DI]
        CMP     DI, 0x0003
        JZ      .cntOK
        CMP     DI, 0x0004
        JZ      .cntOK
        JMP     .cntNG

.cntNG:                                 ; コマンドライン引数の個数が異常
        JMP     .cntNG                  ; 一旦

.cntOK:
        ; 入力コマンドライン引数の整備
        MOV     AL, 1                   ; __argv1にセット
        CALL    sysSetCmdLineStr
        CALL    sysGetCmdLineStr        ; BPに変数ポインタが返却
        MOV     SI, BP
        CALL    sysShellGet             ; DIに変数の内容の先頭ポインタが返却

        ADD     DI, 11
        MOV WORD SI, DI           ; 格納
.checkTypeUint:
        MOV WORD DI, .aStrUint          ; uint
        CALL    libStrcmp
        CMP     AX, 0x0000
        JNZ     .checkTypeSint
        MOV BYTE [.aType], 0x00
        MOV     AL, 2                   ; uint の場合変数名は __argv2
        JMP     .checkTypeNext
.checkTypeSint:
        MOV WORD DI, .aStrSint          ; sint
        CALL    libStrcmp
        CMP     AX, 0x0000
        JNZ     .checkTypeChar
        MOV BYTE [.aType], 0x01
        MOV     AL, 2
        JMP     .checkTypeNext
.checkTypeChar:
        MOV WORD DI, .aStrChar          ; char
        CALL    libStrcmp
        CMP     AX, 0x0000
        JNZ     .checkTypeArray
        MOV BYTE [.aType], 0x02
        MOV     AL, 2
        JMP     .checkTypeNext
.checkTypeArray:
        MOV WORD DI, .aStrArray         ; array
        CALL    libStrcmp
        CMP     AX, 0x0000
        JNZ     .checkTypeString
        MOV BYTE [.aType], 0x10
        CALL    .checkLen               ; 要素数を格納
        MOV     AL, 3                   ; array の場合変数名は __argv3
        JMP     .checkTypeNext
.checkTypeString:
        MOV WORD DI, .aStrString        ; string
        CALL    libStrcmp
        CMP     AX, 0x0000
        JNZ     .checkTypeError
        MOV BYTE [.aType], 0x12
        CALL    .checkLen               ; 要素数を格納
        MOV     AL, 3
        JMP     .checkTypeNext
.checkTypeError:                        ; 異常入力
        JMP     .checkTypeError         ; 一旦

.checkLen:
        ; argv2の整数化
        MOV     AL, 2                   ; __argv2にセット
        CALL    sysSetCmdLineStr
        CALL    sysGetCmdLineStr        ; BPに変数ポインタが返却
        MOV     SI, BP
        CALL    sysShellGet             ; DIに変数の内容の先頭ポインタが返却
        ADD     DI, 11

        MOV     SI, DI
        CALL    libdtoi                 ; 変換結果をAXに格納(sint用なので 0=0x8000 )
        SUB     AX, 0x8000
        ; デバッグ ---->
                ;PUSH    AX
                ;MOV WORD AX, AX
                ;CALL    dbgPrint16bit           ; デバッグ
                ;POP     AX
        ;.dbgHlt:
                ;JMP     .dbgHlt
        ; <----
        MOV BYTE [.aLen], AL
        RET

.checkTypeNext:
        CALL    sysSetCmdLineStr        ; ALにすでに格納済み
        CALL    sysGetCmdLineStr        ; BPに変数ポインタが返却
        MOV     SI, BP
        CALL    sysShellGet             ; DIに変数の内容の先頭ポインタが返却
        ADD     DI, 11
        MOV     SI, DI

        ; コピー(ヌル文字を含む場合表示に無理が出るため" "に変換する)
        MOV WORD DI, .aName
        MOV     BH, 0x00                ; フラグはたたんでおく
        MOV     CX, 0x0000
.copyLoop:
        MOV BYTE AH, [SI]

        CMP     AH, 0x00                ; ヌル文字を発見移行は全て空白文字で埋める
        JNZ     .copyFill               ; フラグはBHレジスタ
        MOV     BH, 0x01                ; フラグセット
.copyFill:
        CMP     BH, 0x01                ; フラグが立っていれば空白文字に置換
        JNZ     .copyComfirm
        MOV     AH, " "
.copyComfirm:                           ; 格納
        MOV BYTE [DI], AH

        INC     CX
        CMP     CX, 0x0008              ; 8バイトコピーしたら終了
        JZ      .copyNext
        INC     SI
        INC     DI
        JMP     .copyLoop

.copyNext:
        ; コマンドの実行
        MOV BYTE AH, [.aType]
        MOV BYTE AL, [.aLen]
        MOV WORD SI, .aName
        CALL    sysDim                  ; 実行

        CALL    rPopReg
        RET
.aType:                                 ; 変数型
        DB      0x00
.aLen:                                  ; 配列の長さ
        DB      0x00
.aName:                                 ; 変数名の即値
        DB      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
.aStrUint:                              ; 変数タイプのリファレンス
        DB      "uint", 0x00
.aStrSint:
        DB      "sint", 0x00
.aStrChar:
        DB      "char", 0x00
.aStrArray:
        DB      "array", 0x00
.aStrString:
        DB      "string", 0x00

; undim
; __argc : 2
; __argv0: "dim"固定
; __argv1: 変数名
;               最大8文字まで、"__"からは宣言不可
comUndim:
        CALL    rPushReg

        ; コマンドライン引数の個数を確認
        CALL    sysGetCmdLineCnt        ; __argcをセット
        MOV     SI, BP
        CALL    sysShellGet             ; DIに変数の内容の先頭ポインタが返却
        ADD     DI, 10
        MOV WORD DI, [DI]
        CMP     DI, 0x0002
        JZ      .cntOK
        JMP     .cntNG

.cntNG:                                 ; コマンドライン引数の個数が異常
        JMP     .cntNG                  ; 一旦

.cntOK:
        ; コピー(ヌル文字を含む場合表示に無理が出るため" "に変換する)
        MOV     AL, 1
        CALL    sysSetCmdLineStr        ; ALにすでに格納済み
        CALL    sysGetCmdLineStr        ; BPに変数ポインタが返却
        MOV     SI, BP
        CALL    sysShellGet             ; DIに変数の内容の先頭ポインタが返却
        ADD     DI, 11
        MOV     SI, DI

        MOV WORD DI, .aName
        MOV     BH, 0x00                ; フラグはたたんでおく
        MOV     CX, 0x0000
.copyLoop:
        MOV BYTE AH, [SI]

        CMP     AH, 0x00                ; ヌル文字を発見移行は全て空白文字で埋める
        JNZ     .copyFill               ; フラグはBHレジスタ
        MOV     BH, 0x01                ; フラグセット
.copyFill:
        CMP     BH, 0x01                ; フラグが立っていれば空白文字に置換
        JNZ     .copyComfirm
        MOV     AH, " "
.copyComfirm:                           ; 格納
        MOV BYTE [DI], AH

        INC     CX
        CMP     CX, 0x0008              ; 8バイトコピーしたら終了
        JZ      .copyNext
        INC     SI
        INC     DI
        JMP     .copyLoop

.copyNext:
        MOV WORD SI, .aName
        CALL    sysUndim

        CALL    rPopReg
        RET
.aName:                                 ; 変数名の即値
        DB      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

; set
; __argc : 2
; __argv0: "set"固定
; __argv1: 変数名
; __argv2: 要素数(array, string時のみ有効)
;               "0" ~ "255"の範囲
; __argv3: セットする数
;               0x????: 16進整数
;               ?????: 10進整数
;               "?": 文字
comSet:
        CALL    rPushReg

        ; コマンドライン引数の個数を確認

        ; セットする数(__argv3)を取得
        MOV     AL, 3                   ; __argv3にセット
        CALL    sysSetCmdLineStr
        CALL    sysGetCmdLineStr        ; BPに変数ポインタが返却
        MOV     SI, BP
        CALL    sysShellGet             ; DIに変数の内容の先頭ポインタが返却

        ADD     DI, 11
        MOV WORD SI, DI                 ; SIにセットする数を表した文字列を格納

        ; 文字列 → 数値
        CALL    libstoi                 ; in=SI, out=AX
        PUSH    AX                      ; ->数値

        ; システムコールの形に整形

        ; セットする変数名(__argv1)を取得
        MOV     AL, 1                   ; __argv1にセット
        CALL    sysSetCmdLineStr
        CALL    sysGetCmdLineStr        ; BPに変数ポインタが返却
        MOV     SI, BP
        CALL    sysShellGet             ; DIに変数の内容の先頭ポインタが返却

        ADD     DI, 11
        MOV WORD SI, DI                 ; SIにセットする数を表した文字列を格納
        PUSH    SI                      ; ->変数名

        ; 要素数(__argv2)を取得
        MOV     AL, 2                   ; __argv2にセット
        CALL    sysSetCmdLineStr
        CALL    sysGetCmdLineStr        ; BPに変数ポインタが返却
        MOV     SI, BP
        CALL    sysShellGet             ; DIに変数の内容の先頭ポインタが返却

        ADD     DI, 11
        MOV WORD SI, DI                 ; SIにセットする数を表した文字列を格納(まだ文字列！)
        CALL    libdtoi                 ; 10進文字列 -> バイナリ変換
        PUSH    AX                      ; ->要素数

        ; SI 変数名
        ; AL 要素番号
        ; BX 格納値
        POP     AX                      ; <-要素数
        POP     SI                      ; <-変数名
        POP     BX                      ; <-格納値
        CALL    sysSet                  ; システムコール

        CALL    rPopReg
        RET

; echo
comEcho:
        CALL    rPushReg
        CALL    rPopReg
        RET

; list
; __argc  : 制限なし
; __argv0 : "list"固定
; __argv1~argv9: テストもかねてそのまま表示
comList:
        CALL    rPushReg

        CALL    sysList                 ; 実行

        CALL    rPopReg
        RET

; pwd
comPwd:
        CALL    rPushReg
        CALL    rPopReg
        RET

; dir
; __argc  : 制限なし
; __argv0 : "dir"固定
; __argv1~argv9: 考慮しない
comDir:
        CALL    rPushReg

        CALL    sysDir

        CALL    rPopReg
        RET

; cd
comCd:
        CALL    rPushReg
        CALL    rPopReg
        RET

; mkdir
comMkdir:
        CALL    rPushReg
        CALL    rPopReg
        RET

; rmdir
comRmdir:
        CALL    rPushReg
        CALL    rPopReg
        RET

; mkfile
comMkfile:
        CALL    rPushReg
        CALL    rPopReg
        RET

; rmfile
comRmfile:
        CALL    rPushReg
        CALL    rPopReg
        RET

; rename
comRename:
        CALL    rPushReg
        CALL    rPopReg
        RET

; cat
comCat:
        CALL    rPushReg
        CALL    rPopReg
        RET

; cls
comCls:
        CALL    rPushReg
        CALL    rPopReg
        RET

; lift
comLift:
        CALL    rPushReg
        CALL    sysLift
        CALL    rPopReg
        RET

; //////////////////////////////////////////////////////////////////////////// ;
; --- システムコール ---
;  ██████╗██╗   ██╗ ██████╗      ██████╗ █████╗ ██╗     ██╗     
; ██╔════╝╚██╗ ██╔╝██╔════╝     ██╔════╝██╔══██╗██║     ██║     
; ╚█████╗  ╚████╔╝ ╚█████╗      ██║     ██║  ██║██║     ██║     
;  ╚═══██╗  ╚██╔╝   ╚═══██╗     ██║     ███████║██║     ██║     
; ██████╔╝   ██║   ██████╔╝     ╚██████╗██║  ██║███████╗███████╗
; ╚═════╝    ╚═╝   ╚═════╝       ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝
; //////////////////////////////////////////////////////////////////////////// ;

; コマンドライン引数を複数用意すると冗長なためまとめる ---->

; static変数
sCmdLineStr:                            ; コマンドライン引数のためのひな形
        DB      "__argv"
sCmdLineID:                             ; コマンドライン引数の __argv"x" の x の部分
        DB      "0 ", 0x00

sCmdLineCnt:                            ; コマンドライン引数の個数を記録している変数型
        DB      "__argc  ", 0x00

; static変数へのインターフェース

; コマンドライン引数の変数名セット
; __argv0 ~ __argv9 のうち、任意の一桁の内容に変数名を更新する
; in  : AL      更新するナンバリング
;               0x00 ~ 0x09: 変更可能
;               0x0a ~ : 変更不可(エラー返却)
sysSetCmdLineStr:
        CALL    rPushReg

        ; 入力パラメータ確認
        CMP     AL, 0x09
        JA      .exit                   ; 0~9 の範囲外の場合変更せず終了

        ADD     AL, "0"
        MOV BYTE [sCmdLineID], AL       ; 更新

.exit:
        CALL    rPopReg
        RET

; コマンドライン引数の変数名ゲット
; 設定したコマンドライン引数の内容を返却する
; in  : なし
; out : BP      コマンドライン変数名の先頭ポインタ
sysGetCmdLineStr:
        MOV WORD BP, sCmdLineStr
        RET

; コマンドライン引数の個数をゲット
; in  : なし
; out : BP      
sysGetCmdLineCnt:
        MOV WORD BP, sCmdLineCnt
        RET

; <---- コマンドライン引数を複数用意すると冗長なためまとめた

; dim コマンド内部制御
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
        MOV     BX, 0x00
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
        ;MOV BYTE CH, [.aRet]
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

; undim コマンド内部制御
; シェル変数を解放する
; [hed1 val1 btm1] -> [hed2 val2 btm2] -> [hed3 val3 btm3]
; ↓
; [hed1 val1 btm2] -> (hed2 val2 btm2) -> [hed3 val3 btm3]
; in  : SI      解放する変数文字列先頭アドレス
; out : なし
sysUndim:
        CALL    rPushReg                ; レジスタ退避

        MOV WORD [.aBottom1], sTopValAddr       ; 最初のポインタ(0x4100)

        ; 変数を間引いて解放
.searchLoop:
        ; 次のポインタを格納
        MOV WORD BP, [.aBottom1]        ; (BP:0x4100)
        MOV WORD BP, [BP]               ; (BP:[0x4100]=0x8030)
        MOV WORD [.aHead2], BP
        MOV     BH, 0x00
        MOV BYTE BL, [BP]               ; (BP:[0x8030]=変数のサイズ)
        ADD     BP, BX
        SUB     BP, 2                   ; 構造体サイズ-2と-1に次のポインタ
        MOV WORD [.aBottom2], BP        ; 格納

        ; 変数名の比較
        MOV WORD BP, [.aBottom1]
        MOV WORD BP, [BP]
        ADD     BP, 2                   ; 変数構造体の3バイト目から8文字が変数名
        MACRO_MEMCMP SI, BP, 8          ; 比較結果はAX
        CMP     AX, 0x0000
        JZ      .searchNext             ; 一致すれば消す
        
        ; チェーンの最後まで見つからなければ終了
        MOV WORD BP, [.aBottom1]
        MOV WORD BP, [BP]
        MOV     AX, BP
        CMP     AX, 0x0000
        JZ      .searchNotFound

        ; 一致しなければ次へ
        MOV WORD AX, [.aBottom2]
        MOV WORD [.aBottom1], AX
        JMP     .searchLoop

.searchNotFound:
        JMP     .exit                   ; 一旦

.searchNext:
        ; チェーンの復元
        MOV WORD BP, [.aBottom2]        ; 変数2の末尾の住所
        MOV WORD BP, [BP]               ; 変数2の末尾の住所に書かれている値(=変数3の住所)
        MOV WORD SI, [.aBottom1]        ; 変数1の末尾の住所
        MOV WORD [SI], BP               ; 変数1の末尾の住所に書かれている値を変数2の末尾の住所に書かれている値に書き換える

        ; メモリの解放
        MOV WORD BP, [.aHead2]
        CALL    sysFree                 ; Head2の解放
        JMP     .exit

.exit:
        CALL    rPopReg                 ; レジスタ取得
        RET
.aBottom1:                              ; 消す１つ前の変数のチェーンアドレスが格納されているアドレス
        DW      0x0000
.aHead2:                                ; 消す変数が格納されているアドレス
        DW      0x0000
.aBottom2:                              ; 消す変数のチェーンアドレスが格納されているアドレス
        DW      0x0000

; set コマンド内部制御
; シェル変数の値を更新する
; in  : SI      変数文字列先頭アドレス
;       AL      要素数(配列型の場合のみ有効)
;               stringの場合: ALバイトだけ先頭から書き込む
;               arrayの場合: AL要素目に書き込む
;       BX      uint, sint, array の場合: 設定即値
;               char の場合: 即値設定(BHのみ考慮)
;               str の場合: 設定する先頭ポインタ
; out : CH      エラーコード
sysSet:
        ; デバッグ---->
                ;PUSH    AX
                ;MOV WORD AX, BX
                ;CALL    dbgPrint16bit           ; デバッグ
                ;POP     AX
        ; <----

        CALL    rPushReg                ; レジスタ退避
        MOV WORD [.aValue], BX

        ; 変数構造体を取得
        CALL    sysShellGet
        MOV WORD [.aAddress], DI        ; 発見した変数のポインタを格納する
        INC     DI
        MOV     AH, [DI]
        MOV     [.aType], AH            ; 発見した変数の型を格納する

        ; シェルから入力された文字列を数値に変換する
        MOV BYTE AH, [.aType]
        CMP     AH, 0x00
        JZ      .setUint
        CMP     AH, 0x01
        JZ      .setSint
        CMP     AH, 0x02
        JZ      .setChar
        CMP     AH, 0x10
        JZ      .setArr
        CMP     AH, 0x12
        JZ      .setStr
        JMP     .setError

        ; 数値をセットする
.setUint:                               ; 16bit整数
.setSint:
        MOV WORD BP, [.aAddress]
        ADD     BP, 10
        MOV WORD BX, [.aValue]
        MOV WORD [BP], BX               ; 2バイト
        JMP     .exit

.setChar:                               ; 8bit整数
        MOV WORD BP, [.aAddress]
        ADD     BP, 10
        MOV WORD BX, [.aValue]
        MOV BYTE [BP], BH               ; 1バイト
        JMP     .exit

.setArr:                                ; 16bit配列
        MOV WORD BP, [.aAddress]
        ADD     BP, 10                  ; 配列のサイズは構造体11バイト目から
        MOV     AL, [BP]
        SHL     AL, 1
        MOV     AH, 0x00
        INC     BP                      ; 配列の先頭ポインタは12バイト目から

        MOV WORD BX, [.aValue]

        MACRO_MEMCPY BP, BX, AX
        JMP     .exit

.setStr:                                ; 8bit配列(部分操作不可)
        MOV WORD BP, [.aAddress]
        ADD     BP, 10                  ; 配列のサイズは構造体11バイト目から
        MOV     AH, 0x00
        MOV     AL, [BP]
        INC     BP                      ; 配列の先頭ポインタは12バイト目から

        MOV WORD BX, [.aValue]

        MACRO_MEMCPY BP, BX, AX
        JMP     .exit

.setError:
        JMP     .exit

.exit:
        CALL    rPopReg                 ; レジスタ取得
        RET
.aAddress:
        DW      0x0000
.aValue:
        DW      0x0000
.aType:
        DW      0x00

; list コマンド内部制御
; シェル変数のチェーンを列挙する
; in  : なし
; out : なし
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
        MOV     BH, 0x01
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
        ADD     BP, 11
        MOV BYTE AH, [BP]

        MOV     AL, 0x22                ; 最初の "
        CALL    libPutchar
        CALL    libSetCursolNextCol
.aPrintStringLoop:
        ; この時点で BPには文字列の先頭ポインタ、 AHには残り表示文字数
        MOV BYTE AL, [BP]               ; 1文字表示

        DEC     AH                      ; 次の1文字にフォーカス
        INC     BP

        ; null文字が来るか、変数の最後まで到達したら終わり
        CMP     AH, 0x00
        JZ      .aPrintStringNext       ; 回数をこなしたら終了
        CMP     AL, 0x00
        JZ      .aPrintStringNext       ; null文字が来たら終了

        CALL    libPutchar
        CALL    libSetCursolNextCol

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
        MOV     BH, 0x00
        MOV BYTE BL, [BP]
        MOV     AX, BP
        ADD     AX, BX
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
        DB      "uint", 0x00
.aLabel_array:
        DB      "array", 0x00
.aLabel_sint:
        DB      "sint", 0x00
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
; lift コマンド内部制御
; ジョークコマンド
sysLift:
        CALL    rPushReg

        ; フレームの表示
        MOV     CH, 0x00
        MOV     CL, 0x00
        MOV     BP, .aFlame
.printFlameLoop:
        MOV BYTE AL, [BP]
        CALL    libPutchar              ; 1行表示
        CALL    libSetCursolNextCol     ; 次の列へ
        INC     BP

        INC     CL
        CMP     CL, 27
        JNZ     .printFlameNext
        MOV     CL, 0x00
        CALL    libSetCursolNextLine    ; 次の行へ

        INC     CH
        CMP     CH, 13
        JNZ     .printFlameNext
        JMP     .printFlameBreak

.printFlameNext:
        JMP     .printFlameLoop
        
.printFlameBreak:
        MOV     BP, .aDoor1

        MOV BYTE AH, [sYpos]            ; 座標を更新
        SUB     AH, 11
        MOV BYTE [sYpos], AH

; スプライトのループ
        MOV     CH, 0x00
.printContentLoop:
        MOV     SI, .aMona
        ; 1行のループ
        MOV     CL, 0x00
        .printContentLineLoop:
                MOV BYTE AH, [sYpos]
                MOV     AH, 7                   ; 座標を更新
                MOV BYTE [sXpos], AH

                ; 1文字のループ
                MOV     DH, 0x00
                .printContentSingle:
                        MOV BYTE AL, [BP]
                        CMP     AL, " "
                        JZ      .printMona
                        CALL    libPutchar              ; 1行表示
                        CALL    libSetCursolNextCol     ; 次の列へ
                        JMP     .singleNext
                .printMona:
                        MOV BYTE AL, [SI]
                        CALL    libPutchar              ; 1行表示
                        CALL    libSetCursolNextCol     ; 次の列へ
                        JMP     .singleNext

                .singleNext:
                        INC     DH
                        CMP     DH, 13                  ; 1行=13列
                        JZ      .printContentSingleNext
                        INC     BP
                        INC     SI
                        JMP     .printContentSingle
                
        .printContentSingleNext:
                INC     SI
                SUB     BP, 12
                INC     CL
                CMP     CL, 9                   ; 1スプライト=9行
                JZ      .printContentLineNext
                MOV BYTE AH, [sYpos]
                INC     AH
                MOV BYTE [sYpos], AH
                JMP     .printContentLineLoop

.printContentLineNext:
        ADD     BP, 13                  ; 次のスプライトへ

        ; デバッグ---->
                ;PUSH    AX
                ;MOV     AH, 0x00
                ;INT     0x16            ; 文字入力を待つ
                ;POP     AX
        ; <----
        
        CALL    rWait1sec

        INC     CH
        CMP     CH, 8                   ; 1コマンド=スプライト7枚
        JZ      .printContentNext
        MOV BYTE AH, [sYpos]            ; 座標を更新
        SUB     AH, 8
        MOV BYTE [sYpos], AH
        JMP     .printContentLoop

.printContentNext:
        CALL    libSetCursolNextLine
        CALL    libSetCursolNextLine
        CALL    libSetCursolNextLine
        JMP     .exit   ;一旦

.exit:
        CALL    rPopReg
        RET
.aFlame:
        DB      0x20, 0x20, 0x20, 0x20, 0xda, 0xc4, 0xc4, 0xc4, 0xc4, 0xc4, 0xc4, 0xc4, 0xc4, 0xc4, 0xc4, 0xc4, 0xc4, 0xc4, 0xc4, 0xc4, 0xc4, 0xc4, 0xbf, 0x20, 0x20, 0x20, 0x20      ;    ┌─────────────────┐
        DB      0x20, 0x20, 0x20, 0x20, 0xb3, 0x2c, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x2c, 0xb3, 0x20, 0x20, 0x20, 0x20      ;    │,_______________,│
        DB      0x20, 0x20, 0x20, 0x20, 0xb3, 0xb3, 0xb3, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0xb3, 0xb3, 0xb3, 0x20, 0x20, 0x20, 0x20      ;    │││             │││
        DB      0x20, 0x20, 0x20, 0x20, 0xb3, 0xb3, 0xb3, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0xb3, 0xb3, 0xb3, 0x20, 0x20, 0x20, 0x20      ;    │││             │││
        DB      0x20, 0x20, 0x20, 0x20, 0xb3, 0xb3, 0xb3, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0xb3, 0xb3, 0xb3, 0x20, 0x20, 0x20, 0x20      ;    │││             │││
        DB      0x20, 0x20, 0x20, 0x20, 0xb3, 0xb3, 0xb3, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0xb3, 0xb3, 0xb3, 0x20, 0xda, 0xc4, 0xbf      ;    │││             │││ ┌─┐
        DB      0x20, 0x20, 0x20, 0x20, 0xb3, 0xb3, 0xb3, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0xb3, 0xb3, 0xb3, 0x20, 0xb3, 0x1e, 0xb3      ;    │││             │││ │^│
        DB      0x20, 0x20, 0x20, 0x20, 0xb3, 0xb3, 0xb3, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0xb3, 0xb3, 0xb3, 0x20, 0xb3, 0x20, 0xb3      ;    │││             │││ │ │
        DB      0x20, 0x20, 0x20, 0x20, 0xb3, 0xb3, 0xb3, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0xb3, 0xb3, 0xb3, 0x20, 0xb3, 0x1f, 0xb3      ;    │││             │││ │v│
        DB      0x20, 0x20, 0x20, 0x20, 0xb3, 0xb3, 0xb3, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0xb3, 0xb3, 0xb3, 0x20, 0xc0, 0xc4, 0xd9      ;    │││             │││ └─┘
        DB      0x20, 0x20, 0x20, 0x20, 0xb3, 0xb3, 0xb3, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0xb3, 0xb3, 0xb3, 0x20, 0x20, 0x20, 0x20      ;    │││             │││
        DB      0x20, 0x20, 0x20, 0x20, 0xb3, 0xb3, 0xb3, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0xb3, 0xb3, 0xb3, 0x20, 0x20, 0x20, 0x20      ;    │││_____________│││
        DB      0x5f, 0x5f, 0x5f, 0x5f, 0xb3, 0xb3, 0x2f, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x5c, 0xb3, 0xb3, 0x5f, 0x5f, 0x5f, 0x5f      ;____││/             \││____
.aDoor1:
        DB      0x3a, 0x3a, 0x3a, 0x3a, 0x3a, 0x3a, 0xb3, 0x3a, 0x3a, 0x3a, 0x3a, 0x3a, 0x3a
.aDoor2:
        DB      0x3a, 0x3a, 0x3a, 0x3a, 0x3a, 0xb3, 0x20, 0xb3, 0x3a, 0x3a, 0x3a, 0x3a, 0x3a
.aDoor3:
        DB      0x3a, 0x3a, 0x3a, 0x3a, 0xb3, 0x20, 0x20, 0x20, 0xb3, 0x3a, 0x3a, 0x3a, 0x3a
.aDoor4:
        DB      0x3a, 0x3a, 0x3a, 0xb3, 0x20, 0x20, 0x20, 0x20, 0x20, 0xb3, 0x3a, 0x3a, 0x3a
.aDoor5:
        DB      0x3a, 0x3a, 0xb3, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0xb3, 0x3a, 0x3a
.aDoor6:
        DB      0x3a, 0xb3, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0xb3, 0x3a
.aDoor7:
        DB      0xb3, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0xb3
.aDoor8:
        DB      0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
.aMona:
        DB      0xda, 0xc4, 0xc4, 0xc4, 0xc4, 0xc4, 0xc4, 0xc4, 0xc4, 0xc4, 0xc4, 0xbf, 0x20 ;┌──────────┐
        DB      0xb3, 0x6d, 0x69, 0x73, 0x73, 0x20, 0x69, 0x6e, 0x70, 0x75, 0x74, 0xb3, 0x20 ;│miss input│
        DB      0xb3, 0x61, 0x73, 0x20, 0x22, 0x6c, 0x69, 0x73, 0x74, 0x22, 0x3f, 0xb3, 0x20 ;│as "list"?│
        DB      0xc0, 0xc4, 0xc4, 0xc4, 0x76, 0xc4, 0xc4, 0xc4, 0xc4, 0xc4, 0xc4, 0xd9, 0x20 ;└───v──────┘
        DB      0x20, 0x20, 0x5e, 0x5f, 0x5f, 0x5f, 0x5e, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20 ;  ^___^
        DB      0x20, 0x28, 0x20, 0x20, 0xf8, 0x2d, 0xf8, 0x29, 0x20, 0x20, 0x20, 0x20, 0x20 ; (  °-°)
        DB      0x20, 0x28, 0xb3, 0x20, 0x20, 0x20, 0xb3, 0x29, 0x20, 0x20, 0x20, 0x20, 0x20 ; (|   |)
        DB      0x7e, 0x7e, 0xb3, 0x20, 0x20, 0x20, 0xb3, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20 ;~~|   |
        DB      0x20, 0x28, 0x5f, 0x5f, 0x29, 0x5f, 0x5f, 0x29, 0x20, 0x20, 0x20, 0x20, 0x20 ; (__)__)   

rWait1sec:
                ; 1秒待つ
        PUSH    AX
        PUSH    CX
        PUSH    DX

        MOV     AH, 0x01
        MOV     CX, 0x0000
        MOV     DX, 0x0000
        INT     0x1a

.timeLoop:
        MOV     AH, 0x00
        INT     0x1a
        CMP     DX, 20
        JZ      .timeNext
        JMP     .timeLoop

.timeNext:
        POP     DX
        POP     CX
        POP     AX
        RET

; dir コマンド内部制御
; 現在のディレクトリのフォルダ、ファイルを表示する
sysDir:
        CALL    rPushReg                ; レジスタ退避

        ; 現在アクティブなセクタを読み込む
        MOV     CX, 512                 ; メモリ確保
        CALL    sysMalloc
        MOV WORD [.aActiveSector], BP

        MOV WORD SI, [.aActiveSector]   ; セクタ読み込み
        MOV WORD AX, [sActiveSector]
        CALL    libReadSector

        ; 子ディレクトリの数を取得する
        MOV WORD SI, [.aActiveSector]
        ADD     SI, 26
        MOV BYTE CH, [SI]
        PUSH    CX
        INC     SI

        ; 各子ディレクトリのセクタを読み込みディレクトリ名を取得する
        ; 子ディレクトリ１つずつに対し処理
.dirLoop:
        POP     CX                      ; ループ終了チェック
        CMP     CH, 0x00
        JZ      .exit
        DEC     CH
        PUSH    CX

        PUSH    SI
        MOV WORD AX, [SI]               ; セクタ番号を取得

        MOV     CX, 512                 ; メモリ確保
        CALL    sysMalloc
        MOV WORD [.aSubSector], BP

        MOV WORD SI, [.aSubSector]      ; 子ディレクトリのセクタを読み出す
        CALL    libReadSector

        ADD     SI, 1                   ; ファイル名を表示
        MOV     BP, SI
        CALL    libPutsNoCRLF

        MOV     AL, "."                 ; ピリオドを表示
        CALL    libPutchar
        CALL    libSetCursolNextCol

        ADD     SI, 8                   ; 拡張子を表示(3文字)
        MOV BYTE AL, [SI]
        CALL    libPutchar
        CALL    libSetCursolNextCol

        INC     SI
        MOV BYTE AL, [SI]
        CALL    libPutchar
        CALL    libSetCursolNextCol

        INC     SI
        MOV BYTE AL, [SI]
        CALL    libPutchar
        CALL    libSetCursolNextCol
        CALL    libSetCursolNextLine

        MOV WORD BP, [.aSubSector]      ; 子ディレクトリのメモリ解放
        CALL    sysFree

        POP     SI                      ; 次のディレクトリへ
        ADD     SI, 2

        JMP     .dirLoop

.exit:
        CALL    rPopReg                 ; レジスタ取得
        RET
.aActiveSector:
        DB      0x00, 0x00
.aSubSector:
        DB      0x00, 0x00

; pwd コマンド内部制御
; 現在のディレクトリを標準出力に渡す
sysPwd:
        CALL    rPushReg                ; レジスタ退避
        CALL    rPopReg                 ; レジスタ取得
        RET

; echo コマンド内部制御
; 文字列の表示(エスケープシーケンスあり)
; in  : BP      表示する文字列の先頭ポインタ
; out : 画面表示
sysEcho:
        CALL    rPushReg                ; レジスタ退避
        CALL    rPopReg                 ; レジスタ取得
        RET

; コマンドライン入力
; 256文字までとする
; in  : (なし、キーボードから)
; out : (なし、バッファへ)
sysInputCommand:
        CALL    rPushReg

        MOV     AL, "\"        
        CALL    libPutchar
        CALL    libSetCursolNextCol
        MOV     AL, ">"
        CALL    libPutchar
        CALL    libSetCursolNextCol
.inputLoop:
        CALL    rOneLineInput           ; キーボード入力 → バッファ+出力
        CMP     AH, 0x00
        JZ      .inputLoop              ; 続ける

        CALL    rPopReg
        RET

; 入力文字列 → コマンドライン引数
; 区切り文字は " " 固定
; in  : SI              バッファ先頭ポインタ(文字列は破壊される)
; out : __argc          分離したトークンの数
;       __argvx         トークン(x=0~9)
sysInputParseToken:
        CALL    rPushReg                ; レジスタ退避

        MOV BYTE [.aCommandLineID], "0" ; 変数名 "__in0   " からスタート
.token_loop:                            ; バッファが枯れるまでループ
        MOV     AH, " "
        CALL    libStrtok
        MOV BYTE [.aTokRet], AL
        MOV WORD [.aCommandValue], DI

        ; デバッグ---->
                ;PUSH    AX
                ;MOV WORD AX, [.aCommandValue]
                ;CALL    dbgPrint16bit           ; デバッグ
                ;POP     AX
                ;DEBUG_REGISTER_DUMP 0x0010, [.aCommandValue]
        ; <----

        ; デバッグ表示 ---->
                ;PUSH    BP
                ;MOV WORD BP, [.aCommandValue]
                ;CALL    libPuts
                ;POP     BP
        ;.debugHlt:
                ;JMP     .debugHlt
        ; <----

        MACRO_STRLEN DI
        INC     CL                      ; 終端文字分を追加
        MOV BYTE [.aLen], CL

        MACRO_SYSDIM 0x12, CL, .aCommandLine

        MOV WORD SI, .aCommandLine
        MOV     AL, CL
        MOV WORD BX, [.aCommandValue]
        CALL    sysSet
        ;DEBUG_REGISTER_DUMP 0x00100, 0x8000
        ;MACRO_SYSSET .aCommandLine, CL, [.aCommandValue]

        MOV BYTE AL, [.aTokRet]
        CMP     AL, 0x00
        JZ      .exit
        MOV     SI, _NULL
        ADD BYTE [.aCommandLineID], 1
        JMP     .token_loop

.exit:
        MACRO_SYSDIM 0x00, 0x00, .aCommandLineCnt
        MOV     BH, 0x00
        MOV BYTE BL, [.aCommandLineID]
        SUB     BL, 0x30
        INC     BL
        MOV     SI, .aCommandLineCnt
        CALL    sysSet

        ;CALL    sysList
        CALL    rPopReg                 ; レジスタ取得
        RET
.aCommandLine:                          ; 変数名8バイト
        DB      "__argv"
.aCommandLineID:                        ; "__argv0 " ～ "__argv9 " までの10個
        DB      "0 ", 0x00
.aCommandLineCnt:                       ; argvの数を格納する変数名
        DB      "__argc  "
.aCommandValue:                         ; 格納する値
        DW      0x0000
.aTokRet:                               ; strtok の戻り値
        DB      0x00
.aLen:                                  ; strlen の戻り値
        DB      0x00

; コマンドの実行
; 関数ポインタに登録してあるビルトインコマンドのみ許容
; in  : なし
; out : なし
sysCheckAndRunCommand:
        CALL    rPushReg

        ; ビルトインコマンド検索用の文字列をコピーする
        MACRO_STRLEN .aNameBICommand    ; CXに文字数
        INC     CX
        CALL    sysMalloc               ; strtokで切り刻む用のメモリを確保、戻り値BP
        MOV WORD [.aAllocMem], BP
        MACRO_MEMCPY BP, .aNameBICommand, CX    ; コピー

        MOV     SI, .aInputToken
        CALL    sysShellGet
        ADD     DI, 11
        MOV WORD [.aInputStr], DI

        MOV WORD SI, [.aAllocMem]
        MOV WORD [.aBIAddr], .BIAddrTable
.BIchkLoop:
        MOV     AH, " "
        CALL    libStrtok               ; DIにトークン
        PUSH    AX

        MOV     SI, [.aInputStr]
        CALL    libStrcmp               ; SIとDIの比較結果をAXに格納
        
        POP     CX

        CMP     AX, 0x0000              ; 文字列一致(コマンド発見)でループ脱却
        JZ      .BIchkFound

        MOV WORD BX, [.aBIAddr]         ; 次の関数ポインタへ
        ADD     BX, 2
        MOV WORD [.aBIAddr], BX
        
        CMP     CL, 0x00                ; ビルトインコマンドの全てにマッチしなければおわり
        JZ      .BIchkNotFound
        MOV     SI, 0x0000
        JMP     .BIchkLoop

.BIchkFound:
        MOV WORD SI, [.aBIAddr]
        MOV WORD SI, [SI]
        CMP     SI, 0x0000
        JZ      .BIchkNotDefine

        ; ↓↓↓ コマンド実行！！ ↓↓↓
        CALL    SI
        ; ↑↑↑ コマンド実行！！ ↑↑↑

        JMP     .exit

.BIchkNotFound:
        MOV     BP, .aStrNotFound
        CALL    libPuts
        JMP     .exit

.BIchkNotDefine:
        MOV     BP, .aStrNotDefine
        CALL    libPuts
        JMP     .exit

.exit:
        MOV WORD BP, [.aAllocMem]
        CALL    sysFree

        CALL    rPopReg
        RET
.aNumBICommand:                         ; ビルトインコマンドの数
        DB      16
.aNameBICommand:                        ; ビルトインコマンドの列挙(strtokでぶつ切りにしないこと！)
        DB      "dim "
        DB      "undim "
        DB      "set "
        DB      "echo "
        DB      "list "
        DB      "pwd "
        DB      "dir "
        DB      "cd "
        DB      "mkdir "
        DB      "rmdir "
        DB      "mkfile "
        DB      "rmfile "
        DB      "rename "
        DB      "cat "
        DB      "cls "
        DB      "lift", 0x00
.aBIAddr:                               ; 選択した関数ポインタ
        DW      _NULL
.BIAddrTable:                           ; ビルトインコマンドのルーチンポインタ
        DW      comDim          ;dim
        DW      comUndim        ;undim
        DW      comSet          ;set
        DW      comEcho         ;echo
        DW      comList         ;list
        DW      comPwd          ;pwd
        DW      comDir          ;dir
        DW      comCd           ;cd
        DW      comMkdir        ;mkdir
        DW      comRmdir        ;rmdir
        DW      comMkfile       ;mkfile
        DW      comRmfile       ;rmfile
        DW      comRename       ;rename
        DW      comCat          ;cat
        DW      comCls          ;cls
        DW      comLift         ;lift
.aInputToken:
        DB      "__argv0  ", 0x00
.aInputStr:
        DW      0x0000
.aStrNotFound:
        DB      "Illegal operation", 0x00
.aStrNotDefine:
        DB      "Undefined operation", 0x00
.aAllocMem:
        DW      0x0000

; コマンドライン引数の解放
; __argc 個分の __argv を undim する
; in  : なし
; out : なし
sysReleaseToken:
        CALL    rPushReg

        MOV     SI, .aTokenCnt
        CALL    sysShellGet             ; DIに __argc のポインタが格納される
        ADD     DI, 10
        MOV WORD AX, [DI]
        MOV WORD [.aCnt], AX            ; 変数値を格納

        MOV     CX, 0x0000
        MOV BYTE [.aTokenNum], "0"
.releaseLoop:                           ; __argv? を消す
        MOV WORD DX, [.aCnt]
        CMP     CX, DX
        JZ      .releaseBreak

        ; 解放
        MOV     SI, .aTokenStr
        CALL    sysUndim

        MOV BYTE AH, [.aTokenNum]
        INC     AH
        MOV BYTE [.aTokenNum], AH
        INC     CX
        JMP     .releaseLoop  

.releaseBreak:                          ; __argc を消す
        MOV     SI, .aTokenCnt
        CALL    sysUndim

        CALL    rPopReg
        RET
.aCnt:
        DW      0x0000
.aTokenCnt:                             ; コマンドライン引数の個数を記録している変数名
        DB      "__argc  ", 0x00
.aTokenStr:                             ; 変数名8バイト
        DB      "__argv"
.aTokenNum:                             ; "__argv0 " ～ "__argv9 " までの10個
        DB      "0 ", 0x00

; シェル変数を検索し、先頭ポインタを返却する
; in  : SI      検索する変数名
; out : DI      null以外: 発見した変数ポインタ
;               null: 見つからなかった
;       AX      発見した変数の値もしくはポインタ
sysShellGet:
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
        MOV WORD [.aRetAddr], BP
        ADD     BP, 1                   ; 変数型により値のポインタを設定
        MOV BYTE AH, [BP]
        AND     AH, 0x10
        CMP     AH, 0x00
        JNZ     .noArr
.arr:
        ADD     BP, 10
        MOV WORD [.aRetVal], BP         ; ポインタ
        JMP     .exit
.noArr:
        ADD     BP, 9
        MOV WORD AX, [BP]
        MOV WORD [.aRetVal], AX         ; 即値
        JMP     .exit
.noDiscoverValue:                       ; 発見できなかった
        MOV WORD [.aRetAddr], 0x0000
        MOV WORD [.aRetVal], 0x0000
        JMP     .exit

.exit:
        CALL    rPopReg                 ; レジスタ取得
        MOV WORD DI, [.aRetAddr]
        RET
.inName:                                ; 変数名(空白埋め8文字+番兵のnull)
        DB      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
.aRetAddr:                              ; 戻り値ポインタ
        DW      0x0000
.aRetVal:                               ; 戻り値変数
        DW      0x0000

; malloc コマンド(内部のみ)
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

; free コマンド(内部のみ)
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
        MOV BYTE AH, [DI]               ; sTbl[DI]
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

; 文字列操作マクロ
; string.asm
%include        "../asm/lib/string.asm"

; 型変換マクロ
; cast.asm
%include        "../asm/lib/cast.asm"

; ディスクアクセスマクロ
%include        "../asm/lib/disk.asm"

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
