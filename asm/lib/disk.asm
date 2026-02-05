; //////////////////////////////////////////////////////////////////////////// ;
; disk.asm                                                                   ;
; //////////////////////////////////////////////////////////////////////////// ;

; セクタの確保
; セクタ空き状況を確認し、空いているセクタの確認する
; in  : なし
; out : AX      空き→使用中に更新したセクタ番号
libAllocSector:
        CALL    rPushReg

        ; ビットフィールド用のメモリを確保
        MOV     CX, 0x0200              ; 1セクタ=512バイト
        CALL    sysMalloc               ; 確保
        PUSH    BP                      ; 解放のため詰め込む

        ; セクタ読み込み
        MOV     AX, 0x0013              ; セクタ空き状況はセクタ 0x0013
        MOV     SI, BP
        CALL    libReadSector

        ; 空いているビットを確認
        MOV     CX, 0x0000
.checkLoop:
        CALL    libDiskBitGet           ; セクタが空いているか確認
        
        CMP     AH, 0x00
        JZ      .find                   ; 発見した
        INC     CX                      ; 空いていないなら繰り返し
        JMP     .checkLoop

.find:
        MOV WORD [.aRet], CX

        ; ビットフィールド用のメモリを解放
        POP     BP                      ; 確保したポインタを取得
        CALL    sysFree

        CALL    rPopReg
        MOV WORD AX, [.aRet]
        RET
.aRet:
        DW      0x0000

; セクタの解放
; セクタを空き状態にする
; in  : AX      使用中→空きに更新するセクタ番号
; out : なし
libFreeSector:
        CALL    rPushReg
        CALL    rPopReg
        RET

; セクタの書き込み
; in  : AX      書き込むセクタ番号
;       SI      書き込むデータポインタ
; out : なし
libWriteSector:
        CALL    rPushReg
        CALL    rPopReg
        RET

; セクタの読み込み
; in  : AX      読み込むセクタ番号
; i/o : SI      読み込んだデータポインタ
libReadSector:
        CALL    rPushReg
        CALL    rPopReg
        RET

; //////////////////////////////////////////////////////////////////////////// ;
; サブルーチン
; //////////////////////////////////////////////////////////////////////////// ;

; 論理セクタから物理セクタへの変換
; ヘッダ:0~1, シリンダ:0~79, セクタ:1~18
; H = (LBA / 18) % 2
; C = LBA / (18 * 2)
; S = (LBA % 18) + 1
; in : DX       LBA(論理セクタ)
; out: DH       ヘッダ番号
;      CH       シリンダ番号
;      CL       セクタ番号 & (シリンダ番号 & 0x0300) >> 2
lbaToChs:
        CALL    rPushReg

        PUSH    DX

        POP     AX                      ; ヘッダ計算
        PUSH    AX
        MOV     DX, 0x0000
        MOV     BX, 0x0012              ; 10進数で18
        DIV     BX
        AND     AX, 0x0001              ; 2で割った余り
        MOV BYTE [.head], AL

        POP     AX                      ; シリンダ計算
        PUSH    AX
        MOV     DX, 0x0000
        MOV     BX, 0x0024              ; 10進数で36
        DIV     BX
        MOV BYTE [.cylinder], AL

        POP     AX                      ; セクタ計算
        PUSH    AX
        MOV     BX, 0x0012              ; 10進数で18
        MOV     DX, 0x0000
        DIV     BX                      ; 余りはDXへ
        ADD     DX, 0x0001              ; 純粋なセクタ番号
        MOV     CH, 0x00
        MOV     CL, [.cylinder]
        AND     CX, 0x0300
        SHR     CX, 2
        OR      DX, CX                  ; セクタ番号 & (シリンダ番号 & 0x0300) >> 2
        MOV BYTE [.sector], DL

        POP     AX                      ; 捨てる

        CALL    rPopReg

        MOV     DH, [.head]             ; 結果反映
        MOV     CH, [.cylinder]
        MOV     CL, [.sector]

        RET
.head:                                  ;ヘッダ番号
        DB      0x00
.cylinder:                              ; シリンダ番号
        DB      0x00
.sector:                                ; セクタ番号
        DB      0x00

; ビットフィールドに内容を書き込む
; in  : CX      書き込むビット目
;       SI      書き込むビットフィールドの先頭ポインタ
;       AH      書き込む値(0 or 1)
; out : なし
libDiskBitSet:
        CALL    rPushReg
        CALL    rPopReg
        RET

; ビットフィールドの内容を取得する
; in  : CX      読み込むビット目
;       SI      読み込むビットフィールドの先頭ポインタ
; out : AH      読み込んだ値(0 or 1)
libDiskBitGet:
        CALL    rPushReg
        CALL    rPopReg
        RET