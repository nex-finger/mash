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
		MOV		AL, 0x07
		INT		0x10

; --- テスト文字列出力 ---
		MOV		AH, 0x13
		MOV		AL, 0x01
		MOV		BH, 0x00
		MOV		BL, 0x01
		MOV		CX, 0x0016
		MOV		DX, 0x0000
		PUSH	CS
		POP		ES
		MOV		BP, iplMsg
		INT		0x10

; --- ループ ---
iplEnd:
		JMP		iplEnd

; --- テスト文字列 ---
iplMsg:
		; "Power on detection!!\r\n"
		DB 		0x50, 0x6F, 0x77, 0x65, 0x72, 0x20, 0x6F, 0x6E
		DB		0x20, 0x64, 0x65, 0x74, 0x65, 0x63, 0x74, 0x69
		DB		0x6F, 0x6E, 0x21, 0x21, 0x0D, 0x0A

; --- ブートローダーシグネチャ ---
		times 510-($-$$) DB 0
		DW		0xaa55			; シグネチャ