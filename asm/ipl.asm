; ipl
; TAB=4

		ORG		0x7c00			; このプログラムがどこに読み込まれるのか

		JMP		iplEntry

; --- プログラム本体 ---

; --- レジスタ初期化 ---
iplEntry:
		MOV		AX, 0x0000		; 0に初期化
		MOV		SS, AX
		MOV		SP, 0x7c00
		MOV		DS, AX

; --- タイマ初期化 ---
		MOV		AH, 0x01
		MOV		CX, 0x0000		; 0に初期化
		MOV		DX, 0x0000
		INT		0x1a
		
; --- ビデオモード指定 ---
		MOV		AH, 0x00
		MOV		AL, 0x03
		INT		0x10

; --- テスト文字出力 ---
		MOV		AH, 0x0e
		MOV		AL, "A"
		MOV		BX, 0x0015
		INT		0x10

; --- ループ ---
iplEnd:
		JMP		iplEnd

; --- ブートローダーシグネチャ ---
		times 510-($-$$) DB 0
		DW		0xaa55			; シグネチャ