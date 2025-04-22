# Assembler and linker
AS = as
LD = ld

# Flags
ASFLAGS = --32
LDFLAGS = -m elf_i386 -lc -dynamic-linker /lib/ld-linux.so.2

# Directories
BUILD_DIR = build

# Find all assembly files in the current directory
ASM_SRCS = $(wildcard *.s)
OBJ_FILES = $(patsubst %.s,$(BUILD_DIR)/%.o,$(ASM_SRCS))

# Default target
all: $(BUILD_DIR)/count

# Create build directory if it doesn't exist
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Compile .s files to .o files
$(BUILD_DIR)/%.o: %.s | $(BUILD_DIR)
	$(AS) $(ASFLAGS) $< -o $@

# Link all object files to create the executable
$(BUILD_DIR)/count: $(OBJ_FILES)
	$(LD) $(LDFLAGS) -o $@ $^

# Clean target
clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean
