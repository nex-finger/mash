; mash
; TAB=4

; ロゴ
; https://jp.mathworks.com/matlabcentral/fileexchange/181715-makebanner-big-ascii-style-comment-generator

; --- ファイルインクルード ---
%include        "../asm/define.asm"
%define         __DEBUG                 ; デバッグ時に有効

        ORG     0x4000
        JMP     mashInit

; //////////////////////////////////////////////////////////////////////////// ;
; --- 定数 ---
;  ██████╗ ██████╗ ███╗  ██╗ ██████╗████████╗
; ██╔════╝██╔═══██╗████╗ ██║██╔════╝╚══██╔══╝
; ██║     ██║   ██║██╔██╗██║╚█████╗    ██║   
; ██║     ██║   ██║██║╚████║ ╚═══██╗   ██║   
; ╚██████╗╚██████╔╝██║ ╚███║██████╔╝   ██║   
;  ╚═════╝ ╚═════╝ ╚═╝  ╚══╝╚═════╝    ╚═╝   
; //////////////////////////////////////////////////////////////////////////// ;
cMashLogo:                              ; ロゴ(35x6 = 210byte)
        ;       ███╗   ███╗                                                        █████╗                                          ██████╗                                        ██╗  ██╗
        ;       ████╗ ████║                                                       ██╔══██╗                                        ██╔════╝                                        ██║  ██║
        ;       ██╔████╔██║                                                       ██║  ██║                                        ╚█████╗                                         ███████║
        ;       ██║╚██╔╝██║                                                       ███████║                                         ╚═══██╗                                        ██╔══██║
        ;       ██║ ╚═╝ ██║                                                       ██╔══██║                                        ██████╔╝                                        ██║  ██║
        ;       ╚═╝     ╚═╝                                                       ╚═╝  ╚═╝                                        ╚═════╝                                         ╚═╝  ╚═╝
        ;       M                                                                 A                                               S                                               H                                             
        DB      0xdb, 0xdb, 0xdb, 0xbb, 0x20, 0x20, 0x20, 0xdb, 0xdb, 0xdb, 0xbb, 0x20, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xbb, 0x20, 0x20, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xbb, 0xdb, 0xdb, 0xbb, 0x20, 0x20, 0xdb, 0xdb, 0xbb
        DB      0xdb, 0xdb, 0xdb, 0xdb, 0xbb, 0x20, 0xdb, 0xdb, 0xdb, 0xdb, 0xba, 0xdb, 0xdb, 0xc9, 0xcd, 0xcd, 0xdb, 0xdb, 0xbb, 0xdb, 0xdb, 0xc9, 0xcd, 0xcd, 0xcd, 0xcd, 0xbc, 0xdb, 0xdb, 0xba, 0x20, 0x20, 0xdb, 0xdb, 0xba
        DB      0xdb, 0xdb, 0xc9, 0xdb, 0xdb, 0xdb, 0xdb, 0xc9, 0xdb, 0xdb, 0xba, 0xdb, 0xdb, 0xba, 0x20, 0x20, 0xdb, 0xdb, 0xba, 0xc8, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xbb, 0x20, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xba
        DB      0xdb, 0xdb, 0xba, 0xc8, 0xdb, 0xdb, 0xc9, 0xbc, 0xdb, 0xdb, 0xba, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xba, 0x20, 0xc8, 0xcd, 0xcd, 0xcd, 0xdb, 0xdb, 0xbb, 0xdb, 0xdb, 0xc9, 0xcd, 0xcd, 0xdb, 0xdb, 0xba
        DB      0xdb, 0xdb, 0xba, 0x20, 0xc8, 0xcd, 0xbc, 0x20, 0xdb, 0xdb, 0xba, 0xdb, 0xdb, 0xc9, 0xcd, 0xcd, 0xdb, 0xdb, 0xba, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xdb, 0xc9, 0xbc, 0xdb, 0xdb, 0xba, 0x20, 0x20, 0xdb, 0xdb, 0xba
        DB      0xc8, 0xcd, 0xbc, 0x20, 0x20, 0x20, 0x20, 0x20, 0xc8, 0xcd, 0xbc, 0xc8, 0xcd, 0xbc, 0x20, 0x20, 0xc8, 0xcd, 0xbc, 0xc8, 0xcd, 0xcd, 0xcd, 0xcd, 0xcd, 0xbc, 0x20, 0xc8, 0xcd, 0xbc, 0x20, 0x20, 0xc8, 0xcd, 0xbc

cVersionLen:                            ; 版数文字列の長さ
        DW      18

cVersionStr:                            ; 版数文字列の内容
        DB      "mash system v0.1.1"

; //////////////////////////////////////////////////////////////////////////// ;
; --- 変数 ---
;  ██████╗████████╗ █████╗ ████████╗██╗ ██████╗
; ██╔════╝╚══██╔══╝██╔══██╗╚══██╔══╝██║██╔════╝
; ╚█████╗    ██║   ██║  ██║   ██║   ██║██║     
;  ╚═══██    ██║   ███████║   ██║   ██║██║     
; ██████╔╝   ██║   ██╔══██║   ██║   ██║╚██████╗
; ╚═════╝    ╚═╝   ╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝
; //////////////////////////////////////////////////////////////////////////// ;

; 表示関連
sXpos:
        DB      0x00                    ; 表示xカーソル
sYpos:
        DB      0x09                    ; 表示yカーソル
sColorNormal:
        DB      0x0f                    ; 表示色(初期値: 白)
sColorError:
        DB      0x01                    ; 表示色(初期値: 赤?)

; 入出力関連
sStdInput:                              ; 標準入力
        DB      FD_KEYBORD
sStdOut:                                ; 標準出力
        DB      FD_DISPLAY
sStdErrout:                             ; 標準エラー出力
        DB      FD_DISPLAY
sOneLineBuf:
        times   0x0100 DB 0x00          ; 入力バッファ(256byte)
sOneLineSeek:
        DB      0x00                    ; シークオフセット

sNowDir:
        DW      DIR_ROOT                ; 現在いるディレクトリ

; //////////////////////////////////////////////////////////////////////////// ;
; --- 初期化プログラム ---
; ██╗███╗  ██╗██╗████████╗
; ██║████╗ ██║██║╚══██╔══╝
; ██║██╔██╗██║██║   ██║   
; ██║██║╚████║██║   ██║   
; ██║██║ ╚███║██║   ██║   
; ╚═╝╚═╝  ╚══╝╚═╝   ╚═╝   
; //////////////////////////////////////////////////////////////////////////// ;

mashInit:
        MOV     AX, 0x0000              ; レジスタセット
        MOV     DS, AX
        MOV     SS, AX
        MOV     ES, AX
        MOV     SP, 0x3fff              ; ｾｸﾞﾎﾟ

        CALL    rInitMalloc

        ;PUSH    DS
        ;MOV     AX, 0x0000
        ;MOV     DS, AX
        ;MOV     AX, 0x0010
        ;MOV     DI, 0x3ff0
        ;CALL    dbgDump
        ;POP     DS
        
%ifdef __DEBUG
        ; AX, BX, CX, DX, SI, DI, BP, SP, DS, ES, SS
        ;MOV     AX, 0x1234
        ;MOV     BX, 0x2345
        ;MOV     CX, 0x3456
        ;MOV     DX, 0x4567
        ;MOV     SI, 0x5678
        ;MOV     DI, 0x6789
        ;MOV     BP, 0x789a
%endif

        CALL    dbgRegDump

%ifdef __DEBUG
        ;MOV     AX, 0x0000
        ;MOV     DS, AX
        ;MOV     SS, AX
        ;MOV     ES, AX
%endif

        CALL    cmdVer                  ; ロゴ+版数表示

%ifdef __DEBUG
        ; スクロールテスト
;.dbgLoop:
        ;MOV     AH, 0x00
        ;INT     0x16

        ;MOV     AH, 0x06
        ;MOV     AL, 0x01
        ;MOV     BH, 0x07
        ;MOV     CX, 0x0000
        ;MOV     DH, 24
        ;MOV     DL, 79
        ;INT     0x10

        ;JMP     .dbgLoop
%endif

%ifdef __DEBUG
        MOV     CL, 0x00
.dbgLoop:
        PUSH    CX
        MOV     AL, CL
        CALL    libIsupper
        ADD     AH, 0x30

        MACRO_SERIAL_PUTC AH

        POP     CX
        INC     CL
        CMP     CL, 0x00
        JNZ     .dbgLoop
.dbgHlt:
        JMP     .dbgHlt
%endif
        
        JMP     mashLoop                ; ループ処理へ移行

; //////////////////////////////////////////////////////////////////////////// ;
; --- ループプログラム ---
; ██╗      ██████╗  ██████╗ ██████╗ 
; ██║     ██╔═══██╗██╔═══██╗██╔══██╗
; ██║     ██║   ██║██║   ██║██████╔╝
; ██║     ██║   ██║██║   ██║██╔═══╝ 
; ███████╗╚██████╔╝╚██████╔╝██║     
; ╚══════╝ ╚═════╝  ╚═════╝ ╚═╝     
; //////////////////////////////////////////////////////////////////////////// ;

mashLoop:
        CALL    rPutCR                  ; 改行
        CALL    rOneLineClear           ; バッファクリア
.inputLoop:
        CALL    rOneLineInput           ; キーボード入力 → バッファ+出力
        CMP     AH, 0x00
        JZ      .inputLoop

        CALL    rPutCR                  ; 改行
        MOV     AX, 0x0000
        MOV     DS, AX
        MOV     DI, [sOneLineBuf]
        CALL    sysPrintf               ; 表示
        CALL    rPutCR                  ; 改行

        ;CALL    sysPwd                  ; 現在のディレクトリを表示

        ;MOV     BP, .sAllow             ; ">"表示
        ;CALL    sysEcho
        
        JMP     mashLoop                ; 永遠にループする
.sAllow:

; //////////////////////////////////////////////////////////////////////////// ;
; --- ビルトインコマンド ---
;  ██████╗ ██████╗ ███╗   ███╗███╗   ███╗ █████╗ ███╗  ██╗██████╗ 
; ██╔════╝██╔═══██╗████╗ ████║████╗ ████║██╔══██╗████╗ ██║██╔══██╗
; ██║     ██║   ██║██╔████╔██║██╔████╔██║██║  ██║██╔██╗██║██║  ██║
; ██║     ██║   ██║██║╚██╔╝██║██║╚██╔╝██║███████║██║╚████║██║  ██║
; ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║ ╚═╝ ██║██╔══██║██║ ╚███║██████╔╝
;  ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚══╝╚═════╝ 
; //////////////////////////////////////////////////////////////////////////// ;

; dir コマンド
; 現在のディレクトリのフォルダ、ファイルを表示する
sysDir:
        CALL    rPushReg                ; レジスタ退避

        MOV     CX, 0x0200              ; 現在のディレクトリ用のメモリを取得
        CALL    sysMalloc
        MOV WORD [.allocAddr1], BP
        MOV     CX, 0x0200              ; リンク先のディレクトリ用のメモリを取得
        CALL    sysMalloc
        MOV WORD [.allocAddr2], BP

        CALL    rPopReg                 ; レジスタ取得
        RET
.allocAddr1:
        DB      0x00, 0x00
.allocAddr2:
        DB      0x00, 0x00

; pwd コマンド
; 現在のディレクトリを標準出力に渡す
sysPwd:
        CALL    rPushReg                ; レジスタ退避
        CALL    rPopReg                 ; レジスタ取得
        RET

; echo コマンド
; 文字列の表示(エスケープシーケンスあり)
; in  : BP      表示する文字列の先頭ポインタ
; out : 画面表示
sysEcho:
        CALL    rPushReg                ; レジスタ退避
        CALL    rPopReg                 ; レジスタ取得
        RET

; malloc コマンド
; 指定されたバイト数の確保した先頭アドレスを返却する
; 実際の確保は16バイト単位で行われる
; 一度に確保できるのは 4080(255* 16)バイト まで
;
; アロケーションメモリ: 0x1000:0x0000 ~ 0x1000:0xffff
; アロケーションテーブル: 0x0000:0x1000 ~ 0x0000:0x1fff
;
; in  : CX      確保したいメモリ容量(バイト)
; out : AX      結果 0成功 1失敗
;     : SS:BP   確保した先頭ポインタ(確保に成功した場合)
sysMalloc:
        CALL    rPushReg                ; レジスタ退避
        PUSH    DS                      ; セグメント退避

        MOV     AX, 0x0000              ; テーブルのセグメントは 0 、以後ルーチン脱出直前まで0のまま
        MOV     DS, AX
        CMP     CX, 0x1000              ; 確保メモリ上限チェック
        JAE     .retError
        CMP     CX, 0x0000              ; 0バイトかチェック
        JZ      .retError
        ADD     CX, 0x000f              ; 確保するブロック数(1ブロック16バイト) = (確保したいバイト + 15) /16
        SHR     CX, 0x04
        MOV BYTE [.aSize], CL
        MOV WORD [.aFAdr], 0x1000       ; テーブルの先頭ポインタは 0x1000
        MOV BYTE [.aCnt], 0x00
        MOV WORD [.aRet], 0x1000
.mallocLoop:
        MOV WORD DI, [.aFAdr]           ; シークしている番地が0か確認
        MOV BYTE AH, [DS:DI]
        CMP     AH, 0x00
        JZ      .cntChk
        MOV BYTE [.aCnt], 0x00         ; シーク番地が0ではないので連続数をリセット
        MOV WORD AX, [.aFAdr]           ; アロケーションテーブルをシーク
        INC     AX
        MOV WORD [.aFAdr], AX
        MOV WORD [.aRet], AX            ; シーク以前には確保できる領域がないため次へ
.exitChk:
        MOV WORD AX, [.aFAdr]           ; テーブルの末尾まで行ったらもう見込みなし
        CMP     AX, 0x2000              ; 末尾は 0x1fff
        JNZ     .mallocLoop             ; 末尾ではないなら次の1バイトを
        JMP     .retError
.cntChk:
        MOV BYTE BH, [.aCnt]            ; 連続空きブロックカウントをカウントアップ
        INC     BH                      ; AHには連続空きブロック
        MOV BYTE [.aCnt], BH
        MOV BYTE CH, [.aSize]           ; 連続空きブロックで注文した領域を充足するか？
        CMP     BH, CH                  ; ALには注文されたブロック数(AHには連続空きブロック)
        JZ      .fillTbl
        MOV WORD AX, [.aFAdr]           ; まだ充足しないため検索を続ける(連続空きブロックは継続)
        INC     AX
        MOV WORD [.aFAdr], AX
        JMP     .exitChk                ; 末尾チェックへ
.fillTbl:
        MOV WORD AX, [.aFAdr]           ; 連続空きブロックの先頭アドレスを取得
        MOV     DI, AX                  ; 以後空きブロックのアドレスは DI にて参照
        MOV BYTE AH, [.aCnt]            ; 以後注文されたブロック数は AH にて参照
        MOV     CL, 0x00
.fillLoop:
        INC     CL                      ; aCnt++
        MOV BYTE [DS:DI], CL            ; free用に意味のある値を格納
        DEC     DI                      ; aFAdr--
        CMP     AH, CL                  ; 注文されたブロック数だけ書き込んだら終了
        JNZ     .fillLoop
        MOV WORD AX, [.aRet]            ; 呼び出し元に返却するのは (連続空きブロックの先頭アドレス - 0X10000) * 16
        SUB     AX, 0x1000
        SHL     AX, 0x04
        MOV WORD [.aRet], AX
        JMP     .return
.retError:
        MOV WORD [.aRet], 0xffff        ; とりあえずゴミデータ
.return:
        CALL    rPopReg                 ; レジスタ取得
        MOV WORD BP, [.aRet]            ; 取得した先頭アドレスを格納
        POP     DS                      ; mallocをコールする前のセグメントに戻す
        RET                             ; 呼び出し元へ     
.aFAdr:                                 ; テーブル内シークアドレス
        DB      0x00, 0x00
.aCnt:                                  ; 現時点の連続空きブロック
        DB      0x00
.aSize:                                 ; 検索するべき連続空きブロック
        DB      0x00
.aRet:                                  ; 返却するアロケーションメモリアドレス
        DB      0x00, 0x00

; free コマンド
; 指定されたアドレスを含む確保領域を解放する
; 実際の確保は16バイト単位で行われる
;
; アロケーションメモリ: 0x1000:0x0000 ~ 0x1000:0xffff
; アロケーションテーブル: 0x0000:0x1000 ~ 0x0000:0x1fff
;
; in  : BP      解放したいアドレス(確保した領域内ならどこでも)
; out : AX      結果 0成功 1失敗
sysFree:
        CALL    rPushReg                ; レジスタ退避
        PUSH    DS                      ; セグメント退避
        MOV     DI, BP                  ; DI ← (BP / 16) + 0x1000

        MOV     AX, 0x0000
        MOV     DS, AX
        SHR     DI, 0x04
        ADD     DI, 0x1000
.freeLoop:                              ; 確保した先頭まで戻る
        MOV BYTE AH, [DS:DI]            ; sTbl[DI]
        CMP     AH, 0x00                ; 値が 0x00 なら異常メモリを入力している
        JZ      .next
        MOV BYTE [DS:DI], 0x00
        INC     DI
        CMP     AH, 0x01                ; 値が 0x01 まで続ける
        JNZ     .freeLoop
.next:
        POP     DS                      ; セグメント戻す
        CALL    rPopReg                 ; レジスタ取得
        RET

; printf 等の文字列解析+文字出力(エスケープシーケンスあり)
; 256文字まで(終端文字含む)
; %c: 文字, %s: 文字列, %d: 10進数, %x: 16進数(小文字), %X: 16進数(大文字)
; \a: 警報音, \n: 復帰改行, \r: 復帰, \t: タブ, \o: 更新なしで次の文字へ, \\, \?, \', \": 1文字, \0: 文字列終了
; \Uxx: カーソルをxx(10新2桁)行上, \Dxx: 下, \Rxx: 右, \Lxx: 左
; \Xxx: カーソルのx座標をxx(10新2桁)に移動, \Yxx: カーソルのx座標をxx(10新2桁)に移動, 
; in  : AX 出力先ファイルディスクリプタ
;     : SI 文字列の先頭ポインタ
;     : DI 変数の先頭ポインタ(DI:1つ目の変数, DI+4:2つ目の変数...)
sysPrintf:
        CALL    rPushReg                ; レジスタ退避

        CALL    rPopReg                 ; レジスタ取得
        RET

; 文字列の表示
; 終端文字(0x00)を確認するまで文字を表示し続ける
; in  : BX      表示する文字列
;       DS:BX   データポインタ
; out : AX      表示結果
;                   0: 成功
;                   1: 256文字以上の文字列を表示しようとした
;                   2: その他の失敗
sysPrint:
        CALL    rPushReg                ; レジスタ退避



        CALL    rPopReg                 ; レジスタ取得
        RET

; 単一の文字出力
; カーソル位置の更新も行う
; in  : AL      表示する文字
sysPutChar:

; //////////////////////////////////////////////////////////////////////////// ;
; --- ライブラリ ---
; ██╗     ██╗██████╗ ██████╗  █████╗ ██████╗ ██╗   ██╗
; ██║     ██║██╔══██╗██╔══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝
; ██║     ██║██████╔╝██████╔╝██║  ██║██████╔╝ ╚████╔╝ 
; ██║     ██║██╔══██╗██╔══██╗███████║██╔══██╗  ╚██╔╝  
; ███████╗██║██████╔╝██║  ██║██╔══██║██║  ██║   ██║   
; ╚══════╝╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   
; //////////////////////////////////////////////////////////////////////////// ;

; //////////////////////////////////////////////////////////////////////////// ;
; ctype.h(c89)
;       libIsalnum      libIsAlpha      libIsblank      libIscntrl
;       libIsdigit      libIsgraph      libIslower      libIsprint   
;       libIspuct       libIsspace      libIsupper      libIsxdigit
;       libToLower      libToupper
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

; 印字可能文字か確認
; c89 isprint 相当
; in  : AL      asciiコード
; out : AH      0: 印字可能
;               1: 印字不可
libIsPrint:
        CALL    rPushReg                ; レジスタ退避

        CMP     AL, 0x20
        JB      .ng
        CMP     AL, 0x7e
        JAE     .ng
        JMP     .ok
.ng:
        MOV BYTE [.aRet], 0x01
        JMP     .exit
.ok:
        MOV BYTE [.aRet], 0x00
        JMP     .exit
.exit:
        CALL    rPopReg                 ; レジスタ取得
        MOV BYTE AH, [.aRet]
        RET
.aRet:
        DB      0x00

; //////////////////////////////////////////////////////////////////////////// ;
; --- サブルーチン ---
;  ██████╗██╗   ██╗██████╗      ██████╗  ██████╗ ██╗   ██╗████████╗██╗███╗  ██╗███████╗
; ██╔════╝██║   ██║██╔══██╗     ██╔══██╗██╔═══██╗██║   ██║╚══██╔══╝██║████╗ ██║██╔════╝
; ╚█████╗ ██║   ██║██████╔╝     ██████╔╝██║   ██║██║   ██║   ██║   ██║██╔██╗██║███████╗
;  ╚═══██╗██║   ██║██╔══██╗     ██╔══██╗██║   ██║██║   ██║   ██║   ██║██║╚████║██╔════╝
; ██████╔╝╚██████╔╝██████╔╝     ██║  ██║╚██████╔╝╚██████╔╝   ██║   ██║██║ ╚███║███████╗
; ╚═════╝  ╚═════╝ ╚═════╝      ╚═╝  ╚═╝ ╚═════╝  ╚═════╝    ╚═╝   ╚═╝╚═╝  ╚══╝╚══════╝
; //////////////////////////////////////////////////////////////////////////// ;

; カーソル位置更新
; in  : (なし)
; out : (なし)
rSetCursol:
        CALL    rPushReg                ; レジスタ退避

        MOV     AH, 0x02
        MOV     BH, 0x00
        MOV BYTE DL, [sXpos]
        MOV BYTE DH, [sYpos]

        CALL    rPopReg                 ; レジスタ取得
        RET

; 改行(次の行の一番左に移動)
; in  : (なし)
; out : (なし)
rPutCR:
        CALL    rPushReg                ; レジスタ退避

        MOV BYTE [sXpos], 0x00          ; 一番左に
        MOV BYTE AH, [sYpos]
        CMP     AH, 24
        JZ      .slideLine              ; すでに一番下なら1行ずれる
        INC     AH
        MOV BYTE [sYpos], AH            ; まだ下があるなら次へ
        JMP     .setCursol
.slideLine:
        MOV     AH, 0x06
        MOV     AL, 0x01
        MOV     BH, 0x07
        MOV     CX, 0x0000
        MOV     DH, 24
        MOV     DL, 79
        INT     0x10
.setCursol:                             ; カーソル位置更新
        CALL    rSetCursol

        CALL    rPopReg                 ; レジスタ取得
        RET

; シェル入力をディスプレイとバッファに格納する
; in  : (なし)
; out : AH      0: 続ける
;               1: 終了(enterキー)
;               2: バッファオーバーフロー
rOneLineInput:
        CALL    rPushReg                ; レジスタ退避

        MOV     AH, 0x00                ; 1文字取得
        INT     0x10
        MOV BYTE [.aChar], AH

        ;CALL    rIsPrint                ; 印字可能文字か確認
        CMP     AH, 0x00
        JNZ     .exitLoutine            ; 印字不可ならなにもしない

        MOV     AX, 0x0000              ; バッファに格納
        MOV     ES, AX
        MOV     BP, sOneLineBuf
        ADD     BP, sOneLineSeek
        ;MOV BYTE [ES:BP], [.aChar]

        MOV     AX, 0x0000              ; ディスプレイに表示
        MOV     ES, AX
        MOV     BP, [.aChar]
        MOV     AH, 0x13
        MOV     AL, 0x01
        MOV     BH, 0x00

        MOV BYTE BL, [sColorNormal]     ; 文字色
        MOV     CX, 0x0001
        MOV BYTE DL, [sXpos]
        MOV BYTE DH, [sYpos]
        INT     0x10

        INC BYTE [sXpos]                ; カーソル位置計算
        CMP BYTE [sXpos], 80
        ;JNZ     .next
        MOV BYTE [sXpos], 0x00
        INC BYTE [sYpos]

        CALL    rSetCursol              ; カーソル位置更新
.exitLoutine:
        CALL    rPopReg                 ; レジスタ取得
        MOV     AH, 0x00
        RET
.aChar:
        DB      0x00

; 入力バッファをクリアする
; in  : (なし)
; out : (なし)
rOneLineClear:
        CALL    rPushReg                ; レジスタ退避

        MOV     AX, 0x0000
        MOV     DS, AX
        MOV WORD DI, [sOneLineBuf]
        MOV     CX, 0x0000
.clearLoop:                             ; 0埋め
        MOV BYTE [DS:DI], 0x00
        INC     CX
        CMP     CX, 0x0100
        JNZ     .clearLoop

        MOV BYTE [sOneLineSeek], 0x00   ; バッファシークリセット

        CALL    rPopReg                 ; レジスタ取得
        RET

; malloc 用のアロケーションメモリとアロケーションテーブルを初期化
; アロケーションメモリ 0x10000 ~ 0x1ffff
; アロケーションテーブル 0x01000 ~ 0x01fff
; in  : なし
; out : なし
rInitMalloc:
        CALL    rPushReg                ; レジスタ退避

        MOV     AX, ES
        PUSH    AX
        MOV     AX, 0x0000
        MOV     ES, AX
        MOV     BP, 0x1000
.initLoop:
        MOV BYTE [ES:BP], 0x00
        INC     BP
        CMP     BP, 0x2000
        JNZ     .initLoop

        POP     AX
        MOV     ES, AX
%ifdef __DEBUG
        ;MOV     CX, 0x0012              ; 動的確保テスト
        ;CALL    sysMalloc
        ;MOV     CX, 0x0034
        ;CALL    sysMalloc
        ;PUSH    BP
        ;MOV     CX, 0x0056
        ;CALL    sysMalloc
        ;POP     BP
        ;CALL    sysFree
        ;MOV     AX, 0x1010
        ;MOV     BP, AX
        ;CALL    sysFree
        
        ;PUSH    DS                      ; アロケーションテーブル
        ;MOV     AX, 0x0000
        ;MOV     DS, AX
        ;MOV     AX, 0x0200
        ;MOV     DI, 0x1000
        ;CALL    dbgDump
        ;POP     DS
%endif
        CALL    rPopReg                 ; レジスタ取得
        RET

; mashのバージョン表示
; ロゴとバージョンについて記載する
; in  : なし
; out : なし
cmdVer:
        CALL    rPushReg                ; レジスタ退避
        MOV     AX, 0x0000
        MOV     SS, AX
        MOV     BP, cMashLogo           ; ロゴの表示
        MOV     CX, 0x0000
.loophead:
        PUSH    CX                      ; ループ変数格納
        MOV     AH, 0x13
        MOV     AL, 0x01
        MOV     BH, 0
        MOV     BL, [DS:sColorNormal]
        MOV     CX, 35                  ; 1行35文字
        MOV     DH, [DS:sYpos]
        MOV     DL, [DS:sXpos]
        INT     0x10

        ADD     BP, 35                  ; 1行35文字
        POP     CX                      ; ループ変数取得
        MOV BYTE [DS:sXpos], 0x00
        INC BYTE [DS:sYpos]
        INC     CX
        CMP     CX, 0x0006
        JNZ     .loophead    
.next:
        MOV     BP, cVersionStr
        MOV     AH, 0x13                ; 版数の表示
        MOV     AL, 0x01
        MOV     BH, 0
        MOV     BL, [DS:sColorNormal]
        MOV     CX, [DS:cVersionLen]
        MOV     DH, [DS:sYpos]
        MOV     DL, [DS:sXpos]
        INT     0x10
        MOV BYTE [DS:sXpos], 0x00
        INC BYTE [DS:sYpos]
        CALL    rPopReg                 ; レジスタ取得
        RET
        
; 全レジスタの退避
; 呼んだあと必ず rPopReg を呼ぶこと
; 呼ぶ前 SP <- サブルーチンへのポインタ
; 呼び後 SP <- BP <- DI <- SI <- DX <- CX <- BX <- AX
; in  : reg     レジスタ
; out : なし
                                        ; tempAX    retAddr AX  stack
rPushReg:                               ; ??        ??      AX  ret
        MOV     [.tempAX], AX           ; AX        ??      AX  ret
        POP     AX                      ; AX        ??      ret (空)
        MOV WORD    [.retAddr], AX      ; AX        ret     ret (空)
        MOV     AX, [.tempAX]           ; AX        ret     AX  (空)

        PUSH    AX                      ; AX        ret     AX  AX
        PUSH    BX                      ; AX        ret     AX  BX)AX
        PUSH    CX                      ; AX        ret     AX  CX)BX)AX
        PUSH    DX                      ; AX        ret     AX  DX)CX)BX)AX
        PUSH    SI                      ; AX        ret     AX  SI)DX)CX)BX)AX
        PUSH    DI                      ; AX        ret     AX  DI)SI)DX)CX)BX)AX
        PUSH    BP                      ; AX        ret     AX  BP)DI)SI)DX)CX)BX)AX

        MOV WORD    AX, [.retAddr]      ; AX        ret     AX  BP)DI)SI)DX)CX)BX)AX
        PUSH    AX                      ; AX        ret     ret ret)BP)DI)SI)DX)CX)BX)AX
        MOV     AX, [.tempAX]           ; AX        ret     AX  ret)BP)DI)SI)DX)CX)BX)AX
        RET                             ; AX        ret     ret BP)DI)SI)DX)CX)BX)AX
.tempAX:                                ; AXレジスタを一時的に格納
        DB      0x00, 0x00
.retAddr:                               ; ルーチンのリターンアドレス
        DB      0x00, 0x00

; レジスタの復帰
; 呼ぶ前に必ず rPushReg を呼ぶこと
; 呼ぶ前 SP <- サブルーチンへのポインタ <- BP <- DI <- SI <- DX <- CX <- BX <- AX
; 呼び後 SP
; in  : なし
; out : reg     レジスタ
                                        ; tempAX    retAddr AX  stack
rPopReg:                                ; ??        ??      AX  ret)BP)DI)SI)DX)CX)BX)AX
        POP     AX                      ; ??        ??      ret BP)DI)SI)DX)CX)BX)AX
        MOV WORD    [.retAddr], AX      ; ??        ret     ret BP)DI)SI)DX)CX)BX)AX

        POP     BP                      ; ??        ret     ret DI)SI)DX)CX)BX)AX
        POP     DI                      ; ??        ret     ret SI)DX)CX)BX)AX
        POP     SI                      ; ??        ret     ret DX)CX)BX)AX
        POP     DX                      ; ??        ret     ret CX)BX)AX
        POP     CX                      ; ??        ret     ret BX)AX
        POP     BX                      ; ??        ret     ret AX
        POP     AX                      ; ??        ret     AX  (なし)

        MOV     [.tempAX], AX           ; AX        ret     AX  (なし)
        MOV WORD    AX, [.retAddr]      ; AX        ret     ret (なし)
        PUSH    AX                      ; AX        ret     ret ret
        MOV     AX, [.tempAX]           ; AX        ret     AX  ret
        RET                             ; AX        ret     AX
.tempAX:                                ; AXレジスタを一時的に格納
        DB      0x00, 0x00
.retAddr:                               ; ルーチンのリターンアドレス
        DB      0x00, 0x00

; ビープ音出力
; in : なし
; out: ビープ音
putBeep:
        MOV     AH, 0x0e
        MOV     AL, 0x41
        MOV     BH, 0x00
        MOV     BL, 0x01
        INT     0x10
        RET

; シリアル1文字出力
; in  : AL      ascii
; out : (なし)
dbgSingle:
        CALL    rPushReg                ; レジスタ退避

        MOV     AH, 0x01                ; 書き込み(ALreg)
        MOV     DX, 0x0000
        INT     0x14

        CALL    rPopReg                 ; レジスタ取得
        RET

; デバッグ用ダンプ
; COM1を使って指定番地から指定バイトをダンプする
; in  : AX      ダンプするバイト数
;     : DS:DI   ダンプ開始アドレス
; out : なし
dbgDump:
        CALL    rPushReg                ; レジスタ退避

        MOV     BX, DS
        MOV WORD [.focusSeg], BX
        MOV WORD [.focusAddr], DI
        MOV WORD [.byteCnt], AX

        MOV     AH, 0x00                ; シリアルポート設定
        MOV     AL, 0xe3                ; 0bBBBPPSCC, 9600bps, None, 1bit, 8bit
        MOV     DX, 0x0000              ; 0ch = COM1, xch = COMx+1
        INT     0x14

        MOV     AL, 0x0a                ; 改行文字
        CALL    .putchar

        MOV     CX, 0x0000
.dumpLoop:
        PUSH    CX
        MOV     BX, [.focusSeg]         ; asciiプリント
        MOV     DS, BX
        MOV     DI, [.focusAddr]
        MOV     AL, [DS:DI]

        PUSH    AX
        SHR     AL, 0x04                ; 上4bitプリント
        AND     AL, 0x0f
        CMP     AL, 0x0a
        JAE     .upperaf
        ADD     AL, 0x30                ; 0~9
        JMP     .upperNext
.upperaf:
        ADD     AL, 0x37                ; a~f
.upperNext:
        CALL    .putchar

        POP     AX
        AND     AL, 0x0f                ; 下4bitプリント
        CMP     AL, 0x0a
        JAE     .loweraf
        ADD     AL, 0x30                ; 0~9
        JMP     .lowerNext
.loweraf:
        ADD     AL, 0x37                ; a~f
.lowerNext:
        CALL    .putchar

        MOV     AL, 0x20                ; 空白文字
        CALL    .putchar

        INC     DI
        MOV WORD [.focusAddr], DI
        POP     CX
        INC     CX
        CMP WORD CX, [.byteCnt]
        JNZ     .dumpLoop

        MOV     AL, 0x0a                ; 改行文字
        CALL    .putchar

        CALL    rPopReg                 ; レジスタ取得
        RET
.putchar:                               ; 1文字出力(ALreg)
        PUSH    AX
        PUSH    DX
        MOV     AH, 0x01                ; 書き込み
        MOV     DX, 0x0000
        INT     0x14
        POP     DX
        POP     AX
        RET
.focusSeg:                              ; ダンプするセグメント
        DB      0x00, 0x00
.focusAddr:                             ; ダンプするアドレス
        DB      0x00, 0x00
.byteCnt:                               ; ダンプするバイト数
        DB      0x00, 0x00

; レジスタダンプ
; 内部で sysMalloc sysFree dbgDump を使用
; in  : AX, BX, CX, DX, SI, DI, BP, SP, DS, ES, SS
dbgRegDump:
        CALL    rPushReg                ; レジスタ退避
        PUSH    DS

        PUSH    SS
        PUSH    ES
        PUSH    DS
        PUSH    SP
        PUSH    BP
        PUSH    DI
        PUSH    SI
        PUSH    DX
        PUSH    CX
        PUSH    BX
        PUSH    AX

        MOV     CX, 22                  ; メモリ確保
        CALL    sysMalloc
        MOV WORD [.allocAddr], BP

        MOV     AX, 0x0000
        MOV     DS, AX
        MOV     CX, 0x0000
.popLoop:                               ; 2wordずつ格納
        POP     AX
        XOR     AH, AL                  ; リトルエンディアン → ビッグエンディアン
        XOR     AL, AH
        XOR     AH, AL
        MOV WORD [DS:BP], AX
        ADD     BP, 0x0002
        INC     CX
        CMP     CX, 11
        JNZ     .popLoop

        MOV     AX, 22                  ; dbgDump で 表示
        MOV     DI, [.allocAddr]
        CALL    dbgDump

        MOV WORD BP, [.allocAddr]       ; メモリ解放
        CALL    sysFree

        POP     DS
        CALL    rPopReg                 ; レジスタ取得
        RET
.allocAddr:
        DB      0x00, 0x00

mashHlt:
        JMP     mashHlt

; --- 0埋め ---
secEnd:
        times 0x4000-($-$$) DB 0        ; mash常駐は16セクタ
