cd /NASM/script

nasm -f bin ../asm/ipl.asm -o ipl.bin
nasm -f bin ../asm/second.asm -o second.bin
nasm -f bin ../asm/mash.asm -o mash.bin
nasm -f bin ../asm/disk/diskm.asm -o diskm.bin
nasm -f bin ../asm/disk/root.asm -o root.bin
nasm -f bin ../asm/disk/bin.asm -o bin.bin
nasm -f bin ../asm/disk/usr.asm -o usr.bin
nasm -f bin ../asm/disk/readme.asm -o readme.bin
nasm -f bin ../asm/disk/testprg.asm -o testprg.bin
nasm -f bin ../asm/disk/testtxt.asm -o testtxt.bin
nasm -f bin ../asm/disk/doc.asm -o doc.bin

makedisk.exe ../bin/mash.img

move ipl.bin ../bin/ipl.bin
move second.bin ../bin/second.bin
move mash.bin ../bin/mash.bin
move diskm.bin ../bin/diskm.bin
move root.bin ../bin/root.bin
move bin.bin ../bin/bin.bin
move usr.bin ../bin/usr.bin
move readme.bin ../bin/readme.bin
move testprg.bin ../bin/testprg.bin
move testtxt.bin ../bin/testtxt.bin
move doc.bin ../bin/doc.bin
