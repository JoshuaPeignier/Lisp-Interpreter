#include <stdio.h>
#include "object.hh"
#include "env.hh"
#include "eval.hh"
#include "toplevel.hh"

extern int allow_print;

void toplevel(){
    allow_print = 1;
    cout << "Lisp? " << flush;
    yyparse();
    Object l = just_read;
    Object res = eval(l,env);
    if(allow_print ==1){cout << res << endl;}
}


int setqq = 0;

void use_setqq(){setqq =+ 1;}
int get_setqq(){return setqq;}
void reset_setqq(){setqq = 0;}

