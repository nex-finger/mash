; //////////////////////////////////////////////////////////////////////////// ;
; cast.h                                                                       ;
; //////////////////////////////////////////////////////////////////////////// ;

%ifndef     __CAST_ASM
%define     __CAST_ASM

; 文字列を2バイト変数へ変換
; 16進数、10進数、文字
; in  : SI      変換元の文字列(ヌル文字を必ず最後につけること)
;                       16進数: 0x????
;                       10進数: ?????(マイナスOK)
;                       ascii:   "?"
; out : AX      変換後の16ビット即値
libstoi:
        CALL    rPushReg

        ; 将来的にここで文字列の構文解析を行う？

        MOV     DI, SI
        MOV BYTE AH, [DI]               ; 1文字目取得
        CMP     AH, 0x22                ; "=0x22
        JZ      .caseAscii              ; ascii変換
        INC     DI
        MOV BYTE AH, [DI]               ; 2文字目取得(1文字目だけでは10進か16進か判断できないため)
        CMP     AH, "x"
        JZ      .caseHex
        JMP     .caseDecimal

.fillNumber:

        CALL    rPopReg
        MOV WORD AX, [.aRet]
        RET

; ascii→数値の変換
.caseAscii:
        INC     SI                      ; 変換したいデータは2文字目なので("a")
        MOV BYTE AL, [SI]
        MOV     AH, 0                   ; 下8bitにデータを
        JMP     .fillNumber
.caseHex:
        MOV     BH, 1                   ; 0xあり
        CALL    libxtoi
        JMP     .fillNumber
.caseDecimal:
        CALL    libdtoi
        JMP     .fillNumber
.aRet:                                  ; 変換した16ビット
        DW      0x0000

; 10進文字列を2バイト変数へ変換(sint用)
; -32768 ~ 32767 の範囲外については処理系依存
; Decimal -> Int
; in  : SI      変換元の10進文字列(ヌル文字を必ず最後につけること)
; out : AX      変換後の16ビット即値
libdtoi:
        CALL    rPushReg

        ; 1文字目に "+" か "-" があれば考慮する
        MOV BYTE AH, [SI]
        CMP     AH, "+"
        JZ      .firstPlus              ; 1文字目が "+" なら1文字シーク
        CMP     AH, "-"
        JZ      .firstMinus             ; 1文字目が "-" なら1文字シークと反転
        JMP     .firstNon               ; 1文字目がなにもなければそのまま
.firstPlus:
        MOV     BL, 0x00                ; BLが 0 なら符号反転なし
        INC     SI                      ; 1文字シーク
        JMP     .firstNext
.firstMinus:
        MOV     BL, 0x01                ; BLが 1 なら符号反転あり
        INC     SI                      ; 1文字シーク
        JMP     .firstNext
.firstNon:
        MOV     BL, 0x00
        JMP     .firstNext

.firstNext:
        ; 10進を格納していく
        MOV     CX, 0x0000

.fillLoop:
        MOV BYTE AH, [SI]
        CMP     AH, 0x00
        JZ      .inverse                ; ヌル文字まで到達した場合終了する

        ADD     CX, CX                  ; 10倍にする、現在2倍
        MOV     DX, CX
        ADD     CX, DX                  ; 4倍
        ADD     CX, DX                  ; 6倍
        ADD     CX, DX                  ; 8倍
        ADD     CX, DX                  ; 10倍

        CALL    rdtoi1digit
        CMP     AL, 0xff
        JZ      .inputError             ; 入力文字が異常の場合終了

        MOV     AH, 0x00
        ADD     CX, AX
        INC     SI
        JMP     .fillLoop

.inputError:                            ; 入力文字列が異常の場合
        JMP     .inputError             ; 一旦

.inverse:
        ; 符号反転を行うかチェックし、必要な場合反転する
        CMP     BL, 0x00
        JZ      .fillPlus               ; 0x8000 が数値 0 を表す
        JMP     .fillMinus
.fillPlus:
        ADD     CX, 0x8000
        JMP     .exit
.fillMinus:
        MOV     DX, CX
        MOV     CX, 0x8000
        SUB     CX, DX
        JMP     .exit

.exit:
        MOV WORD [.aRet], CX

        CALL    rPopReg
        MOV WORD AX, [.aRet]
        RET
.aRet:                                  ; 変換した16ビット
        DW      0x0000

; 16進文字列を2バイト変数へ変換(uint用)
; 0x???? もしくは ????? の記述方法が可能
; heX -> Int
; in  : SI      変換元の10進文字列(ヌル文字を必ず差愛護につけること)
; out : AX      変換後の16ビット即値
libxtoi:
        CALL    rPushReg
        CALL    rPopReg
        RET

; 1バイト変数を16進文字列へ変換
; Int -> heX
; in  : AH      変換元の1バイト即値
;       BH      0: 0xなし
;               1: 0xあり
; i/o : SI      変換結果を格納する先頭アドレス(最大5バイト消費)
libitob:
        CALL    rPushReg

        MOV BYTE [.aInput], AH

        CMP     BH, 0x00                ; "0x"つけるか確認
        JZ      .null_set               ; なし
        MOV BYTE [SI], "0"              ; あり
        INC     SI
        MOV BYTE [SI], "x"
        INC     SI

.null_set:
        ADD     SI, 2                   ; null文字セット
        MOV BYTE [SI], 0x00
        SUB     SI, 2

        ; 1文字目
        MOV BYTE AH, [.aInput]
        AND     AH, 0xf0
        SHR     AH, 4
        CALL    ritox1digit
        MOV BYTE [SI], AL
        INC     SI

        ; 2文字目
        MOV     AX, [.aInput]
        AND     AX, 0x0f
        CALL    ritox1digit
        MOV BYTE [SI], AL
        INC     SI

.exit:
        CALL    rPopReg
        RET
.aInput:
        DB      0x00

; 2バイト変数を16進文字列へ変換
; Int -> heX
; in  : AX      変換元の2バイト即値
;       BH      0: 0xなし
;               1: 0xあり
; i/o : SI      変換結果を格納する先頭アドレス(最大7バイト消費)
libitox:
        CALL    rPushReg

        MOV WORD [.aInput], AX

        CMP     BH, 0x00                ; "0x"つけるか確認
        JZ      .null_set               ; なし
        MOV BYTE [SI], "0"              ; あり
        INC     SI
        MOV BYTE [SI], "x"
        INC     SI

.null_set:
        ADD     SI, 4                   ; null文字セット
        MOV BYTE [SI], 0x00
        SUB     SI, 4

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

; 2バイト変数を10進文字列へ変換
; -32768は表示不可(-32767～+32767)
; Int -> Decimal
; in  : AX      変換元の2バイト即値
; i/o : SI      変換結果を格納する先頭アドレス(最大7バイト消費)
libitod:
        CALL    rPushReg

        ; 引数格納
        MOV WORD [.inValue], AX
        MOV WORD [.inAddress], SI

        ; 正の数か負の数か確認する
        MOV WORD AX, [.inValue]
        CMP     AX, 0x8000              ; 0x8000 = 0(10進)
        JA      .sign_plus              ; 0x8000以上で正
        JMP     .sign_minus             ; 0x8000未満で負

.sign_plus:                             ; 1文字目は"+"、絶対値は in-8000
        MOV WORD BP, [.inAddress]
        MOV BYTE [BP], "+"              ; 1文字目セット
        INC     BP
        MOV WORD [.inAddress], BP       ; シーク
        MOV WORD AX, [.inValue]
        SUB     AX, 0x8000
        MOV WORD [.inValue], AX         ; 絶対値セット
        JMP     .sign_next
.sign_minus:                            ; 1文字目は"-"、絶対値は not(in)-7fff
        MOV WORD BP, [.inAddress]
        MOV BYTE [BP], "-"              ; 1文字目セット
        INC     BP
        MOV WORD [.inAddress], BP       ; シーク
        MOV WORD AX, [.inValue]
        NOT     AX
        SUB     AX, 0x7fff
        MOV WORD [.inValue], AX         ; 絶対値セット
        JMP     .sign_next
.sign_next:
        ; メモリ確認 ---->
        PUSH    AX
        MOV WORD AX, [.inValue]
        CALL    dbgPrint16bit           ; デバッグ
        POP     AX
        ; <----

        ; 絶対値から2文字目以降代入(値により2文字目が何を指すかわからない)
        MOV WORD [.aDigit], 10000       ; 最初は10000の位から
        MOV     CX, 0x0005              ; 5回ループ(最大で10進5桁のため)
        PUSH    CX                      ; ループ外PUSH

.fill_loop:
        MOV     BH, "0"                 ; 10000の位計算
        MOV WORD AX, [.inValue]
        MOV WORD DX, [.aDigit]          ; 10^x
.single_loop:
        CMP     AX, DX
        JB      .single_next
        SUB     AX, DX
        MOV WORD [.inValue], AX
        INC     BH
        JMP     .single_loop
.single_next:
        CMP     BH, "0"
        JZ      .single_exit            ; 位が 0 なら格納しない
        MOV WORD BP, [.inAddress]
        MOV BYTE [BP], BH               ; 位が 1 以上なら格納する
        INC     BP                      ; シーク
        MOV WORD [.inAddress], BP
        JMP     .single_exit
.single_exit:
        MOV     DX, 0x0000              ; 10で16bitDIVする
        MOV WORD AX, [.aDigit]
        MOV     BX, 10
        DIV     BX                      ; AX = DXAX / BX
        MOV     [.aDigit], AX

        POP     CX                      ; 可読性のため全部出して戻す
        DEC     CX                      ; 残りループ回数-1
        PUSH    CX

        CMP     CX, 0x0000              ; 5回(5桁)やったらおわり
        JNZ     .fill_loop

.fill_next:
        POP     CX                      ; ループ外POP
        MOV WORD BP, [.inAddress]
        MOV BYTE [BP], 0x0000           ; null文字セット

.exit:
        CALL    rPopReg
        RET
.inValue:                               ; 入力即値(途中から汚される)
        DW      0x0000
.inAddress:                             ; 入力ポインタ
        DW      0x0000
.aDigit:                                ; ループ中のフォーカス桁
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

; 10進文字(1文字) → 10進数値
; in  : AH      10進文字('0' ~ '9')
; out : AL      0x00 ~ 0x09: 正常変換値
;               0xff: 異常変換値
rdtoi1digit:
        CALL    rPushReg

        MOV BYTE [.aRet], 0xff
        CMP     AH, "0"
        JB      .exit
        CMP     AH, "9"
        JA      .exit
        SUB     AH, "0"                 ; 文字コードは連続している
        MOV BYTE [.aRet], AH

.exit:
        CALL    rPopReg
        MOV BYTE AL, [.aRet]
        RET
.aRet:                                  ; 戻り値
        DB      0x00

%endif  ; __CAST_ASM