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
Object subr_debug(Object l);
Object subr_newline(Object l);
Object subr_listp(Object l);
Object subr_numberp(Object l);
Object subr_symbolp(Object l);
Object subr_stringp(Object l);
Object subr_null(Object l);
