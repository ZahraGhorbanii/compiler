all:	
	bison -d parser.y
	flex lexer.l
	g++ parser.tab.c lex.yy.c -lfl -o p
	./p 1
	./p 0
clean:
	rm lex.yy.c
	rm parser.tab.h
	rm parser.tab.c
	rm p	

