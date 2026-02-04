cd /NASM/script

nasm -f bin ../asm/ipl.asm -o ipl.bin
nasm -f bin ../asm/second.asm -o second.bin
nasm -f bin ../asm/mash.asm -o mash.bin
nasm -f bin ../asm/disk/diskm.asm -o diskm.bin
nasm -f bin ../asm/disk/root.asm -o root.bin

makedisk.exe ../bin/mash.img

move ipl.bin ../bin/ipl.bin
move second.bin ../bin/second.bin
move mash.bin ../bin/mash.bin
move root.bin ../bin/root.bin
move diskm.bin ../bin/diskm.bin
