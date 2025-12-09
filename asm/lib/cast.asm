; //////////////////////////////////////////////////////////////////////////// ;
; cast.h                                                                       ;
; //////////////////////////////////////////////////////////////////////////// ;

%ifndef     __CAST_ASM
%define     __CAST_ASM

; 2バイト変数を16進文字列へ変換
; Int -> heX
; in  : AX      変換元の2バイト即値
; i/o   SI      変換結果を格納する先頭アドレス(4バイト消費)
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
        RET
.aInput:
        DW      0x0000
.aRet:
        DW      0x0000

; ファイル内サブルーチン

; 2バイト変数を10進文字列へ変換
; Int -> Decimal
; in  : AX      変換元の2バイト即値
; i/o : SI      変換結果を格納する先頭アドレス(8バイト消費)
libitod:
        CALL    rPushReg

        ; 引数格納
        MOV WORD [.inValue], AX
        MOV WORD [.inAddress], SI

        ; 正の数か負の数か確認する
        MOV WORD AX, [.inValue]
        CMP     AX, 0x8000              ; 0x8000 = 0(10進)
        JA      .aSign_plus             ; 0x8000異常で正
        JMP     .aSign_minus            ; 0x8000未満で負

.aSign_plus:                            ; 1文字目は"+"
        MOV WORD BP, [.inAddress]
        MOV BYTE [BP], 0x2B
        INC     BP
        MOV WORD [.inAddress], BP
        JMP     .aSign_next
.aSign_minus:                           ; 1文字目は"-"
        MOV WORD BP, [.inAddress]
        MOV BYTE [BP], 0x2D
        INC     BP
        MOV WORD [.inAddress], BP
        JMP     .aSign_next
.aSign_next:
        ; 2025/12/10 ここまで

.exit:
        CALL    rPopReg
        RET
.inValue:                               ; 入力即値
        DW      0x0000
.inAddress:                             ; 入力ポインタ
        DW      0x0000

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

%endif  ; __CAST_ASM