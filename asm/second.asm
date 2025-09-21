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

; --- メモリの確認 ---
secMemChk:
        MOV     AH, 0x13                ; 前表示
        MOV     AL, 0x01
        MOV     BH, 0x00
        MOV     BL, 0x0f
        MOV     CX, 0x0e
        MOV     DL, [secCursolX]
        MOV     DH, [secCursolY]
        MOV     BP, .preMsg
        INT     0x10
        ADD BYTE[secCursolX], 0x0e        

        MOV     SI, 0x0000              ; カウント初期化
.chkLoop:
        MOV     AH, [SI]                ; もとあったメモリを保存

        MOV BYTE [SI], 0x55
        MOV BYTE AL, [SI]
        CMP     AL, 0x55
        JNZ     .chkError               ; 0x55 じゃなければエラー

        MOV BYTE [SI], 0xaa
        MOV BYTE AL, [SI]
        CMP     AL, 0xaa
        JNZ     .chkError               ; 0xaa じゃなければエラー

        MOV     [SI], AH                ; もとあったメモリを復元
        PUSH    SI                      ; BPを表示
        POP     DX
        CALL    printHex
        SUB BYTE[secCursolX], 0x06      ; 繰り返すので戻す
        INC     SI

        CMP     SI, 0x8000
        JNZ     .chkLoop                ; 0x7fff まで読んだら終わり
.chkDone:
        ADD BYTE[secCursolX], 0x07      ; 次の表示のため
        CALL    printDone
        MOV BYTE[secCursolX], 0x00      ; 座標を次の行の先頭へ
        ADD BYTE[secCursolY], 0x01
        JMP     secDiskChk
.chkError:
        ADD BYTE[secCursolX], 0x07      ; 次の表示のため
        CALL    printError
        JMP     secHlt
.preMsg:                                ; "Memory test..."~
        DB      "M", "e", "m", "o", "r", "y", " ", "t", "e", "s", "t", ".", ".", "."

; --- ディスクの確認 ---
secDiskChk:
        MOV     AH, 0x13                ; 前表示
        MOV     AL, 0x01
        MOV     BH, 0x00
        MOV     BL, 0x0f
        MOV     CX, 0x0c
        MOV     DL, [secCursolX]
        MOV     DH, [secCursolY]
        MOV     BP, .preMsg
        INT     0x10
        ADD BYTE[secCursolX], 0x0c

        MOV     DX, 0x0000              ; ループ変数初期化
.chkLoop:
        PUSH    DX                      ; ループ変数格納
        CALL    lbaToChs                ; LBA → CHS変換

        MOV     AH, 0x02
        MOV     AL, 0x01
        MOV     DL, 0x00                ; CHSは計算済み
        MOV     BX, 0x7000
        INT     0x13

        CMP     AH, 0x00                ; 読み込み失敗時はAH!=0
        JNZ     .chkError

        POP     DX                      ; ループ変数取得
        PUSH    DX
        CALL    printHex
        SUB BYTE[secCursolX], 0x06      ; 繰り返すので戻す

        POP     DX
        INC     DX
        CMP     DX, 65                  ; 64セクタ読む
        JNZ     .chkLoop                ; 64 まで読んだら終わり
        JMP     .chkDone
.chkDone:
        ADD BYTE[secCursolX], 0x07      ; 次の表示のため
        CALL    printDone
        MOV BYTE[secCursolX], 0x00      ; 座標を次の行の先頭へ
        ADD BYTE[secCursolY], 0x01
        JMP     secLoadShell
.chkError:
        ADD BYTE[secCursolX], 0x07      ; 次の表示のため
        CALL    printError
        JMP     secHlt
.preMsg:                                ; "Disk test..."
        DB      "D", "i", "s", "k", " ", "t", "e", "s", "t", ".", ".", "."
        
secLoadShell:
        MOV     DX, 0x0005              ; LBA 5~20 の16セクタを 0x0000 に展開
        CALL    lbaToChs

        MOV     AH, 0x02
        MOV     AL, 0x10
        MOV     DL, 0x00
        MOV     BX, 0x0000
        INT     0x13

        JMP     0x0000                  ; 移動

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

printDone:
        MOV     AH, 0x13
        MOV     AL, 0x01
        MOV     BH, 0x00
        MOV     BL, 0x0f
        MOV     CX, 0x05
        MOV     DL, [secCursolX]
        MOV     DH, [secCursolY]
        MOV     BP, .msg
        INT     0x10
        ADD BYTE[secCursolX], 0x05
        RET
.msg:                                   ; ~"kB, done."
        DB      "d", "o", "n", "e", "."

printError:
        MOV     AH, 0x13
        MOV     AL, 0x01
        MOV     BH, 0x00
        MOV     BL, 0x0f
        MOV     CX, 0x06
        MOV     DL, [secCursolX]
        MOV     DH, [secCursolY]
        MOV     BP, .msg
        INT     0x10
        ADD BYTE[secCursolX], 0x06
        RET
.msg:                                   ; ~"kB, done."
        DB      "e", "r", "r", "o", "r", "!"

; 論理セクタから物理セクタへの変換
; ヘッダ:0~1, シリンダ:0~79, セクタ:1~18
; H = (LBA / 18) % 2
; C = LBA / (18 * 2)
; S = (LBA % 18) + 1
; in : DX       LBA(論理セクタ)
; out: DH       ヘッダ番号
;      CH       シリンダ番号
;      CL       セクタ番号 & (シリンダ番号 & 0x0300) >> 2
lbaToChs:
        PUSH    DX

        POP     AX                      ; ヘッダ計算
        PUSH    AX
        MOV     DX, 0x0000
        MOV     BX, 0x0012              ; 10進数で18
        DIV     BX
        AND     AX, 0x0001              ; 2で割った余り
        MOV BYTE [.head], AL

        POP     AX                      ; シリンダ計算
        PUSH    AX
        MOV     DX, 0x0000
        MOV     BX, 0x0024              ; 10進数で36
        DIV     BX
        MOV BYTE [.cylinder], AL

        POP     AX                      ; セクタ計算
        PUSH    AX
        MOV     BX, 0x0012              ; 10進数で18
        MOV     DX, 0x0000
        DIV     BX                      ; 余りはDXへ
        ADD     DX, 0x0001              ; 純粋なセクタ番号
        MOV     CH, 0x00
        MOV     CL, [.cylinder]
        AND     CX, 0x0300
        SHR     CX, 2
        OR      DX, CX                  ; セクタ番号 & (シリンダ番号 & 0x0300) >> 2
        MOV BYTE [.sector], DL

        MOV     DH, [.head]             ; 結果反映
        MOV     CH, [.cylinder]
        MOV     CL, [.sector]
        POP     AX                      ; 捨てる
        RET
.head:                                  ;ヘッダ番号
        DB      0x00
.cylinder:                              ; シリンダ番号
        DB      0x00
.sector:                                ; セクタ番号
        DB      0x00

; --- 0埋め ---
secEnd:
        times 2048-($-$$) DB 0          ; セカンダリローダは4セクタ
