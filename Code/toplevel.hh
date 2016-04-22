#include <stdio.h>
#include "object.hh"
#include "env.hh"
#include "eval.hh"

extern Object just_read;
extern "C" int yyparse();
extern "C" FILE *yyin;
extern Environment env;

int get_setqq();
void use_setqq();
void toplevel();
void reset_setqq();
