# Makefile for building count tool with various debug modes

# Tools & flags
AS      := as
CC      := gcc
LD      := ld -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2
BUILD   := build
MODULES := $(basename $(wildcard *.s))

.PHONY: all debug c clean debug-%

# Default: build the normal count binary from all .s files
all: $(BUILD)/count

$(BUILD)/count: | $(BUILD)
	@echo "Assembling all .s → objects"
	@for src in $(wildcard *.s); do \
	  obj=$$(basename $$src .s).o; \
	  $(AS) $$src -o $(BUILD)/$$obj; \
	done
	@echo "Linking → $@"
	@$(LD) -o $@ $(BUILD)/*.o

# Debug‐all: replace debug.s with c/debug.c
debug: $(BUILD)/count-debug

$(BUILD)/count-debug: | $(BUILD)
	@echo "Assembling all .s except debug.s → objects"
	@for src in $(filter-out debug.s,$(wildcard *.s)); do \
	  obj=$$(basename $$src .s).o; \
	  $(AS) $$src -o $(BUILD)/$$obj; \
	done
	@echo "Compiling c/debug.c → object"
	@$(CC) -c c/debug.c -o $(BUILD)/debug.o
	@echo "Linking → $@"
	@$(LD) -o $@ $(BUILD)/*.o

# C: compile all c/*.c → build/count-c
c: $(BUILD)/count-c

$(BUILD)/count-c: | $(BUILD)
	@echo "Compiling all c/*.c → objects"
	@for src in $(wildcard c/*.c); do \
	  obj=$$(basename $$src .c).o; \
	  $(CC) -c $$src -o $(BUILD)/$$obj; \
	done
	@echo "Linking → $@"
	@$(CC) -o $@ $(BUILD)/*.o

# Debug‐per‐module: build count-debug-<module>
debug-%: | $(BUILD)
	@module=$*; \
	echo "Building debug for module $$module:"; \
	for m in $(MODULES); do \
	  if [ "$$m" = "$$module" ]; then \
	    echo "  as $$m.s → build/$$m.o"; \
	    $(AS) $$m.s -o $(BUILD)/$$m.o; \
	  else \
	    echo "  gcc -c c/$$m.c → build/$$m.o"; \
	    $(CC) -c c/$$m.c -o $(BUILD)/$$m.o; \
	  fi; \
	done; \
	echo "Linking → $(BUILD)/count-debug-$$module"; \
	$(CC) -o $(BUILD)/count-debug-$$module $(BUILD)/*.o

# Ensure build directory exists
$(BUILD):
	@mkdir -p $(BUILD)

# Clean up
clean:
	rm -rf $(BUILD)
