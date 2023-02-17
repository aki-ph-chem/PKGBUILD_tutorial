CC = gcc
DESTDIR=''

greet : main.c
	${CC} -o $@ $<

clean:
	rm greet

install:
	install -s ./greet ${DESTDIR}/ 

.PHONY: clean
