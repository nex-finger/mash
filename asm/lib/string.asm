; //////////////////////////////////////////////////////////////////////////// ;
; string.h
; //////////////////////////////////////////////////////////////////////////// ;

; 文字の探索
; strchr(c89)相当
; in  : SI      探索する文字列
;       AH      区切り文字
; out : DI      null: 区切り文字は存在しない
;               null以外: 最初に発見したアドレス
libStrchr:
        CALL    rPushReg

        CALL    rPopReg
        RET

; 文字列の分割
; strtok(c89)相当
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
.inputNull:                             ; 入力パラメータがnullなら前回から続行
        MOV WORD .aTopAddr, .aHoldAddr
        JMP     .mainLoutine
.inputNotNull:                          ; 入力パラメータがnullでないなら新規
        MOV WORD .aTopAddr, SI
        JMP     .mainLoutine

.mainLoutine:
        ; 区切り文字のアドレスを取得する
        CALL    libStrchr               ; DIに区切り文字のアドレス

        CMP     DI, _NULL
        JZ      .retNull                ; 区切り文字はもうない

        ; 先頭アドレスから区切り文字までの文字列をコピーするメモリを取得する
        MOV     CX, DI                  ; コピーする領域 = DI - SI
        SUB     CX, SI
        CALL    sysMalloc               ; メモリを取得

        ; 取得したメモリにコピーする
        CALL    libMemcpy

.retNull:                               ; 区切り文字は見つからなかった
        MOV WORD .aRet, _NULL
        JMP     .exit

.exit:
        CALL    rPopReg
        MOV WORD DI, [.aRet]
        RET
.aTopAddr:                              ; 文字列
        DW      0x0000
.aRet:                                  ; 戻り値
        DW      0x0000
.aHoldAddr:                             ; 前回の保持アドレス
        DW      0x0000
.aTokAddr:                              ; 発見した区切り文字のアドレス
        DW      0x0000