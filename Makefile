
TARGET_BOOTCODE = bootcode.bin

#
# when building bootcode.bin, always ensure start.s is at the top, providing
# the 0x200 byte long header and some init code.
# 
SRCS = \
	start.s \
	romstage.c \
	sdram.c \
	arm_loader.c \
	trap.c \
	lib/xprintf.c \
	lib/panic.c \
	lib/udelay.c \
	lib/memcpy.c \
	chainloader_inc.s

ARCH = vc4

BUILD_DIR = build
TARGET_BUILD_DIR = $(BUILD_DIR)/$(ARCH)-objects
PRODUCT_DIRECTORY = $(BUILD_DIR)

NO_COLOR=""
OK_COLOR=""
ERROR_COLOR=""
WARN_COLOR=""

.PHONY: default all clean create_build_directory device

default: $(TARGET_BOOTCODE)

OBJ := $(addprefix $(TARGET_BUILD_DIR)/, $(addsuffix .o, $(basename $(SRCS))))

CROSS_COMPILE = /Developer/vc4-toolchain/prefix/bin/vc4-elf-
CC = $(CROSS_COMPILE)gcc
AS = $(CC)
OBJCOPY = $(CROSS_COMPILE)objcopy
LINKFLAGS = -nostdlib -nostartfiles
CFLAGS = -c -nostdlib -std=c11
ASFLAGS = -c -nostdlib -x assembler-with-cpp

HEADERS := \
	$(shell find . -type f -name '*.h') \
	$(shell find . -type f -name '*.hpp')

create_build_directory:
	@mkdir -p $(TARGET_BUILD_DIR)
	@mkdir -p $(PRODUCT_DIRECTORY)

CREATE_SUBDIR = \
	@DIR="$(dir $@)"; \
	if [ ! -d $$DIR ]; then mkdir -p $$DIR; fi


#
# rules to build c/asm files.
# 
$(TARGET_BUILD_DIR)/%.o: %.c $(HEADERS)
	$(CREATE_SUBDIR)
	@echo $(WARN_COLOR)CC  $(NO_COLOR) $@
	@$(CC) $(CFLAGS) $< -o $@

$(TARGET_BUILD_DIR)/%.o: %.s $(HEADERS)
	$(CREATE_SUBDIR)
	@echo $(WARN_COLOR)AS  $(NO_COLOR) $@
	@$(AS) $(ASFLAGS) $< -o $@

.PRECIOUS: $(OBJ)

$(TARGET_BOOTCODE): create_build_directory $(OBJ)
	@echo $(WARN_COLOR)LD  $(NO_COLOR) $@.elf
	@$(CC) $(LINKFLAGS) $(OBJ) -o $(PRODUCT_DIRECTORY)/$@.elf
	@echo $(WARN_COLOR)OBJ$(NO_COLOR) $@
	@$(OBJCOPY) -O binary $(PRODUCT_DIRECTORY)/$@.elf $(PRODUCT_DIRECTORY)/$@

clean:
	@echo $(ERROR_COLOR)CLEAN$(NO_COLOR)
	@-rm -rf ./$(BUILD_DIR)