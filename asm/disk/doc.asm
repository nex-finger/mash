; docディレクトリ
; /.dir
;    ├bin.dir
;    │   └testprg.bin
;    ├usr.dir
;    │   ├doc.dir
;    |   └testtxt.txt
;    └readme.txt
%include        "../asm/define.asm"

        DB      ATR_DIR                 ; アトリビュート
        DB      "doc", 0x00, 0x00, 0x00, 0x00, 0x00 ; ファイル名8文字
        DB      "dir"                   ; 拡張子3文字
        DB      0x25, 0x10, 0x04, 0x06, 0x01, 0x23  ; 作成時刻6バイト
        DB      0x25, 0x10, 0x04, 0x06, 0x01, 0x23  ; 更新時刻6バイト
        DW      DIR_USR                 ; 親ディレクトリ
        DB      0x02                    ; 子ディレクトリは2つ
        DW      DIR_DOC                 ; 子ディレクトリ一覧
        DW      DIR_TESTTXT

		times 512-($-$$) DB 0           ; セクタ末尾まで
