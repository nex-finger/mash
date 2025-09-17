; second
; TAB=4

        ORG     0x8000

        JMP     secMain

; --- 変数 ---
secCursolX:
        DB      0x12            ; 表示xカーソル

secCursolY:
        DB      0x34            ; 表示yカーソル

; --- セカンダリローダ ---
secMain:
        CALL    secTest
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
        POP     BX              ; 戻るポインタ

        PUSH    DX              ; 1桁目
        MOV     CX, DX          
        AND     CX, 0x000f
        SHR     CX, 0
        MOV     DX, CX
        CALL    hex04ToAscii
        POP     DX
        PUSH    CX              ; スタックに格納

        PUSH    DX              ; 2桁目
        MOV     CX, DX          
        AND     CX, 0x00f0
        SHR     CX, 4
        MOV     DX, CX
        CALL    hex04ToAscii
        POP     DX
        PUSH    CX              ; スタックに格納

        PUSH    DX              ; 3桁目
        MOV     CX, DX          
        AND     CX, 0x0f00
        SHR     CX, 8
        MOV     DX, CX
        CALL    hex04ToAscii
        POP     DX
        PUSH    CX              ; スタックに格納

        PUSH    DX              ; 4桁目
        MOV     CX, DX          
        AND     CX, 0xf000      ; 15~12bit
        SHR     CX, 12          ; 12→0
        MOV     DX, CX
        CALL    hex04ToAscii    ; 1桁変換
        POP     DX
        PUSH    CX              ; スタックに格納
                                ; SP <- 1桁目 <- 2 <- 3 <- 4
        PUSH    BX              ; 戻るポインタを格納
        RET

; 4ビット数値 → 1文字の文字列変換
; in : DXreg    変換する値(下位4bit)
; out: CXreg    変換する値(下位4bit)
hex04ToAscii:
        PUSH    DX
        AND     DX, 0x000f      ; 4ビットに限定
        CMP     DX, 0x000a
        JAE     .upper          ; 10以上ならジャンプ
.lower:                         ; '0'~'9'
        MOV     CX, "0"
        ADD     CX, DX
        JMP     .exit
.upper:                         ; 'A'~'F'
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
        CALL    hex16ToAscii    ; 変換
        PUSH    CS
        POP     DS
        MOV     BX, 0x0000      ; ループ初期化

.popLoop:                       ; 4回繰り返し
        POP     CX
        MOV     DI, .msg
        ADD     DI, BX          ; アドレス
        MOV     [DI], CL
        ADD     BX, 0x0001
        CMP     BX, 0x04
        JZ      .next
        JMP     .popLoop
.next:  
        MOV     DL, 10          ; 座標
        MOV     DH, 10
        MOV	AH, 0x13
        MOV	AL, 0x01
        MOV	BH, 0x00
        MOV	BL, 0x0f
        MOV	CX, 0x0004
        PUSH	CS
        POP	ES
        MOV	BP, .msg
        INT	0x10
        RET

.msg:                           ; 表示する4バイト
        DB      0x30, 0x30, 0x30, 0x30

; --- 0埋め ---
secEnd:
        times 2048-($-$$) DB 0  ; セカンダリローダは4セクタ