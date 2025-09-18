; second
; TAB=4

        ORG     0x8000
        JMP     secMain

; --- 定数 ---
secRegLabel:                            ; レジスタラベル
        DB      "A", "X", "B", "X", "C", "X", "D", "X"
        DB      "S", "I", "D", "I", "B", "P", "S", "P"
        DB      "C", "S", "D", "S", "E", "S", "S", "S"

; --- 変数 ---
secCursolX:
        DB      0x00                    ; 表示xカーソル

secCursolY:
        DB      0x02                    ; 表示yカーソル

; --- プログラム ---
secMain:
; --- レジスタの初期化 ---
secInitReg:
        PUSH    CS                      ; セグメント統一
        POP     DS
        PUSH    CS
        POP     ES
        PUSH    CS
        POP     SS
        MOV     SP, 0xffff              ; スタックポインタ設定

        PUSH    SS                      ; スタックに貯めていく(12個)
        PUSH    ES
        PUSH    DS
        PUSH    CS
        PUSH    SP
        PUSH    BP
        PUSH    DI
        PUSH    SI
        PUSH    DX
        PUSH    CX
        PUSH    BX
        PUSH    AX

        MOV     BP, secRegLabel         ; ラベル位置
        MOV BYTE[.cntLine], 0x00        ; カウント初期化
        MOV BYTE[.cntCol], 0x00
.printLoop:
        MOV     AH, 0x13                ; ラベル表示
        MOV     AL, 0x01
        MOV     BH, 0x00
        MOV     BL, 0x0f                ; 白色
        MOV     CX, 0x02                ; 2文字
        MOV     DL, [secCursolX]
        MOV     DH, [secCursolY]
        INT     0x10
        ADD BYTE[secCursolX], 0x02      ; 座標を次の表示へ
        ADD     BP, 0x0002              ; 次のラベル位置へ

        MOV     AH, 0x13                ; ":"表示
        MOV     AL, 0x01
        MOV     BH, 0x00
        MOV     BL, 0x0f                ; 白色
        MOV     CX, 0x01                ; 1文字
        MOV     DL, [secCursolX]
        MOV     DH, [secCursolY]
        PUSH    BP                      ; ラベル位置記録
        MOV     BP, .colChar
        INT     0x10
        POP     BP                      ; ラベル位置取得
        ADD BYTE[secCursolX], 0x01      ; 座標を次の表示へ

        POP     DX                      ; レジスタ表示
        PUSH    BP                      ; ラベル位置記録
        CALL    printHex
        POP     BP                      ; ラベル位置取得
        ADD BYTE[secCursolX], 0x01      ; 空白文字1文字

        ADD BYTE[.cntCol], 0x01
        CMP BYTE[.cntCol], 0x04
        JNZ     .printLoop              ; 4回表示したら次の行へ
        MOV BYTE[secCursolX], 0x00      ; 座標を次の行の先頭へ
        ADD BYTE[secCursolY], 0x01
        MOV BYTE[.cntCol], 0x00
        ADD BYTE[.cntLine], 0x01
        CMP BYTE[.cntLine], 0x03
        JNZ     .printLoop              ; 3行表示したら終わり
        JMP     secMemChk

.cntCol:
        DB      0x00                    ; 列

.cntLine:
        DB      0x00                    ; 行

.colChar:
        DB      ":"

; --- 使用可能メモリの確認 ---
secMemChk:

        
        ;CALL    secTest
        CALL    secHlt

; --- テスト ---
secTest:
        ;MOV     DX, 0x1234
        ;CALL    printHex
        ;RET
        PUSH    CS
        POP     DS
        MOV     DL, [secCursolX]

        ;MOV     AH, 0x0e
        ;MOV     AL, DL
        ;MOV     BX, 0x0000
        ;INT     0x10
        ;RET

        MOV     DH, [secCursolY]
        CALL    printHex
        RET

secHlt:
        JMP     secHlt

; --- サブルーチン ---

; 16ビット数値 → 4文字の文字列変換
; in : DXreg    変換する値
; out: (SP  )   1文字目の文字コード(下位8bit)
; out: (SP+2)   2文字目の文字コード
; out: (SP+4)   3文字目の文字コード
; out: (SP+6)   4文字目の文字コード
hex16ToAscii:
        ; 表示は行わない！変換のみなので注意！
        POP     BX                      ; 戻るポインタ

        PUSH    DX                      ; 1桁目
        MOV     CX, DX          
        AND     CX, 0x000f
        SHR     CX, 0
        MOV     DX, CX
        CALL    hex04ToAscii
        POP     DX
        PUSH    CX                      ; スタックに格納

        PUSH    DX                      ; 2桁目
        MOV     CX, DX          
        AND     CX, 0x00f0
        SHR     CX, 4
        MOV     DX, CX
        CALL    hex04ToAscii
        POP     DX
        PUSH    CX                      ; スタックに格納

        PUSH    DX                      ; 3桁目
        MOV     CX, DX          
        AND     CX, 0x0f00
        SHR     CX, 8
        MOV     DX, CX
        CALL    hex04ToAscii
        POP     DX
        PUSH    CX                      ; スタックに格納

        PUSH    DX                      ; 4桁目
        MOV     CX, DX          
        AND     CX, 0xf000              ; 15~12bit
        SHR     CX, 12                  ; 12→0
        MOV     DX, CX
        CALL    hex04ToAscii            ; 1桁変換
        POP     DX
        PUSH    CX                      ; スタックに格納
                                        ; SP <- 1桁目 <- 2 <- 3 <- 4
        PUSH    BX                      ; 戻るポインタを格納
        RET

; 4ビット数値 → 1文字の文字列変換
; in : DXreg    変換する値(下位4bit)
; out: CXreg    変換する値(下位4bit)
hex04ToAscii:
        PUSH    DX
        AND     DX, 0x000f              ; 4ビットに限定
        CMP     DX, 0x000a
        JAE     .upper                  ; 10以上ならジャンプ
.lower:                                 ; '0'~'9'
        MOV     CX, "0"
        ADD     CX, DX
        JMP     .exit
.upper:                                 ; 'A'~'F'
        MOV     CX, "A"
        ADD     CX, DX
        SUB     CX, 0x0a
        JMP     .exit
.exit:
        POP     DX
        RET

; 16ビットの数値を表示する
; in : DXreg    表示する値
; out: なし
printHex:
        CALL    hex16ToAscii            ; 変換
        PUSH    CS
        POP     DS
        MOV     BX, 0x0000              ; ループ初期化

.popLoop:                               ; 4回繰り返し
        POP     CX
        MOV     DI, .msg
        ADD     DI, BX                  ; アドレス
        ADD     DI, 0x0002
        MOV     [DI], CL
        ADD     BX, 0x0001
        CMP     BX, 0x04
        JZ      .next
        JMP     .popLoop
.next:  
        MOV	AH, 0x13
        MOV	AL, 0x01
        MOV	BH, 0x00
        MOV	BL, 0x0f
        MOV	CX, 0x0006
        MOV     DL, [secCursolX]        ; 座標
        MOV     DH, [secCursolY]
        MOV	BP, .msg
        ADD BYTE[secCursolX], 0x06
        INT	0x10
        RET

.msg:                                   ; 表示する4バイト(0xnnnn)
        DB      "0", "x", "0", "0", "0", "0"

; --- 0埋め ---
secEnd:
        times 2048-($-$$) DB 0          ; セカンダリローダは4セクタ
