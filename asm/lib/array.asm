; //////////////////////////////////////////////////////////////////////////// ;
; array.h
;       libMemcpy
;       libMemcmp
;       libMemchr
;       libMemset
; //////////////////////////////////////////////////////////////////////////// ;

; メモリのコピー
; memcpy(c89相当)
; in  : SI      コピー元のアドレス
;       CX      コピーするサイズ
; out : DI      コピー先のアドレス
libMemcpy:
        CALL    rPushReg                ; レジスタ退避

        CMP     CX, 0x0000              ; サイズチェック
        JZ      .exit

.fillLoop:
        MOV BYTE AH, [SI]
        MOV BYTE [DI], AH
        INC     SI
        INC     DI
        DEC     CX
        
        CMP     CX, 0x0000
        JNZ     .fillLoop

.exit:
        CALL    rPopReg                 ; レジスタ取得
        RET

; メモリの比較
; memcmp(c89相当)
; in  : SI      比較先頭アドレス１
;       DI      比較先頭アドレス２
;       CX      比較サイズ
; out : AX      0x0000: 一致
;               0x0001: アドレス１が大きい
;               0xffff: アドレス２が大きい
libMemcmp:
        CALL    rPushReg
        MOV WORD [.aRet], 0x0000

        CMP     CX, 0x0000
        JZ      .exit

        MOV     AX, 0x0000

.cmpLoop:
        ADD     SI, AX                  ; オフセット追加
        ADD     DI, AX

        MOV BYTE BH, [SI]               ; [SI+AX]
        MOV BYTE BL, [DI]

        SUB     SI, AX                  ; オフセットリセット
        SUB     DI, AX

        CMP     BH, BL
        JA      .upper                  ; BH > BLなら0x0001を返却
        CMP     BH, BL
        JB      .lower                  ; BH < BLなら0xffffを返却
        
        INC     AX
        CMP     AX, CX
        JZ      .exit
        JMP     .cmpLoop

.upper:
        MOV WORD [.aRet], 0x0001
        JMP     .exit
.lower:
        MOV WORD [.aRet], 0xffff
        JMP     .exit
.exit:
        CALL    rPopReg
        MOV WORD AX, [.aRet]
        RET
.aRet:
        DW      0x0000

; メモリの探索
; memchr(c89相当)
; in  : SI      探索する先頭アドレス
;       AH      ヒットするバイトデータ
;       CX      探索する文字数
; out : DI      0x0000: 一致データなし
;               0x0000以外: 最初に一致したアドレス
libMemchr:
        CALL    rPushReg
        CALL    rPopReg
        RET

; メモリの初期化
; memset(c89相当)
; in  : SI      初期化先頭アドレス
;       AH      埋めるデータ
;       CX      埋めるデータサイズ
libMemset:
        CALL    rPushReg
        CALL    rPopReg
        RET