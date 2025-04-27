# Makefile for building count tool with various debug modes

# Tools & flags
AS        := as -g
CC        := gcc -g -z execstack # fix the warning about executable stack
LD        := ld -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2 -z execstack
BUILD     := build
BUILD_ASM := $(BUILD)/asm
BUILD_C   := $(BUILD)/c
TEST      := test
MODULES   := $(basename $(wildcard *.s))

.PHONY: all debug c clean debug-% test

# Object files from .s and c/debug.c
S_SRCS := $(wildcard *.s)
S_OBJS := $(patsubst %.s,$(BUILD_ASM)/%.o,$(S_SRCS))
C_DEBUG_SRC := c/debug.c
C_DEBUG_OBJ := $(BUILD_C)/debug.o

# Default: build the normal count binary from all .s files
all: $(BUILD)/count

$(BUILD)/count: $(S_OBJS)
	@echo "Linking -> $@"
	@$(LD) -o $@ $^

$(BUILD_ASM)/%.o: %.s | $(BUILD_ASM)
	@echo "Assembling $< -> $@"
	@$(AS) $< -o $@

# Debug: replace debug.s with c/debug.c
$(C_DEBUG_OBJ): $(C_DEBUG_SRC) | $(BUILD_C)
	@echo "Compiling $< -> $@"
	@$(CC) -c $< -o $@

DEBUG_OBJS := $(filter-out $(BUILD_ASM)/debug.o,$(S_OBJS)) $(C_DEBUG_OBJ)

debug: $(BUILD)/count-debug

$(BUILD)/count-debug: $(DEBUG_OBJS)
	@echo "Linking -> $@"
	@$(LD) -o $@ $^

# C: compile all c/*.c -> build/count-c
C_SRCS := $(wildcard c/*.c)
C_OBJS := $(patsubst c/%.c,$(BUILD_C)/%.o,$(C_SRCS))

c: $(BUILD)/count-c

$(BUILD_C)/%.o: c/%.c | $(BUILD_C)
	@echo "Compiling $< -> $@"
	@$(CC) -c $< -o $@

$(BUILD)/count-c: $(C_OBJS) | $(BUILD_C)
	@echo "Linking -> $@"
	@$(CC) -o $@ $^

# Debug-per-module: build count-debug-<module>
debug-%: %.s
	$(MAKE) $(BUILD)/count-debug-$*

$(BUILD)/count-debug-%: %.s | $(BUILD_ASM) $(BUILD_C)
	@echo "Building debug for module $*"
	@objs=""; \
	for m in $(MODULES); do \
	  if [ "$$m" = "$*" ]; then \
	    obj=$(BUILD_ASM)/$$m.o; \
	    echo "  as $$m.s -o $$obj"; \
	    $(AS) $$m.s -o $$obj; \
	  else \
	    obj=$(BUILD_C)/$$m.o; \
	    echo "  gcc -c c/$$m.c -o $$obj"; \
	    $(CC) -c c/$$m.c -o $$obj; \
	  fi; \
	  objs="$$objs $$obj"; \
	done; \
	echo "Linking -> $@"; \
	$(CC) -o $@ $$objs

# Ensure build directories exist
$(BUILD_ASM):
	@mkdir -p $@

$(BUILD_C): | $(BUILD)
	@mkdir -p $@

$(BUILD):
	@mkdir -p $@

# Clean up
clean:
	rm -rf $(BUILD) $(TEST)

# Test all modules
test: c debug
	@mkdir -p $(TEST)
	@echo "Running automated tests for all modules ..."
	@echo "Building debug versions for each module..."
	@for module in $(filter-out main debug,$(MODULES)); do \
		$(MAKE) $(BUILD)/count-debug-$$module; \
	done
	@echo "Running tests..."
	@test_failed=0; \
	cp $(BUILD)/count-debug $(BUILD)/count-debug-all; \
	$(BUILD)/count-c < Makefile > $(TEST)/reference.txt; \
	for module in $(filter-out main debug,$(MODULES)) all; do \
		printf "testing $$module... "; \
		$(BUILD)/count-debug-$$module < Makefile > $(TEST)/debug-$$module.txt 2> $(TEST)/debug-$$module-err.txt; \
		if [ $$? -ne 0 ]; then echo "runtime error"; test_failed=1; else \
			diff $(TEST)/reference.txt $(TEST)/debug-$$module.txt > $(TEST)/$$module-diff.txt; \
			if [ $$? -ne 0 ]; then echo "wrong answer, dumped details to $(TEST)/$$module-diff.txt"; test_failed=1; else echo "OK"; fi; \
		fi; \
	done; \
	exit $$test_failed

# Test specific module

test-%: c debug-%
	@mkdir -p $(TEST)
	@echo "Running test for module $* ..."
	@$(BUILD)/count-c < Makefile > $(TEST)/reference.txt
	@$(BUILD)/count-debug-$* < Makefile > $(TEST)/debug-$*.txt 2> $(TEST)/debug-$*-err.txt
	@diff $(TEST)/reference.txt $(TEST)/debug-$*.txt > /dev/null
	@if [ $$? -ne 0 ]; then echo "failed"; exit 1; else echo "OK"; fi
