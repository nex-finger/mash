; //////////////////////////////////////////////////////////////////////////// ;
; string.h                                                                     ;
; //////////////////////////////////////////////////////////////////////////// ;

; 文字列の長さを取得する(null文字を含まない)
; strlen(c89)相当
; in  : SI      取得する文字列
; out : CX      文字列の長さ(\0の直前までカウント)
libStrlen:
        CALL    rPushReg

        MOV WORD [.aRet], SI

        MOV     AH, 0x00                ; null文字が
        CALL    libStrchr               ; 見つかったアドレスを返却する

        MOV WORD BX, [.aRet]
        MOV WORD AX, DI
        SUB     AX, BX
        MOV WORD [.aRet], AX

        CALL    rPopReg
        MOV WORD CX, [.aRet]
        RET
.aRet:
        DW      0x0000

; 文字列の分割
; strtok(c89)相当
; in  : SI      null: 続行
;               null以外: 新規文字列先頭ポインタ
;       AH      区切り文字
; out : DI      区切った文字列先頭ポインタ
;       AL      0x00: 文字列の最後まで区切った
;               0x01: また文字列が残っている
; SI!=null の場合、SIから新しく文字列を分割する
; SI==null の場合、前回保持したポインタから続行する
libStrtok:
        CALL    rPushReg

        MOV BYTE [.aRetAL], 0x01

        CMP     SI, _NULL
        JZ      .inputNull
        JMP     .inputNotNull
.inputNull:                             ; 入力パラメータがnullなら前回から続行
        MOV WORD BP, [.aHoldAddr]
        JMP     .mainLoop1
.inputNotNull:                          ; 入力パラメータがnullでないなら新規
        MOV WORD BP, SI
        JMP     .mainLoop1

.mainLoop1:                             ; 区切り文字が「発見できなくなるまで」進む
        MOV BYTE BH, [BP]
        CMP     BH, AH
        JNZ     .mainNext1              ; 区切り文字でなくなったら脱出
        CMP     BH, 0x00
        JZ      .errorNext              ; nullがきても脱出(エラー)
        INC     BP
        JMP     .mainLoop1
.mainNext1:                             ; 戻り値設定
        MOV WORD [.aRetDI], BP

.mainLoop2:                             ; 区切り文字が「発見できるまで」進む
        MOV BYTE BH, [BP]
        CMP     BH, AH
        JZ      .mainNext2              ; 区切り文字でたら脱出
        CMP     BH, 0x00
        JZ      .mainNext2null          ; nullがきても脱出(エラー)
        INC     BP
        JMP     .mainLoop2
.mainNext2null:
        MOV BYTE [.aRetAL], 0x00
.mainNext2:                             ; static変数に格納
        MOV BYTE [BP], 0x00             ; 終端文字追加
        INC     BP
        MOV WORD [.aHoldAddr], BP
        JMP     .exit
        
.errorNext:
        MOV BYTE [.aRetAL], 0x00
        MOV WORD [.aRetDI], 0x0000
        JMP     .exit
.exit:
        CALL    rPopReg
        MOV WORD DI, [.aRetDI]
        MOV BYTE AL, [.aRetAL]
        RET
.aRetDI:                                ; 戻り値
        DW      0x0000
.aRetAL:                                ; 戻り値
        DB      0x00
.aHoldAddr:                             ; 前回の保持アドレス
        DW      0x0000

; 文字の探索(バグつき)
; strchr(c89)相当
; in  : SI      探索する文字列
;       AH      区切り文字
; out : DI      null: 区切り文字は存在しない
;               null以外: 最初に発見したアドレス
libStrchr:
        CALL    rPushReg

.chkLoop:
        MOV BYTE AL, [SI]
        CMP     AL, AH                  ; 検索したい文字がある場合は発見アドレスを
        JZ      .breakNormal
        CMP     AL, 0x00                ; 文字列の最後まで探してもないならnullを
        JZ      .breakAbnormal
        INC     SI
        JMP     .chkLoop

.breakNormal:
        MOV WORD [.aRet], SI
        JMP     .exit

.breakAbnormal:
        MOV WORD [.aRet], _NULL
        JMP     .exit

.exit:
        CALL    rPopReg
        MOV WORD DI, [.aRet]
        RET
.aRet:
        DW      0x0000