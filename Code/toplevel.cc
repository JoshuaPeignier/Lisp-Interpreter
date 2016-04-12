#include <stdio.h>
#include "object.hh"
#include "env.hh"
#include "eval.hh"
#include "toplevel.hh"

void toplevel(){
    cout << "Lisp? " << flush;
    yyparse();
    Object l = just_read;
    cout << eval(l, env) << endl;
}

int get_setqq();
void use_setqq();
void toplevel();
