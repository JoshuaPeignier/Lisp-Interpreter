#include <stdexcept>
#include <string>
#include <cassert>
#include "eval.hh"
#include "toplevel.hh"

using namespace std;


bool numberp(Object l) {
  return l -> is_number();
}

bool stringp(Object l) {
  return l -> is_string();
}

bool symbolp(Object l) {
  return l -> is_symbol();
}

bool listp(Object l) {
  return l -> is_pair();
}

Object cadr(Object l) {
  return car(cdr(l));
}

Object cddr(Object l) {
  return cdr(cdr(l));
}

Object caddr(Object l) {
  return car(cddr(l));
}

Object cdddr(Object l) {
  return cdr(cddr(l));
}

Object cadddr(Object l) {
  return car(cdddr(l));
}

class Evaluation_Exception: public runtime_error {
private:
  Object obj;
  Environment env;
  string message;
public:
  Evaluation_Exception(Object _obj, Environment &_env, string _message):
    runtime_error("Evaluation error:" + _message) {
    obj = _obj;
    env = _env;
    message = _message;
  }
  virtual ~Evaluation_Exception() throw () {}
};

Object eval(Object l, Environment &env);
Object apply(Object f, Object lvals, Environment &env);
Object eval_list(Object largs, Environment &env);

Object eval(Object l, Environment &env) {
  clog << "\teval: " << l << env << endl;
  if (null(l)) return l;
  if (numberp(l)) return l;
  if (stringp(l)) return l;
  if (symbolp(l)) {
	if(Object_to_string(l) == "t"){
		return l; // In case we want do to a condition which is always true
	}
	return env.find_value(Object_to_string(l));
  }
  assert(listp(l));
  Object f = car(l);
  if (symbolp(f)) {
    if (Object_to_string(f) == "quote") return cadr(l);
    if (Object_to_string(f) == "if") {
      Object test_part = cadr(l);
      Object then_part = caddr(l);
      Object else_part = cadddr(l);
      Object test_value = eval(test_part, env);
      if (null(test_value)) return eval(else_part, env);
      return eval(then_part, env);
    }
    if(Object_to_string(f) == "lambda") return l;
    if(Object_to_string(f) == "setq"){
		if (get_setqq() > 0){
			clog << "Warning : setq used several times\n" << endl;
		}
		use_setqq();
		if(size(l) > 3){
		clog << "Error : too many values in setq\n" << endl;
			return eval(nil(),env);
		}
		else if(size(l) < 3){
			clog << "Error : not enough values in setq\n" << endl;
			return eval(nil(),env);
		}
		Object var = cadr(l);
		Object val = caddr(l);
		env.extend_env(cons(var,nil()),cons(eval(val,env),nil()));
		return eval(var,env);

    }
  }
  if(numberp(f)){
	clog << "Warning : tried to evaluate a list of numbers" << endl;
	return l;
  }
  // It is a function applied to arguments
  Object vals = eval_list(cdr(l), env);
  return apply(f, vals, env);
}

Object eval_list(Object largs, Environment &env) {
  if (null(largs)) return largs;
  return cons(eval(car(largs), env), eval_list(cdr(largs), env));
}


Object do_plus(Object lvals) {
  int a = Object_to_number(car(lvals));
  int b = Object_to_number(cadr(lvals));
  return number_to_Object(a + b);
}

Object do_times(Object lvals) {
  int a = Object_to_number(car(lvals));
  int b = Object_to_number(cadr(lvals));
  return number_to_Object(a * b);
}

Object do_minus(Object lvals) {
  int a = Object_to_number(car(lvals));
  int b = Object_to_number(cadr(lvals));
  return number_to_Object(a - b);
}

Object apply(Object f, Object lvals, Environment &env) {
  clog << "\tapply: " << f << " " << lvals << env << endl;

  if (null(f)) throw Evaluation_Exception(f, env, "Cannot apply nil");
  if (numberp(f)) throw Evaluation_Exception(f, env, "Cannot apply a number");
  if (stringp(f)) {
	/*
	if(Object_to_string(f) == "setq"){
	}*/
	throw Evaluation_Exception(f, env, "Cannot apply a string");
  }
  if (symbolp(f)) {
    if (Object_to_string(f) == "+") return do_plus(lvals);
    if (Object_to_string(f) == "*") return do_times(lvals);
    if (Object_to_string(f) == "-") return do_minus(lvals);
    if(is_subr(f)){
	return subr_effect(cons(f,lvals));
    }
    Object new_f = env.find_value(Object_to_string(f));
    return apply(new_f, lvals, env);
  }
  assert(listp(f));
  if (Object_to_string(car(f)) == "lambda") {
    if(size(f) > 3){
		clog << "Error : too many fields in lambda \n" << endl;
		return eval(nil(),env);
    }
    else if(size(f) < 3){
		clog << "Error : not enough fields in lambda\n" << endl;
		return eval(nil(),env);
    }
    Object lpars = cadr(f);
    Object body = caddr(f);
    Environment new_env = env;
    new_env.extend_env(lpars, lvals);
    return eval(body, new_env);
  }
  throw Evaluation_Exception(f, env, "Cannot apply a list");
  assert(false);
}
