; //////////////////////////////////////////////////////////////////////////// ;
; cast.h
; //////////////////////////////////////////////////////////////////////////// ;

; 2バイト変数を16進文字列へ変換
; in  : AX      変換元の2バイト即値
; i/o   SI      変換結果を格納する先頭アドレス
libitox:
        CALL    rPushReg

        CALL    rPopReg
        RET

; ファイル内サブルーチン

; 16進数値 → 16進文字 (1文字)
; in  : AH      16進数値(0x00 ~ 0x0f)
; out : AL      16進文字('0' ~ 'f')
ritox1digit:
        CALL    rPushReg

        AND     AH, 0x0f                    ; 上4ビットを無効化
        CMP     AH, 0x09
        JA      .transaf
.trans09:                               ; 0~9
        MOV BYTE [.aRet], AH
        ADD BYTE [.aRet], "0"
.transaf:
        MOV BYTE [.aRet], AH                 ; a~f
        SUB BYTE [.aRet], 10
        ADD BYTE [.aRet], "a"

        CALL    rPopReg

        MOV BYTE AL, [.aRet]                 ; 戻り値設定
        RET
.aRet:
        DB      0x00
