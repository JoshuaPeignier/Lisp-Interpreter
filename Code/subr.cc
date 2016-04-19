#include <stdexcept>
#include <string>
#include <cassert>
#include "subr.hh"

// Tests if the given element (supposed to be the head of the list in eval) is a subroutine
int is_subr(Object f){
	string s;
	s = Object_to_string(f);
	return (s == "car" || s == "cdr" || s == "cons" || s == "progn");
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
	else{
		cout << "Error : invalid subroutine" << endl;
		res = nil();
	}
	return res;
}

Object subr_car(Object l){
	if(size(l) > 2){
		clog << "Too many fields in car" << endl;
		return nil();
	}
	if(size(l) < 2){
		clog << "Not enough fields in car" << endl;
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
		clog << "Too many fields in cdr" << endl;
		return nil();
	}
	if(size(l) < 2){
		clog << "Not enough fields in cdr" << endl;
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
		clog << "Too many fields in cons" << endl;
		return nil();
	}
	if(size(l) < 3){
		clog << "Not enough fields in cons" << endl;
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
		clog << "Not enough fields in progn" << endl;
	}
	Object arg = cdr(l);
	while(size(arg) > 1){
		car(arg);
		arg = cdr(arg);
	}
	return car(arg);

}
