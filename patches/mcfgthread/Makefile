
mcfgthread_cflags = \
	-D_WIN32_WINNT=0x0601 \
	-D__USE_MINGW_ANSI_STDIO \
	-U_FORTIFY_SOURCE \
	-masm=intel \
	-msse2 \
	-mfpmath=sse \
	-fno-stack-protector \
	-fstrict-aliasing \
	-ffast-math \
	-fno-ident \
	-fno-omit-frame-pointer \
	-fmerge-all-constants \
	-fasynchronous-unwind-tables

mcfgthread_ldflags = \
	-nostdlib \
	-Wl,-enable-auto-image-base \
	-Wl,-gc-sections \
	-Wl,-subsystem,windows:6.1 \
	-Wl,-kill-at \
	-Wl,-exclude-all-symbols

mcfgthread_public_headers = \
	fwd.h \
	atomic.h \
	clock.h \
	mutex.h \
	shared_mutex.h \
	cond.h \
	once.h \
	sem.h \
	event.h \
	thread.h \
	cxa.h \
	dtor_queue.h \
	exit.h \
	tls.h \
	gthr_aux.h \
	gthr.h \
	gthr_libobjc.h \
	c11.h \
	libcxx.h \
	cxx11.hpp

mcfgthread_obj_min = \
	xglobals.o \
	fwd.o \
	clock.o \
	mutex.o \
	shared_mutex.o \
	cond.o \
	once.o \
	sem.o \
	event.o \
	thread.o \
	cxa.o \
	dtor_queue.o \
	exit.o \
	tls.o \
	gthr_aux.o

mcfgthread_obj_ex = \
	gthr.o \
	gthr_libobjc.o \
	c11.o \
	libcxx.o

.PHONY: all install install-strip install-common

all: libmcfgthread.a libmcfgthread-$(ABI_MAJOR).dll

libmcfgthread.a: $(mcfgthread_obj_min:%=static/%) $(mcfgthread_obj_ex:%=static/%)
	$(AR) rcs $@ $?

libmcfgthread-$(ABI_MAJOR).dll: $(mcfgthread_obj_min:%=shared/%) $(mcfgthread_obj_ex:%=shared/%) $(SOURCE_DIR)/mcfgthread.def version.o
	$(CC) -shared $(LDFLAGS) $(mcfgthread_ldflags) -Wl,--out-implib,libmcfgthread.dll.a -o $@ $+ -lkernel32 -lntdll

static/%.o: $(SOURCE_DIR)/%.c
	mkdir -p static
	$(CC) $(CFLAGS) $(mcfgthread_cflags) -ffunction-sections -I. -o $@ -c $<

shared/%.o: $(SOURCE_DIR)/%.c
	mkdir -p shared
	$(CC) $(CFLAGS) $(mcfgthread_cflags) -ffreestanding -D__MCF_IN_DLL -I. -o $@ -c $<

version.o: $(SOURCE_DIR)/version.rc $(SOURCE_DIR)/version.manifest
	$(RC) -I. -c65001 -o $@ -i $<

install-common: libmcfgthread.a libmcfgthread-$(ABI_MAJOR).dll
	mkdir -p $(DESTDIR)/{bin,include/mcfgthread,lib}
	for i in $(mcfgthread_public_headers); do cp -f $(SOURCE_DIR)/$$i $(DESTDIR)/include/mcfgthread/; done
	cp -f version.h $(DESTDIR)/include/mcfgthread/
	cp -f libmcfgthread.a libmcfgthread.dll.a $(DESTDIR)/lib/

install: install-common
	cp -f libmcfgthread-$(ABI_MAJOR).dll $(DESTDIR)/bin/

install-strip: install-common
	strip -s -o $(DESTDIR)/bin/libmcfgthread-$(ABI_MAJOR).dll libmcfgthread-$(ABI_MAJOR).dll
