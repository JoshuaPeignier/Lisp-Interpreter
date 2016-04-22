#include <stdexcept>
#include <string>
#include <cassert>
#include "subr.hh"

extern Object just_read;
extern "C" int yyparse();

// Tests if the given element (supposed to be the head of the list in eval) is a subroutine
int is_subr(Object f){
	string s;
	s = Object_to_string(f);
	return (s == "car" || s == "cdr" || s == "cons" || s == "progn" || s == "eq" || s == "equal" || s == "=" || s == "read" || s == "print" || s == "debug");
}

// Identifies the corresponding subroutine, and returns the list it is supposed to return
Object subr_effect(Object l){
	string s;
	s = Object_to_string(car(l));
	Object res;
	if(s == "car"){res = subr_car(l);}
	else if(s == "cdr"){res = subr_cdr(l);}
	else if (s == "cons"){res = subr_cons(l);}
	else if (s == "progn"){res = subr_progn(l);}
	else if (s == "eq" || s == "equal" || s == "="){res = subr_eq(l);}
	else if (s == "read"){res = subr_read(l);}
	else if (s == "print"){res = subr_print(l);}
	else if (s == "debug"){res = subr_debug(l);}
	else{
		cout << "Error : invalid subroutine" << endl;
		res = nil();
	}
	return res;
}

Object subr_car(Object l){
	if(size(l) > 2){
		clog << "Error : too many fields in car" << endl;
		return nil();
	}
	if(size(l) < 2){
		clog << "Error : not enough fields in car" << endl;
		return nil();
	}
	Object arg = cadr(l);
	if(!listp(l)){
		clog << "Error : argument in car is not a list" << endl;
		return nil();
	}
	return car(arg);
}

Object subr_cdr(Object l){
	if(size(l) > 2){
		clog << "Error : too many fields in cdr" << endl;
		return nil();
	}
	if(size(l) < 2){
		clog << "Error : not enough fields in cdr" << endl;
		return nil();
	}
	Object arg = cadr(l);
	if(!listp(l)){
		clog << "Error : argument in car is not a list" << endl;
		return nil();
	}
	return cdr(arg);
}

Object subr_cons(Object l){
	if(size(l) > 3){
		clog << "Error : too many fields in cons" << endl;
		return nil();
	}
	if(size(l) < 3){
		clog << "Error : not enough fields in cons" << endl;
		return nil();
	}
	Object head = cadr(l);
	Object tail = caddr(l);
	if(!listp(tail) && tail != nil()){
		clog << "Error : second argument in cons is not a list" << endl;
		return nil();
	}
	if(!numberp(head)){
		clog << "Error : first argument in cons is not a number" << endl;
	}
	return cons(head,tail);
}

Object subr_progn(Object l){
	if(size(l) < 2){
		clog << "Error : not enough fields in progn" << endl;
		return nil();
	}
	Object arg = cdr(l);
	while(size(arg) > 1){
		car(arg);
		arg = cdr(arg);
	}
	return car(arg);

}

Object subr_eq(Object l){
	if(size(l) > 3){
		clog << "Error : : too many fields in " << Object_to_string(car(l)) << endl;
		return nil();
	}
	if(size(l) < 3){
		clog << "Error : not enough fields in " << Object_to_string(car(l)) << endl;
		return nil();
	}
	Object v1 = cadr(l);
	Object v2 = caddr(l);
	if(numberp(v1) && numberp(v2)){
		if(Object_to_number(v1) == Object_to_number(v2)){return t();}
		return nil();
	}
	else if(stringp(v1) && stringp(v2)){
		if(Object_to_string(v1) == Object_to_string(v2)){return t();}
		return nil();
	}
	else if(symbolp(v1) && symbolp(v2)){
		if(Object_to_string(v1) == Object_to_string(v2)){return t();}
		return nil();
	}
	else if(listp(v1) && listp(v2)){
		Object w1 = v1;
		Object w2 = v2;
		while(w1 != nil() && w2 != nil()){
			if(subr_eq(cons(car(l),cons(car(w1),cons(car(w2),nil())))) == nil()){
				return nil();
			}
			w1 = cdr(w1);
			w2 = cdr(w2);
		}
		if((null(w1) && !null(w2)) || (!null(w1) && null(w2))){
			return nil();
		}
		return t();
	}
	return nil();
}

Object subr_read(Object l){
	if(size(l) > 1){
		clog << "Error : read takes no argument" << endl;
		return nil();
	}
	yyparse();
	Object k = just_read;
	return k;
}

Object subr_print(Object l){
	if(size(l) > 2){
		clog << "Error : too many fields in print" << endl;
		return nil();
	}
	if(size(l) < 2){
		clog << "Error : not enough fields in print" << endl;
		return nil();
	}
	clog << cadr(l) << endl;
	return cadr(l);
}

Object subr_debug(Object l){
	if(size(l) > 2){
		clog << "Error : too many fields in debug" << endl;
		return nil();
	}
	if(size(l) < 2){
		clog << "Error : not enough fields in debug" << endl;
		return nil();
	}
	if(!numberp(cadr(l))){
		clog << "Error : argument in debug is not a number" << endl;
		return nil();
	}
	return nil();
}
