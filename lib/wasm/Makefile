CC	  ?= clang
LD	  = wasm-ld

CFLAGS  = --target=wasm32 \
	  -nostdlib \
	  -O3 \
	  -Wall \
	  -Wextra \
	  -Wno-unused-parameter \
	  -Wno-unused-variable

LDFLAGS = --no-entry \
	  --export-all \
	  --allow-undefined \
	  --export=memory \
	  -O3

SRC = main.c $(wildcard headers/*.c)
OBJ = $(patsubst %.c,%.o,$(SRC))

.PHONY: all
all: vm.wasm

vm.wasm: $(OBJ)
	$(LD) $(LDFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -f vm.wasm $(OBJ)
