CC      ?= gcc
CFLAGS  ?=
CFLAGS  += -Wall -O2

ifdef NX_C_DEBUG
	CFLAGS  += -ggdb -Wextra -pedantic
endif

ifdef NX_C_PIE
	CFLAGS  += -fPIE -pie -Wl,-z,noexecstack
endif

ifeq ($(OS),Linux)
	CFLAGS  += -DLINUX
endif

SRC = main.c $(wildcard headers/*.c)
OBJ = $(patsubst %.c,%.o,$(SRC))

.PHONY: all
all: nx

nx: $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -f nx $(OBJ)

