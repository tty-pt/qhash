PREFIX ?= /usr/local
LIBDIR := ${DESTDIR}${PREFIX}/lib
realpwd != pwd
realpwd != realpath ${realpwd}
npm-root != npm root
debug := -fsanitize=address -fstack-protector-strong
libdir := /usr/local/lib ${npm-root}/@tty-pt/qhash

all: libqhash.so qhash

libqhash.so: libqhash.c include/qhash.h
	${CC} -o $@ libqhash.c -I/usr/local/include -g -O3 -fPIC -shared

qhash: qhash.c include/qhash.h
	${CC} -o $@ qhash.c ${libdir:%=-L%} ${libdir:%=-Wl,-rpath,%} -g -O3 -lqhash -ldb

install: libqhash.so
	install -d ${DESTDIR}${PREFIX}/lib/pkgconfig
	install -m 644 libqhash.so ${DESTDIR}${PREFIX}/lib
	install -m 644 qhash.pc $(DESTDIR)${PREFIX}/lib/pkgconfig
	install -d ${DESTDIR}${PREFIX}/include
	install -m 644 include/qhash.h $(DESTDIR)${PREFIX}/include

install-bin: qhash
	install -d ${DESTDIR}${PREFIX}/bin
	install -m 755 qhash $(DESTDIR)${PREFIX}/bin

clean:
	rm qhash libqhash.so || true

.PHONY: all install install-bin clean
