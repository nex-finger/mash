; second
; TAB=4

        ORG     0x0000
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
        ;       M                                                                 A                                               S                                               H                                               終端文字
        DB      0xdb, 0xdb, 0xdb, 0xbb, 0x20, 0x20, 0x20, 0xdb, 0xdb, 0xdb, 0xbb, 0x20, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xbb, 0x20, 0x20, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xbb, 0xdb, 0xdb, 0xbb, 0x20, 0x20, 0xdb, 0xdb, 0xbb, 0x00
        DB      0xdb, 0xdb, 0xdb, 0xdb, 0xbb, 0x20, 0xdb, 0xdb, 0xdb, 0xdb, 0xba, 0xdb, 0xdb, 0xca, 0xcd, 0xcd, 0xdb, 0xdb, 0xbb, 0xdb, 0xdb, 0xca, 0xcd, 0xcd, 0xcd, 0xcd, 0xbc, 0xdb, 0xdb, 0xbb, 0x20, 0x20, 0xdb, 0xdb, 0xba, 0x00
        DB      0xdb, 0xdb, 0xca, 0xdb, 0xdb, 0xdb, 0xdb, 0xca, 0xdb, 0xdb, 0xba, 0xdb, 0xdb, 0xba, 0x20, 0x20, 0xdb, 0xdb, 0xba, 0xc8, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xbb, 0x20, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xba, 0x00
        DB      0xdb, 0xdb, 0xba, 0xc8, 0xdb, 0xdb, 0xca, 0xbc, 0xdb, 0xdb, 0xba, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xba, 0x20, 0xc8, 0xcd, 0xcd, 0xcd, 0xdb, 0xdb, 0xbb, 0xdb, 0xdb, 0xca, 0xcd, 0xcd, 0xdb, 0xdb, 0xba, 0x00
        DB      0xdb, 0xdb, 0xba, 0x20, 0xc8, 0xca, 0xbc, 0x20, 0xdb, 0xdb, 0xba, 0xdb, 0xdb, 0xca, 0xcd, 0xcd, 0xdb, 0xdb, 0xba, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xca, 0x20, 0xdb, 0xdb, 0xbb, 0x20, 0x20, 0xdb, 0xdb, 0xba, 0x00
        DB      0xc8, 0xcd, 0xbc, 0x20, 0x20, 0x20, 0x20, 0x20, 0xc8, 0xcd, 0xbc, 0xc8, 0xcd, 0xbc, 0x20, 0x20, 0xc8, 0xcd, 0xbc, 0xc8, 0xcd, 0xcd, 0xcd, 0xcd, 0xcd, 0xbc, 0x20, 0xc8, 0xcd, 0xbc, 0x20, 0x20, 0xc8, 0xcd, 0xbc, 0x00

; --- 変数 ---
; ██╗   ██╗ █████╗ ██████╗ ██╗ █████╗ ██████╗ ██╗     ███████╗
; ██║   ██║██╔══██╗██╔══██╗██║██╔══██╗██╔══██╗██║     ██╔════╝
; ╚██╗ ██╔╝██║  ██║██████╔╝██║██║  ██║██████╔╝██║     ███████╗
;  ╚████╔╝ ███████║██╔══██╗██║███████║██╔══██╗██║     ██╔════╝
;   ╚██╔╝  ██╔══██║██║  ██║██║██╔══██║██████╔╝███████╗███████╗
;    ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝
sXpos:
        DB      0x00                    ; 表示xカーソル
sYpos:
        DB      0x00                    ; 表示yカーソル
sColor:
        DB      0x0f                    ; 表示色(初期値: 白)

; --- 初期化プログラム ---
; ██╗███╗  ██╗██╗████████╗
; ██║████╗ ██║██║╚══██╔══╝
; ██║██╔██╗██║██║   ██║   
; ██║██║╚████║██║   ██║   
; ██║██║ ╚███║██║   ██║   
; ╚═╝╚═╝  ╚══╝╚═╝   ╚═╝   
mashInit:
        MOV     BX, cMashLogo
        MOV     CX, 0x0000

        CALL    rPushReg                ; レジスタ退避
        CALL    mashLoop                ; ループ処理へ移行
        CALL    rPopReg                 ; レジスタ取得

; --- ループプログラム ---
; ██╗      ██████╗  ██████╗ ██████╗ 
; ██║     ██╔═══██╗██╔═══██╗██╔══██╗
; ██║     ██║   ██║██║   ██║██████╔╝
; ██║     ██║   ██║██║   ██║██╔═══╝ 
; ███████╗╚██████╔╝╚██████╔╝██║     
; ╚══════╝ ╚═════╝  ╚═════╝ ╚═╝     
mashLoop:
        CALL    mashLoop

; --- サブルーチン ---
rPrint:
; 文字列の表示
; 終端文字(0x00)を確認するまで文字を表示し続ける
; in  : BX      表示する文字列
;       DS:BX   データポインタ
; out : AX      表示結果
;                   0: 成功
;                   1: 256文字以上の文字列を表示しようとした
;                   2: その他の失敗
        
rPushReg:
; 全レジスタの退避
; 呼んだあと必ず rPopReg を呼ぶこと
; 呼ぶ前 SP <- サブルーチンへのポインタ
; 呼び後 SP <- SS <- ES <- DS <- CS <- SP <- BP <- DI <- SI <- DX <- CX <- BX <- AX
; in  : reg     全てのレジスタ
; out : なし
        MOV     [.tempAX], AX           ; 本ルーチンの戻り先を確保(スタックにこれから詰め込むため)
        POP     AX
        MOV WORD    [.retAddr], .retAddr
        MOV     AX, [.tempAX]

        PUSH    AX                      ; スタックに積む
        PUSH    BX
        PUSH    CX
        PUSH    DX
        PUSH    SI
        PUSH    DI
        PUSH    BP
        PUSH    SP
        PUSH    CS
        PUSH    DS
        PUSH    ES
        PUSH    SS

        MOV WORD    AX, [.retAddr]      ; 本ルーチンの戻り値を復元
        PUSH    AX
        RET
.tempAX:                                ; AXレジスタを一時的に格納
        DB      0x00, 0x00
.retAddr:                               ; ルーチンのリターンアドレス
        DB      0x00, 0x00

rPopReg:
; 全レジスタの復帰
; 呼ぶ前に必ず rPushReg を呼ぶこと
; 呼ぶ前 SP <- サブルーチンへのポインタ <- SS <- ES <- DS <- CS <- SP <- BP <- DI <- SI <- DX <- CX <- BX <- AX
; 呼び後 SP
; in  : なし
; out : reg     全てのレジスタ
        POP     AX                      ; 本ルーチンの戻り値を確保
        MOV WORD    [.retAddr], .retAddr

        POP     SS                      ; スタックから読む(AXだけは最後に)
        POP     ES
        POP     DS

        POP     BP                      ; CSだけはPOPできないので
        MOV     CS, BP

        POP     SP
        POP     BP
        POP     DI
        POP     SI
        POP     DX
        POP     CX
        POP     BX
        POP     AX

        MOV     [.tempAX], AX
        MOV WORD    AX, [.retAddr]      ; 本ルーチンの戻り値を復元
        PUSH    AX
        MOV     AX, [.tempAX]
        RET
.tempAX:                                ; AXレジスタを一時的に格納
        DB      0x00, 0x00
.retAddr:                               ; ルーチンのリターンアドレス
        DB      0x00, 0x00

; --- 0埋め ---
secEnd:
        times 0x4000-($-$$) DB 0          ; セカンダリローダは4セクタ
