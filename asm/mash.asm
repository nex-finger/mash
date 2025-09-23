; second
; TAB=4

; ロゴ
; https://jp.mathworks.com/matlabcentral/fileexchange/181715-makebanner-big-ascii-style-comment-generator

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
        DB      "mash system v0.1.0"

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

; --- 初期化プログラム ---
; ██╗███╗  ██╗██╗████████╗
; ██║████╗ ██║██║╚══██╔══╝
; ██║██╔██╗██║██║   ██║   
; ██║██║╚████║██║   ██║   
; ██║██║ ╚███║██║   ██║   
; ╚═╝╚═╝  ╚══╝╚═╝   ╚═╝   
mashInit:
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

; mashのバージョン表示
; ロゴとバージョンについて記載する
; in  : なし
; out : なし
cmdVer:
        CALL    rPushReg                ; レジスタ退避
        MOV     BP, cMashLogo           ; ロゴの表示
        MOV     CX, 0x0000
.loophead:
        PUSH    CX                      ; ループ変数格納
        MOV     AH, 0x13
        MOV     AL, 0x01
        MOV     BH, 0
        MOV     BL, [sColorNormal]
        MOV     CX, 35                  ; 1行35文字
        MOV     DH, [sYpos]
        MOV     DL, [sXpos]
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

        MOV WORD    AX, [.retAddr]      ; AX        ret     ret BP)DI)SI)DX)CX)BX)AX
        PUSH    AX                      ; AX        ret     ret ret)BP)DI)SI)DX)CX)BX)AX
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

mashHlt:
        JMP     mashHlt

; --- 0埋め ---
secEnd:
        times 0x4000-($-$$) DB 0          ; セカンダリローダは4セクタ
