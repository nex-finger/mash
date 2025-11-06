; //////////////////////////////////////////////////////////////////////////// ;
; cursol.asm                                                                     ;
;       libSetCursol            libSlideDisp            libSetCursolNextCol    ;
;       libSetCursolNextLine                                                   ;
; //////////////////////////////////////////////////////////////////////////// ;

; カーソル表示更新
; in  : (なし)
; out : (なし)
libSetCursol:
        CALL    rPushReg                ; レジスタ退避

        MOV     AH, 0x02
        MOV     BH, 0x00
        MOV BYTE DL, [sXpos]
        MOV BYTE DH, [sYpos]
        INT     0x10

        CALL    rPopReg                 ; レジスタ取得
        RET

; 画面表示を1行上に移動
; in  : (なし)
; out : (なし)
libSlideDisp:
        CALL    rPushReg                ; レジスタ退避

        MOV     AH, 0x06
        MOV     AL, 0x01
        MOV     BH, 0x07
        MOV     CX, 0x0000
        MOV     DH, 24
        MOV     DL, 79
        INT     0x10

        CALL    rPopReg                 ; レジスタ取得
        RET

; カーソルを次の列へ
; in  : (なし)
; out : (なし)
libSetCursolNextCol:
        CALL    rPushReg                ; レジスタ退避

        MOV BYTE AH, [sXpos]            ; 取得
        MOV BYTE AL, [sYpos]

        CMP     AH, DISP_COLSIZE
        JZ      .newLine

        INC     AH
        MOV BYTE [sXpos], AH            ; 設定
        MOV BYTE [sYpos], AL
        CALL    rSetCursol              ; カーソル表示更新
        JMP     .next
.newLine:
        CALL    libSetCursolNextLine
.next:
        CALL    rPopReg                 ; レジスタ取得
        RET

; カーソルを次の行へ
; in  : (なし)
; out : (なし)
libSetCursolNextLine:
        CALL    rPushReg                ; レジスタ退避
        PUSH    DS
        PUSH    ES

        MOV     AX, 0x0000
        MOV     DS, AX
        MOV     ES, AX

        MOV BYTE AH, [sXpos]            ; 取得
        MOV BYTE AL, [sYpos]

        CMP     AL, DISP_LINESIZE
        JNZ     .nextLine               ; 一番下じゃないなら普通の改行
        CMP     AH, DISP_COLSIZE
        JNZ     .slideLine              ; 一番右じゃないならスクロール(79列目に出力するとBIOS側でスクロールする)
        JMP     .nonSlide
.nextLine:
        MOV     AH, 0x00
        INC     AL

        MOV BYTE [sXpos], AH            ; 設定
        MOV BYTE [sYpos], AL
        JMP     .setCursol
.slideLine:
        CALL    libSlideDisp
.nonSlide:
        MOV BYTE [sXpos], 0x00          ; 設定
        MOV BYTE [sYpos], DISP_LINESIZE
.setCursol:                             ; カーソル位置更新
        CALL    rSetCursol

        POP     ES
        POP     DS
        CALL    rPopReg                 ; レジスタ取得
        RET
