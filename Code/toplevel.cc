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


int setqq = 0;

void use_setqq(){setqq =+ 1;}
int get_setqq(){return setqq;}
void reset_setqq(){setqq = 0;}

