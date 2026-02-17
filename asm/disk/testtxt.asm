; binディレクトリ
; /.dir
;    ├bin.dir
;    │   └testprg.bin
;    ├usr.dir
;    │   ├doc.dir
;    |   └testtxt.txt
;    └readme.txt
%include        "../asm/define.asm"

        DB      ATR_FILE                ; アトリビュート
        DB      "testtxt", 0x00 ; ファイル名8文字
        DB      "txt"                   ; 拡張子3文字
        DB      0x25, 0x10, 0x04, 0x06, 0x01, 0x23  ; 作成時刻6バイト
        DB      0x25, 0x10, 0x04, 0x06, 0x01, 0x23  ; 更新時刻6バイト
        DW      DIR_BIN                 ; 親ディレクトリ
        DB      0x01                    ; ファイルサイズ
        DW      DIR_TESTPRG_CONTENT     ; ファイルチェーン

		times 512-($-$$) DB 0           ; セクタ末尾まで

        DB      "Hello, World!!", 0x0a
        DB      "Welcome to my OS!!", 0x0a
        DB      "My name is Masuda Mizuki.", 0x0a

        times 1024-($-$$) DB 0          ; セクタ末尾まで
