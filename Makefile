LLVM     = /opt/homebrew/opt/llvm/bin
CLANG    = $(LLVM)/clang
OBJCOPY  = $(LLVM)/llvm-objcopy

CFILES   = $(wildcard *.c)
OFILES   = $(CFILES:.c=.o)
CFLAGS   = -Wall -O2 -ffreestanding -nostdinc -nostdlib -nostartfiles \
           --target=aarch64-none-elf -fno-stack-protector -fno-pic

all: clean kernel8.img

boot.o: boot.S
	$(CLANG) $(CFLAGS) -c boot.S -o boot.o

%.o: %.c
	$(CLANG) $(CFLAGS) -c $< -o $@

kernel8.img: boot.o $(OFILES)
	$(CLANG) $(CFLAGS) -fuse-ld=lld -T link.ld boot.o $(OFILES) -o kernel8.elf
	$(OBJCOPY) -O binary kernel8.elf kernel8.img

clean:
	/bin/rm -f kernel8.elf *.o *.img
