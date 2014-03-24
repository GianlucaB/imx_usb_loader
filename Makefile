all: imx_usb imx_uart

BUILDHOST := $(shell uname -s)
BUILDHOST := $(patsubst CYGWIN_%,CYGWIN,$(BUILDHOST))

ifneq ($(BUILDHOST),CYGWIN)
USBCFLAGS = `pkg-config --cflags libusb-1.0`
LDFLAGS = `pkg-config --libs libusb-1.0`
else
USBCFLAGS = -I/usr/include/libusb-1.0
USBCFLAGS = -L/usr/lib -lusb-1.0
endif

%.o : %.cpp
	$(CC) -c $*.cpp -o $@ -Wno-trigraphs -pipe -ggdb -Wall $(CFLAGS)

imx_usb.o : imx_usb.c
	$(CC) -c $*.c -o $@ -Wstrict-prototypes -Wno-trigraphs -pipe -ggdb $(USBCFLAGS) $(CFLAGS)

%.o : %.c
	$(CC) -c $*.c -o $@ -Wstrict-prototypes -Wno-trigraphs -pipe -ggdb $(CFLAGS)

imx_usb: imx_usb.o imx_sdp.o
	$(CC) -o $@ $@.o imx_sdp.o $(LDFLAGS)

imx_uart: imx_uart.o imx_sdp.o
	$(CC) -o $@ $@.o imx_sdp.o

install: imx_usb
	mkdir -p ${DESTDIR}/usr/bin/
	install -m755 imx_usb ${DESTDIR}/usr/bin/imx_usb

clean:
	rm -f imx_usb imx_uart imx_usb.o imx_uart.o imx_sdp.o

