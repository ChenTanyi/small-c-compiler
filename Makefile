CPPFLAGS = -Wall -Wno-strict-aliasing -std=c++11 -g -I. -O2
CPP = g++
EMAIN = ./scc

INPUT = testInput
OUTPUT_IR = InterCode
OUTPUT_MIPS = MipsCode
OUTPUT_TREE = ParserTree

all: scc

scc: main.cpp lex.yy.c y.tab.c tree.cpp node.cpp tree.h header.h node.h
	$(CPP) -o $@ main.cpp lex.yy.c y.tab.c tree.cpp node.cpp $(CPPFLAGS)

lex.yy.c: smallc.l
	lex smallc.l

y.tab.c: smallc.y
	yacc -d -v smallc.y

run: scc
	bash quick-run.sh $(INPUT) $(OUTPUT_MIPS) $(OUTPUT_IR) $(OUTPUT_TREE)
	

clean:
	rm -f *.c *.tab.h *.output

cleanall:
	rm -rf scc *.c *.tab.h *.output $(OUTPUT_MIPS) $(OUTPUT_IR) $(OUTPUT_TREE) 
