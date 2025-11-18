; //////////////////////////////////////////////////////////////////////////// ;
; string.h
; //////////////////////////////////////////////////////////////////////////// ;

; 文字列の分割
; in  : SI      null: 続行
;               null以外: 新規文字列先頭ポインタ
;       AH      区切り文字
; out : DI      null: 区切る文字列はない
;               null以外: 区切った文字列先頭ポインタ
; SI!=null の場合、SIから新しく文字列を分割する
; SI==null の場合、前回保持したポインタから続行する
libStrtok:
        CALL    rPushReg

        CMP     SI, _NULL
        JZ      .inputNull
        JMP     .inputNotNull
.inputNull:
        MOV WORD .aTopAddr, .aHoldAddr
.inputNotNull:
        MOV WORD .aTopAddr, SI


        CALL    rPopReg
        RET
.aTopAddr:                              ; 文字列
        DW      0x0000
.aRet:                                  ; 戻り値
        DW      0x0000
.aHoldAddr:                             ; 前回の保持アドレス
        DW      0x0000