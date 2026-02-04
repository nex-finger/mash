; //////////////////////////////////////////////////////////////////////////// ;
; disk.asm                                                                   ;
; //////////////////////////////////////////////////////////////////////////// ;

; セクタの確保
; セクタ空き状況を確認し、空いているセクタの確認する
; in  : なし
; out : AX      空き→使用中に更新したセクタ
libAllocSector:
        CALL    rPushReg
        CALL    rPopReg
        RET

; サブルーチン

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