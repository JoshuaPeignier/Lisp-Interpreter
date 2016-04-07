.SUFFIX:
.SUFFIX: .ml .lsp .mll .mly 
.PHONY: default clean lisp all ocamldoc

PARSER	= Read/parser.ml
LEXER		= Read/lexer.ml

default: lisp

all: default clean 

$(PARSER): %.ml: %.mly
	ocamlyacc $<

$(LEXER): %.ml: %.mll
	ocamllex $<

lisp: $(PARSER) $(LEXER) Makefile
	-rlwrap ocaml lisp.ml

clean:
	-rm *~ $(PARSER) $(LEXER) \#*

LIST = \
	Defs/types.ml \
	Utils/globals.ml \
	Read/parser.ml \
	Read/lexer.ml \
	Utils/io.ml \
	Utils/utils.ml \
	Utils/objects.ml \
	Env/env.ml \
	Defs/defs.ml \
	Eval/eval.ml \
	Defs/subr.ml \
	toplevel.ml \
	lisp.ml 

ocamldoc:
	ocamldoc -d Doc $(LIST)



