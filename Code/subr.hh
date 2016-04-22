#include <stdexcept>
#include <string>
#include <cassert>
#include "object.hh"
#include "eval.hh"

int is_subr(Object f);

Object subr_effect(Object l);

Object subr_car(Object l);
Object subr_cdr(Object l);
Object subr_cons(Object l);
Object subr_progn(Object l);
Object subr_eq(Object l);
Object subr_read(Object l);
Object subr_print(Object l);
