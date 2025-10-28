; //////////////////////////////////////////////////////////////////////////// ;
; type.asm                                                                     ;
;       libIsalnum      libIsAlpha      libIsblank      libIscntrl             ;
;       libIsdigit      libIsgraph      libIslower      libIsprint             ;
;       libIspuct       libIsspace      libIsupper      libIsxdigit            ;
;       libTolower      libToupper                                             ;
; //////////////////////////////////////////////////////////////////////////// ;

; 英大文字か判定
; isupper(c89) 相当
; in  : AL      asciiコード
; out : AH      0: 大文字以外
;               0以外: 大文字
libIsupper:
        CMP     AL, 0x41                ; A
        JB      .ng                     ; AL < 'A' ならNG
        CMP     AL, 0x5a                ; Z
        JA      .ng                     ; AL > 'Z' ならNG
.ok:
        MOV     AH, 0x01                ; OKなら 1 を返却
        JMP     .exit
.ng:
        MOV     AH, 0x00                ; NGなら 0 を返却
        JMP     .exit
.exit:
        RET

; 英小文字か判定
; isupper(c89) 相当
; in  : AL      asciiコード
; out : AH      0: 小文字以外
;               0以外: 小文字
libIslower:
        CMP     AL, 0x61                ; a
        JB      .ng                     ; AL < 'a' ならNG
        CMP     AL, 0x7a                ; z
        JA      .ng                     ; AL > 'z' ならNG
.ok:
        MOV     AH, 0x01                ; OKなら 1 を返却
        JMP     .exit
.ng:
        MOV     AH, 0x00                ; NGなら 0 を返却
        JMP     .exit
.exit:
        RET

; 数字か判定
; isdigit(c89) 相当
; in  : AL      asciiコード
; out : AH      0: 小文字以外
;               0以外: 小文字
libIsdigit:
        CMP     AL, 0x30                ; 0
        JB      .ng                     ; AL < '0' ならNG
        CMP     AL, 0x39                ; 9
        JA      .ng                     ; AL > '9' ならNG
.ok:
        MOV     AH, 0x01                ; OKなら 1 を返却
        JMP     .exit
.ng:
        MOV     AH, 0x00                ; NGなら 0 を返却
        JMP     .exit
.exit:
        RET

; 空白文字を含む表示文字か判定
; isprint(c89) 相当
; in  : AL      asciiコード
; out : AH      0: 表示文字以外
;               0以外: 表示文字
libIsprint:
        CMP     AL, 0x20
        JB      .ng                     ; AL < 0x20 ならNG
        CMP     AL, 0x7e
        JA      .ng                     ; AL > 0x7e ならNG
.ok:
        MOV     AH, 0x01                ; OKなら 1 を返却
        JMP     .exit
.ng:
        MOV     AH, 0x00                ; NGなら 0 を返却
        JMP     .exit
.exit:
        RET

; 空白文字を除く表示文字か判定
; isprint(c89) 相当
; in  : AL      asciiコード
; out : AH      0: 表示文字以外
;               0以外: 表示文字
libIsgraph:
        CMP     AL, 0x21
        JB      .ng                     ; AL < 0x21 ならNG
        CMP     AL, 0x7e
        JA      .ng                     ; AL > 0x7e ならNG
.ok:
        MOV     AH, 0x01                ; OKなら 1 を返却
        JMP     .exit
.ng:
        MOV     AH, 0x00                ; NGなら 0 を返却
        JMP     .exit
.exit:
        RET

; ブランク文字か判定
; isblank(c89) 相当
; in  : AL      asciiコード
; out : AH      0: ブランク文字以外
;               0以外: ブランク文字
libIsblank:
        CMP     AL, 0x20                ; ' 'ならOK
        JZ      .ok
        CMP     AL, 0x09
        JZ      .ok                     ; '\t'ならOK
        JMP     .ng
.ok:
        MOV     AH, 0x01                ; OKなら 1 を返却
        JMP     .exit
.ng:
        MOV     AH, 0x00                ; NGなら 0 を返却
        JMP     .exit
.exit:
        RET

; 空白類文字か判定
; isspace(c89) 相当
; in  : AL      asciiコード
; out : AH      0: 空白類文字以外
;               0以外: 空白類文字
libIsspace:
        CMP     AL, 0x09
        JZ      .ok                     ; '\t'ならOK
        CMP     AL, 0x0a
        JZ      .ok                     ; '\n'ならOK
        CMP     AL, 0x0b
        JZ      .ok                     ; '\v'ならOK
        CMP     AL, 0x0c
        JZ      .ok                     ; '\f'ならOK
        CMP     AL, 0x0d
        JZ      .ok                     ; '\r'ならOK
        CMP     AL, 0x20
        JZ      .ok                     ; ' 'ならOK
        JMP     .ng
.ok:
        MOV     AH, 0x01                ; OKなら 1 を返却
        JMP     .exit
.ng:
        MOV     AH, 0x00                ; NGなら 0 を返却
        JMP     .exit
.exit:
        RET

; 制御文字か判定
; iscntrl(c89) 相当
; in  : AL      asciiコード
; out : AH      0: 制御文字以外
;               0以外: 制御文字
libIscntrl:
        CMP     AL, 0x7f
        JZ      .ok                     ; '\del'ならOK
        CMP     AL, 0x00
        JB      .ng                     ; AL < 0x00 ならNG
        CMP     AL, 0x1f
        JA      .ng                     ; AL > 0x1f ならNG
.ok:
        MOV     AH, 0x01                ; OKなら 1 を返却
        JMP     .exit
.ng:
        MOV     AH, 0x00                ; NGなら 0 を返却
        JMP     .exit
.exit:
        RET 

; 16進数字か判定
; isxdigit(c89) 相当
; in  : AL      asciiコード
; out : AH      0: 16進文字以外
;               0以外: 16進文字
libIsxdigit:
        CMP     AL, 0x30                ; 0
        JB      .next1                  ; AL < '0' ならNG
        CMP     AL, 0x39                ; 9
        JA      .next1                  ; AL > '9' ならNG
        JMP     .ok
.next1:
        CMP     AL, 0x41                ; A
        JB      .next2                  ; AL < 'A' ならNG
        CMP     AL, 0x46                ; F
        JA      .next2                  ; AL > 'F' ならNG
        JMP     .ok
.next2:
        CMP     AL, 0x61                ; a
        JB      .ng                     ; AL < 'a' ならNG
        CMP     AL, 0x66                ; f
        JA      .ng                     ; AL > 'f' ならNG
        JMP     .ok
.ok:
        MOV     AH, 0x01                ; OKなら 1 を返却
        JMP     .exit
.ng:
        MOV     AH, 0x00                ; NGなら 0 を返却
        JMP     .exit
.exit:
        RET 

; 英文字か判定
; isalpha(c89) 相当
; in  : AL      asciiコード
; out : AH      0: 英文字以外
;               0以外: 英文字
libIsalpha:
        CALL    libIsupper              ; 大文字か確認
        CMP     AH, 0x00
        JNZ     .ok
        CALL    libIslower              ; 小文字か確認
        CMP     AH, 0x00
        JNZ     .ok
        JMP     .ng
.ok:
        MOV     AH, 0x01                ; OKなら 1 を返却
        JMP     .exit
.ng:
        MOV     AH, 0x00                ; NGなら 0 を返却
        JMP     .exit
.exit:
        RET 

; 英文字or数字か判定
; isalnum(c89) 相当
; in  : AL      asciiコード
; out : AH      0: 英文字でも数字でもない
;               0以外: 英文字or数字
libIsalnum:
        CALL    libIsupper              ; 大文字か確認
        CMP     AH, 0x00
        JNZ     .ok
        CALL    libIslower              ; 小文字か確認
        CMP     AH, 0x00
        JNZ     .ok
        CALL    libIsdigit              ; 数字か確認
        CMP     AH, 0x00
        JNZ     .ok
        JMP     .ng
.ok:
        MOV     AH, 0x01                ; OKなら 1 を返却
        JMP     .exit
.ng:
        MOV     AH, 0x00                ; NGなら 0 を返却
        JMP     .exit
.exit:
        RET 

; 区切り文字か判定(区切り文字 = (!(isalnum) & isgraph)
; ispunct(c89) 相当
; in  : AL      asciiコード
; out : AH      0: 区切り文字以外
;               0以外: 区切り文字
libIspunct:
        CALL    libIsalnum              ; 英文字or数字か確認
        CMP     AH, 0x00
        JNZ     .ng                     ; 英文字or数字ならNG
        CALL    libIsgraph              ; 空白を除く印字可能文字か確認
        CMP     AH, 0x00
        JNZ     .ok                     ; 印字可能文字ならOK
        JMP     .ng
.ok:
        MOV     AH, 0x01                ; OKなら 1 を返却
        JMP     .exit
.ng:
        MOV     AH, 0x00                ; NGなら 0 を返却
        JMP     .exit
.exit:
        RET

; 大文字を小文字に変換
; tolower(c89) 相当
; in  : AL      asciiコード
; out : AH      変換後asciiコード
libTolower:
        CALL    libIsupper              ; 大文字か判定
        CMP     AH, 0x00
        JZ      .exit                   ; 大文字ではないなら変換しない
        ADD     AL, 0x20
.exit:
        MOV     AH, AL
        RET

; 小文字を大文字に変換
; toupper(c89) 相当
; in  : AL      asciiコード
; out : AH      変換後asciiコード
libToupper:
        CALL    libIslower              ; 小文字か判定
        CMP     AH, 0x00
        JZ      .exit                   ; 小文字ではないなら変換しない
        SUB     AL, 0x20
.exit:
        MOV     AH, AL
        RET
