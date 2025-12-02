; //////////////////////////////////////////////////////////////////////////// ;
; cast.h                                                                       ;
; //////////////////////////////////////////////////////////////////////////// ;

; 2バイト変数を16進文字列へ変換
; in  : AX      変換元の2バイト即値
; i/o   SI      変換結果を格納する先頭アドレス
libitox:
        CALL    rPushReg

        MOV WORD [.aInput], AX
        MOV WORD [.aRet], SI

        ; debug
        ;MOV BYTE [SI], "1"
        ;INC     SI
        ;MOV BYTE [SI], "2"
        ;INC     SI
        ;MOV BYTE [SI], "3"
        ;INC     SI
        ;MOV BYTE [SI], "4"
        ;JMP     .exit

        ; 1文字目
        MOV     AX, [.aInput]
        AND     AX, 0xf000
        SHR     AH, 4
        CALL    ritox1digit
        MOV BYTE [SI], AL
        INC     SI

        ; 2文字目
        MOV     AX, [.aInput]
        AND     AX, 0x0f00
        CALL    ritox1digit
        MOV BYTE [SI], AL
        INC     SI

        ; 3文字目
        MOV     AX, [.aInput]
        AND     AX, 0x00f0
        MOV     AH, AL
        SHR     AH, 4
        CALL    ritox1digit
        MOV BYTE [SI], AL
        INC     SI

        ; 4文字目
        MOV     AX, [.aInput]
        AND     AX, 0x000f
        MOV     AH, AL
        CALL    ritox1digit
        MOV BYTE [SI], AL
        INC     SI

.exit:
        CALL    rPopReg
        MOV     SI, [.aRet]
        RET
.aInput:
        DW      0x0000
.aRet:
        DW      0x0000

; ファイル内サブルーチン

; 16進数値 → 16進文字 (1文字)
; in  : AH      16進数値(0x00 ~ 0x0f)
; out : AL      16進文字('0' ~ 'f')
ritox1digit:
        CALL    rPushReg

        AND     AH, 0x0f                    ; 上4ビットを無効化
        CMP     AH, 0x09
        JA      .transaf
.trans09:                                   ; 0~9
        MOV BYTE [.aRet], AH
        ADD BYTE [.aRet], 0x30              ; "0"
        JMP     .exit
.transaf:
        MOV BYTE [.aRet], AH                ; a~f
        SUB BYTE [.aRet], 10
        ADD BYTE [.aRet], 0x41              ; A
        JMP     .exit

.exit:
        CALL    rPopReg

        MOV BYTE AL, [.aRet]                 ; 戻り値設定
        RET
.aRet:
        DB      0x00
