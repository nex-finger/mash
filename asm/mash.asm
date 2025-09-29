; second
; TAB=4

; ロゴ
; https://jp.mathworks.com/matlabcentral/fileexchange/181715-makebanner-big-ascii-style-comment-generator

        ORG     0x4000
        JMP     mashInit

; --- 定数 ---
;  ██████╗ ██████╗ ███╗  ██╗ ██████╗████████╗
; ██╔════╝██╔═══██╗████╗ ██║██╔════╝╚══██╔══╝
; ██║     ██║   ██║██╔██╗██║╚█████╗    ██║   
; ██║     ██║   ██║██║╚████║ ╚═══██╗   ██║   
; ╚██████╗╚██████╔╝██║ ╚███║██████╔╝   ██║   
;  ╚═════╝ ╚═════╝ ╚═╝  ╚══╝╚═════╝    ╚═╝   
cMashLogo:                                  ; ロゴ(35x6 = 210byte)
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

cVersionLen:                                ; 版数文字列の長さ
        DW      18

cVersionStr:                                ; 版数文字列の内容
        DB      "mash system v0.1.1"

; --- 変数 ---
;  ██████╗████████╗ █████╗ ████████╗██╗ ██████╗
; ██╔════╝╚══██╔══╝██╔══██╗╚══██╔══╝██║██╔════╝
; ╚█████╗    ██║   ██║  ██║   ██║   ██║██║     
;  ╚═══██    ██║   ███████║   ██║   ██║██║     
; ██████╔╝   ██║   ██╔══██║   ██║   ██║╚██████╗
; ╚═════╝    ╚═╝   ╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝
sXpos:
        DB      0x00                    ; 表示xカーソル
sYpos:
        DB      0x09                    ; 表示yカーソル
sColorNormal:
        DB      0x0f                    ; 表示色(初期値: 白)
sColorError:
        DB      0x01                    ; 表示色(初期値: 赤?)
sFreeMemSize:
        DB      0x00, 0x00              ; mallocできる残りメモリ

; --- 初期化プログラム ---
; ██╗███╗  ██╗██╗████████╗
; ██║████╗ ██║██║╚══██╔══╝
; ██║██╔██╗██║██║   ██║   
; ██║██║╚████║██║   ██║   
; ██║██║ ╚███║██║   ██║   
; ╚═╝╚═╝  ╚══╝╚═╝   ╚═╝   
mashInit:
        MOV     AX, 0x0000              ; レジスタセット
        MOV     DS, AX
        MOV     SS, AX
        MOV     ES, AX
        MOV     SP, 0x3fff              ; ｾｸﾞﾎﾟ

        ;PUSH    DS
        ;MOV     AX, 0x0000
        ;MOV     DS, AX
        ;MOV     AX, 0x0010
        ;MOV     DI, 0x3ff0
        ;CALL    dbgDump
        ;POP     DS

        CALL    rInitMalloc

        ; debug ---->
        MOV     AX, 0x0000
        MOV     DS, AX
        MOV     SS, AX
        MOV     ES, AX
        ; <---- debug
        CALL    cmdVer                  ; ロゴ+版数表示
        
        JMP     mashLoop                ; ループ処理へ移行

; --- ループプログラム ---
; ██╗      ██████╗  ██████╗ ██████╗ 
; ██║     ██╔═══██╗██╔═══██╗██╔══██╗
; ██║     ██║   ██║██║   ██║██████╔╝
; ██║     ██║   ██║██║   ██║██╔═══╝ 
; ███████╗╚██████╔╝╚██████╔╝██║     
; ╚══════╝ ╚═════╝  ╚═════╝ ╚═╝     
mashLoop:
        CALL    sysPwd                  ; 現在のディレクトリを表示

        MOV     BP, .sAllow             ; ">"表示
        CALL    sysEcho
        
        JMP     mashLoop                ; 永遠にループする
.sAllow:
        DB      ">\0"

; --- ビルトインコマンド ---
;  ██████╗ ██████╗ ███╗   ███╗███╗   ███╗ █████╗ ███╗  ██╗██████╗ 
; ██╔════╝██╔═══██╗████╗ ████║████╗ ████║██╔══██╗████╗ ██║██╔══██╗
; ██║     ██║   ██║██╔████╔██║██╔████╔██║██║  ██║██╔██╗██║██║  ██║
; ██║     ██║   ██║██║╚██╔╝██║██║╚██╔╝██║███████║██║╚████║██║  ██║
; ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║ ╚═╝ ██║██╔══██║██║ ╚███║██████╔╝
;  ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚══╝╚═════╝ 

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
; アロケーションメモリ: 0x1000:0x0000 ~ 0x1000:0xffff
; アロケーションテーブル: 0x0000:0x1000 ~ 0x0000:0x1fff
; 
; sysMalloc -> .mallocLoop / .return
; .mallocLoop -> .exitChk / .cntChk
; .exitChk -> .return / .mallocLoop
; .cntChk -> .exitChk / .fillTbl
; .fillTbl -> .fillLoop
; .fillLoop -> .fillLoop / .return
; .return -> RET
;
; in  : CX      確保したいメモリ容量(バイト)
; out : AX      結果 0成功 1失敗
;     : SS:BP   確保した先頭ポインタ(確保に成功した場合)
sysMalloc:
        CALL    rPushReg                ; レジスタ退避
        PUSH    DS                      ; セグメント退避
        CMP     CX, 0x1000              ; 確保メモリ上限チェック
        JAE     .retError
        CMP     CX, 0x0000              ; 0バイトかチェック
        JZ      .retError
        ADD     CX, 0x000f              ; 確保するブロック数(1ブロック16バイト) = (確保したいバイト + 15) /16
        SHR     CX, 0x04
        MOV BYTE [.aSize], CL
        MOV     AX, 0x0000              ; テーブルのセグメントは 0 、以後ルーチン脱出直前まで0のまま
        MOV     DS, AX
        MOV WORD [.aFAdr], 0x1000       ; テーブルの先頭ポインタは 0x1000
        MOV BYTE [.aCnt], 0x00
        MOV WORD [.aRet], 0x1000
.mallocLoop:
        MOV WORD DI, [.aFAdr]           ; シークしている番地が0か確認
        MOV BYTE AH, [DS:DI]
        CMP     AH, 0x00
        JZ      .cntChk
        MOV BYTE [.aSize], 0x00         ; シーク番地が0ではないので連続数をリセット
        MOV WORD AX, [.aFAdr]           ; アロケーションテーブルをシーク
        INC     AX
        MOV WORD [.aFAdr], AX
        MOV WORD [.aRet], AX            ; シーク以前には確保できる領域がないため次へ
.exitChk:
        MOV WORD AX, [.aFAdr]           ; テーブルの末尾まで行ったらもう見込みなし
        CMP     AX, 0x2000              ; 末尾は 0x1fff
        JNZ     .mallocLoop                ; 末尾ではないなら次の1バイトを
.retError:
        MOV WORD [.aRet], 0xffff        ; とりあえずゴミデータ
.return:
        CALL    rPopReg                 ; レジスタ取得
        MOV WORD BP, [.aRet]            ; 取得した先頭アドレスを格納
        POP     DS                      ; mallocをコールする前のセグメントに戻す
        RET                             ; 呼び出し元へ
.cntChk:
        MOV BYTE AH, [.aCnt]            ; 連続空きブロックカウントをカウントアップ
        INC     AH                      ; AHには連続空きブロック
        MOV BYTE [.aCnt], AH
        MOV BYTE AL, [.aSize]           ; 連続空きブロックで注文した領域を充足するか？
        CMP     AH, AL                  ; ALには注文されたブロック数(AHには連続空きブロック)
        JZ      .fillTbl
        MOV WORD AX, [.aFAdr]           ; まだ充足しないため検索を続ける(連続空きブロックは継続)
        INC     AX
        MOV WORD [.aFAdr], AX
        JMP     .exitChk                ; 末尾チェックへ
.fillTbl:
        MOV WORD AX, [.aFAdr]           ; 連続空きブロックの先頭アドレスを取得
        MOV     DI, AX                  ; 以後空きブロックのアドレスは DI にて参照
        MOV BYTE AH, [.aCnt]            ; 以後注文されたブロック数は AH にて参照
.fillLoop:
        MOV BYTE [DS:DI], AH            ; free用に意味のある値を格納
        DEC     AH                      ; aCnt--
        INC     DI                      ; aFAdr++
        CMP     AH, 0x00                ; 注文されたブロック数だけ書き込んだら終了
        JNZ     .fillLoop
        MOV WORD AX, [.aRet]            ; 呼び出し元に返却するのは (連続空きブロックの先頭アドレス - 0X10000) * 16
        SUB     AX, 0x1000
        SHL     AX, 0x04
        MOV WORD [.aRet], AX
        JMP     .return        
.aFAdr:                                 ; テーブル内シークアドレス
        DB      0x00, 0x00
.aCnt:                                  ; 現時点の連続空きブロック
        DB      0x00
.aSize:                                 ; 検索するべき連続空きブロック
        DB      0x00
.aRet:                                  ; 返却するアロケーションメモリアドレス
        DB      0x00, 0x00

; コメントアウト(2025/09/28時点の欠陥malloc
;sysMalloc:
;        CALL    rPushReg                ; レジスタ退避
;
;        ; debug ---> (2025/09/28 コメントを消しても動くことまで確認)
;        MOV     AX, 0x0000
;        MOV     DS, AX
;        MOV     BX, 0x1002
;        MOV WORD [DS:BX], 0x1234
;
;        CALL    rPopReg                 ; レジスタ取得
;        RET
;        ; <--- debug
;
;        CMP     CX, 0x0000              ; 0バイト確保ならなにもしない
;        JZ      .retError
;        CMP     CX, 0x0ff0
;        JA      .retError               ; 255*16 バイトより大きいならなにもしない
;        
;        PUSH    DS                      ; セグメント保存
;        MOV     AX, 0x0000
;        MOV     DS, AX                  ; セグメント指定！
;        MOV     BX, 0x0000
;        MOV     SI, 0x1000
;.tblLoop:
;        MOV BYTE BL, [DS:SI]
;        CMP     BL, 0x00
;        JNZ     .tblNext
;.fillChk:
;        INC     BH                      ; 連続確認数
;        MOV     DX, 0x0000              ; DX ← BH << 4
;        MOV     DL, BH
;        SHL     DX, 0x04
;        AND     DX, 0xfff0
;        CMP     DX, CX
;        JB      .exitCheck              ; まだ確保量が足りないなら続ける
;        MOV     BP, AX
;        MOV     CX, 0x0000
;.fiilLoop:
;        MOV     SI, 0x1000              ; SI ← 0x1000 + AX + CX
;        ADD     SI, AX
;        ADD     SI, CX
;        MOV     BL, 0x00
;        ADD     BL, BH
;        SUB     BL, CL                  ; BL ← BH - CL
;        MOV BYTE [DS:SI], BL               ; sTbl[AX + CX]
;        INC     CL
;        CMP     CL, BH
;        JZ      .retSuccess             ; 成功終了
;        JMP     .fiilLoop
;.tblNext:
;        INC     SI
;        MOV     AX, SI
;        MOV     BH, 0x00
;.exitCheck:
;        CMP     SI, 0x1fff
;        JZ      .retError
;        JMP     .tblLoop
;.retSuccess:
;        SHL     AX, 0x04
;        AND     AX, 0xfff0
;        MOV WORD [.aRetAddr], AX
;        CALL    rPopReg                 ; レジスタ取得
;        MOV WORD BP, [.aRetAddr]
;        MOV     AX, 0x0000
;        RET
;.retError:                              ; 失敗時
;        CALL    rPopReg
;        MOV     AX, 0x0001
;        RET
;.aRetAddr:
;        DB      0x00, 0x00              ; 戻り値一時格納

; free コマンド
sysFree:
        CALL    rPushReg                ; レジスタ退避

        MOV     AX, 0x0000
        MOV     DI, BP                  ; DI ← BP >> 4
        SHR     DI, 0x04
        ADD     DI, 0x0fff
        MOV     CX, [DI]                ; CX ← sTbl[DI]

        ;PUSH    DS
        ;MOV     BX, 0x1000
        ;MOV     DS, BX
.freeLoop:
        MOV     SI, 0x1000              ; SI ← 0x1000 + DI + AX = sTbl[DI+AX]
        ADD     SI, DI
        ADD     SI, AX
        MOV BYTE [DS:SI], 0x00
        INC     AX
        CMP     AX, CX
        JNZ     .freeLoop

        POP     DS                      ; セグメント戻す
        CALL    rPopReg                 ; レジスタ取得
        RET



; --- サブルーチン --- subroutine
;  ██████╗██╗   ██╗██████╗      ██████╗  ██████╗ ██╗   ██╗████████╗██╗███╗  ██╗███████╗
; ██╔════╝██║   ██║██╔══██╗     ██╔══██╗██╔═══██╗██║   ██║╚══██╔══╝██║████╗ ██║██╔════╝
; ╚█████╗ ██║   ██║██████╔╝     ██████╔╝██║   ██║██║   ██║   ██║   ██║██╔██╗██║███████╗
;  ╚═══██╗██║   ██║██╔══██╗     ██╔══██╗██║   ██║██║   ██║   ██║   ██║██║╚████║██╔════╝
; ██████╔╝╚██████╔╝██████╔╝     ██║  ██║╚██████╔╝╚██████╔╝   ██║   ██║██║ ╚███║███████╗
; ╚═════╝  ╚═════╝ ╚═════╝      ╚═╝  ╚═╝ ╚═════╝  ╚═════╝    ╚═╝   ╚═╝╚═╝  ╚══╝╚══════╝

; 文字列の表示
; 終端文字(0x00)を確認するまで文字を表示し続ける
; in  : BX      表示する文字列
;       DS:BX   データポインタ
; out : AX      表示結果
;                   0: 成功
;                   1: 256文字以上の文字列を表示しようとした
;                   2: その他の失敗
rPrint:
        CALL    rPushReg                ; レジスタ退避
        CALL    rPopReg                 ; レジスタ取得
        RET

; malloc 用のアロケーションメモリとアロケーションテーブルを初期化
; アロケーションメモリ 0x10000 ~ 0x1ffff
; アロケーションテーブル 0x01000 ~ 0x01fff
; in  : なし
; out : なし
rInitMalloc:
        CALL    rPushReg                ; レジスタ退避

        MOV WORD [sFreeMemSize], 0x1000 ; 使用可能メモリを64kBに
        MOV     AX, ES
        PUSH    AX
        MOV     AX, 0x0000
        MOV     ES, AX
        MOV     BP, 0x1000
.initLoop:
        MOV BYTE [ES:BP], 0x00
        INC     BP
        CMP     BP, 0x2000
        JNZ     .initLoop

        POP     AX
        MOV     ES, AX

        ; debug --->
        ; アロケーションテーブル
        PUSH    DS
        MOV     AX, 0x0000
        MOV     DS, AX
        MOV     AX, 0x0010
        MOV     DI, 0x1000
        CALL    dbgDump
        POP     DS

        ; スタック
        PUSH    DS
        MOV     AX, 0x0000
        MOV     DS, AX
        MOV     AX, 0x0040
        MOV     DI, 0x3fc0
        CALL    dbgDump
        POP     DS
        ; <--- debug

        MOV     CX, 0x0020              ; 適当にとってテスト
        CALL    sysMalloc

        ; debug --->
        ; アロケーションテーブル
        PUSH    DS
        MOV     AX, 0x0000
        MOV     DS, AX
        MOV     AX, 0x0010
        MOV     DI, 0x1000
        CALL    dbgDump
        POP     DS

        ; スタック
        PUSH    DS
        MOV     AX, 0x0000
        MOV     DS, AX
        MOV     AX, 0x0040
        MOV     DI, 0x3fc0
        CALL    dbgDump
        POP     DS

        CALL    rPopReg                 ; レジスタ取得
        RET
        ; <--- debug

        ;CALL    sysFree
        ;CMP WORD [sFreeMemSize], 0xffff
        ;JNZ     mashHlt

        ; debug --->
        PUSH    DS
        MOV     AX, 0x1000
        MOV     DS, AX
        MOV     AX, 0x0010
        MOV     DI, 0x1000
        CALL    dbgDump
        POP     DS
        ; <--- debug

        CALL    rPopReg                 ; レジスタ取得
        RET

; mashのバージョン表示
; ロゴとバージョンについて記載する
; in  : なし
; out : なし
cmdVer:
        CALL    rPushReg                ; レジスタ退避
        MOV     AX, 0x0000
        MOV     SS, AX
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
        MOV BYTE [DS:sXpos], 0x00
        INC BYTE [DS:sYpos]
        INC     CX
        CMP     CX, 0x0006
        JNZ     .loophead    
.next:
        MOV     BP, cVersionStr
        MOV     AH, 0x13                ; 版数の表示
        MOV     AL, 0x01
        MOV     BH, 0
        MOV     BL, [DS:sColorNormal]
        MOV     CX, [DS:cVersionLen]
        MOV     DH, [DS:sYpos]
        MOV     DL, [DS:sXpos]
        INT     0x10
        MOV BYTE [DS:sXpos], 0x00
        INC BYTE [DS:sYpos]
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

        MOV     AL, 0x0a                ; 改行文字
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

mashHlt:
        JMP     mashHlt

; --- 0埋め ---
secEnd:
        times 0x4000-($-$$) DB 0        ; mash常駐は16セクタ

; --- メモ ---
;
;       メモリダンプフォーマット
;        MOV     AX, 0x0010              ; 256バイト
;        MOV     DI, 0x4000              ; 0x4000から
;        CALL    dbgDump