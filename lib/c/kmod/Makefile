PWD := "${G_NEX_MOD_LIB}/c/kmod"
KMOD = /lib/modules/$(shell uname -r)/build

kbuild:
	make -C $(KMOD) M=$(PWD) Y=$(PWD)/nex-0

clean:
	make -C $(KMOD) M=$(PWD) Y=$(PWD)/nex-0 clean

