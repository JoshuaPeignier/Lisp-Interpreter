#include <stdio.h>
#include "object.hh"
#include "env.hh"
#include "eval.hh"
#include "toplevel.hh"

extern Object just_read;
extern "C" int yyparse();
extern "C" FILE *yyin;
Environment env;
extern int trace;
extern int allow_print;

using namespace std;

int main() {
  trace = -1;
  Object a =  symbol_to_Object("a");
  Object b =  symbol_to_Object("b");
  Object one = number_to_Object(1);
  Object two = number_to_Object(2);

  env.add_new_binding(Object_to_string(a), one);
  env.add_new_binding(Object_to_string(b), two);
  
  do {
	toplevel();
	reset_setqq();
  } while (!feof(yyin));
}






