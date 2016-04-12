#include <stdexcept>
#include <string>
#include <cassert>
#include "subr.hh"

// Tests if the given element (supposed to be the head of the list in eval) is a subroutine
void is_subr(Object f){
	char* s = NULL;
	s = Object_to_string(f);
	return (s == "car" || s == "cdr" || s == "cons" || "progn");
}

// Identifies the corresponding subroutine, and returns the list it is supposed to return
Object subr_effect(Object l, Environment env){
	char* s = NULL;
	s = Object_to_string(car(l));
	if(s == "car"){return subr_car(l,env);}
	else if(s == "cdr"){return subr_cdr(l,env);}
	else if (s == "cons"){return subr_cons(l,env);}
	else if (s == "progn"){return subr_progn(l,env);}
}

static Object subr_car(Object l, Environment env){
	if(size(l) > 2){
		clog << "Too many fields in car" << endl;
		return eval(nil(),env);
	}
	if(size(l) < 2){
		clog << "Not enough fields in car" << endl;
		return eval(nil(),env);
	}
	Object arg = eval(cadr(l),env);
	if(!listp(l)){
		clog << "Error : argument in car is not a list" << endl;
		return eval(nil(),env);
	}
	return car(arg);
}

static Object subr_cdr(Object l, Environment env){
	if(size(l) > 2){
		clog << "Too many fields in cdr" << endl;
		return eval(nil(),env);
	}
	if(size(l) < 2){
		clog << "Not enough fields in cdr" << endl;
		return eval(nil(),env);
	}
	Object arg = eval(cadr(l),env);
	if(!listp(l)){
		clog << "Error : argument in car is not a list" << endl;
		return eval(nil(),env);
	}
	return cdr(arg);
}

static Object subr_cons(Object l, Environment env){
	if(size(l) > 3){
		clog << "Too many fields in cons" << endl;
		return eval(nil(),env);
	}
	if(size(l) < 3){
		clog << "Not enough fields in cons" << endl;
		return eval(nil(),env);
	}
	Object head = eval(cadr(l),env);
	Object tail = eval(caddr(l),env);
	if(!listp(tail)){
		clog << "Error : second argument in cons is not a list" << endl;
		return eval(nil(),env);
	}
	if(!numberp(head)){
		clog << "Error : first argument in cons is not a number" << endl;
	}
	return cons(head,tail);
}

static Object subr_progn(Object l, Environment env){
	if(size(l) < 2){
		clog << "Not enough fields in progn" << endl;
	}
	Object arg = cdr(l);
	while(size(arg) > 2){
		eval(arg,env);
	}
	return eval(arg,env);

}
