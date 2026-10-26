CC      ?= gcc
CFLAGS  ?=
CFLAGS  += -Wall -O2

PROGRAMS := $(patsubst %.c,%,$(wildcard nex-*.c))
HEADERS  := $(wildcard headers/*.h)
SHARED_OBJ := $(patsubst %.c,%.o,$(wildcard headers/*.c))


ifdef NX_C_DEBUG
	CFLAGS  += -ggdb -Wextra -pedantic
endif

ifdef NX_C_PIE
	CFLAGS  += -fPIE -pie -Wl,-z,noexecstack
endif

ifeq ($(OS),Linux)
	CFLAGS  += -DLINUX
endif

.PHONY: all clean
all: $(PROGRAMS)

#(PROGRAMS): %: %.c $(HEADERS)
#	$(CC) $(CPPFLAGS) -Iheaders $(CFLAGS) -o $@ $< $(LDFLAGS) $(LDLIBS)

$(PROGRAMS): %: %.o $(SHARED_OBJ)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

%.o: %.c
	$(CC) $(CPPFLAGS) -Iheaders $(CFLAGS) -c $< -o $@

clean:
	rm -f $(PROGRAMS) $(patsubst %.c,%.o,$(wildcard nex-*.c)) $(SHARED_OBJ)

