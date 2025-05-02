
#ifdef NX_C_SRC
#	SRC = $NX_C_SRC
#else
#endif

#ifdef NX_C_HDR
#	OBJ := $(wildcard headers/*)
#else
#endif

#ifdef NX_C_DEBUG
#	CFLAGS += -ggdb -Wextra -pedantic
#endif

#ifdef NX_C_PIE
#	CFLAGS += -fPIE -pie -W1,-z,noexecstack
#endif

#ifeq ($(OS), Linux)
#	CFLAGS += -DLINUX
#endif
#all: nx

#CC = gcc
#CFLAGS += -ggdb -O2
#SRC = $(wildcard examples/*.c)
#OBJ = $(patsubst %.c, %.o, $(SRC))

#all: main

#main: $(OBJ)
#	$(CC) $(CFLAGS) -o nx $(OBJ)

#%.o: %.c
#	$(CC) $(CFLAGS) -c $< -o $@
#
#.PHONY: clean
#clean:
#	-rm main $(OBJ)

CC = gcc
CFLAGS = -Wall -O2

SRC = $(wildcard *.c)
OBJ = $(patsubst %.c, %.o, $(SRC))

all: nx_program

nx_program: $(OBJ)
	$(CC) $(CFLAGS) -o nx_program $(OBJ)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f nx_program $(OBJ)

