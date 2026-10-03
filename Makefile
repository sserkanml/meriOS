# Makefile

ASM := nasm

# macOS ships Apple clang/ld as `gcc`/`ld`, which can't produce freestanding
# 32-bit ELF binaries. Default to the Homebrew x86_64-elf cross-toolchain
# there instead; override on the command line (e.g. `make CC=...`) if needed.
ifeq ($(shell uname -s),Darwin)
    CC := x86_64-elf-gcc
    LD := x86_64-elf-ld
else
    CC := gcc
    LD := ld
endif

BUILD_DIR := build
LINKER    := linker.ld

SRC_MULTIBOOT := src/boot/multiboot_header.asm
SRC_ENTRY     := src/boot/entry.asm
SRC_KERNEL    := src/kernel/kernel.c

OBJ_MULTIBOOT := $(BUILD_DIR)/multiboot_header.o
OBJ_ENTRY     := $(BUILD_DIR)/entry.o
OBJ_KERNEL    := $(BUILD_DIR)/kernel.o

KERNEL_ELF := $(BUILD_DIR)/kernel.elf

CFLAGS  := -m32 -ffreestanding -fno-pic -c
LDFLAGS := -m elf_i386 -T $(LINKER)

.PHONY: all run clean

all: $(KERNEL_ELF)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(OBJ_MULTIBOOT): $(SRC_MULTIBOOT) | $(BUILD_DIR)
	$(ASM) -f elf32 $(SRC_MULTIBOOT) -o $(OBJ_MULTIBOOT)

$(OBJ_ENTRY): $(SRC_ENTRY) | $(BUILD_DIR)
	$(ASM) -f elf32 $(SRC_ENTRY) -o $(OBJ_ENTRY)

$(OBJ_KERNEL): $(SRC_KERNEL) | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(SRC_KERNEL) -o $(OBJ_KERNEL)

$(KERNEL_ELF): $(OBJ_MULTIBOOT) $(OBJ_ENTRY) $(OBJ_KERNEL) $(LINKER)
	$(LD) $(LDFLAGS) $(OBJ_MULTIBOOT) $(OBJ_ENTRY) $(OBJ_KERNEL) -o $(KERNEL_ELF)

run: $(KERNEL_ELF)
	qemu-system-i386 -kernel $(KERNEL_ELF)

clean:
	rm -rf $(BUILD_DIR)