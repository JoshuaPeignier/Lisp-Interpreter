#include <stdexcept>
#include <string>
#include <cassert>
#include "object.hh"
#include "eval.hh"

void is_subr(Object f);

Object subr_effect(Object l, Environment env);
