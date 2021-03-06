#include <stdexcept>
#include <string>
#include <cassert>
#include <cstdio>
#include <cstdlib>
#include "subr.hh"

extern Object just_read;
extern "C" int yyparse();
int trace;

// Tests if the given element (supposed to be the head of the list in eval) is a subroutine
int is_subr(Object f){
	string s;
	s = Object_to_string(f);
	return (s == "car" || s == "cdr" || s == "cons" || s == "progn" || s == "eq" || s == "equal" || s == "=" || s == "read" || s == "print" || s == "debug" || s == "newline" || s == "listp" || s == "numberp" || s == "symbolp" || s == "stringp" || s == "null" || s == "concat" || s == "eval" || s == "apply" ||  s == "error");
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
	else if (s == "newline"){res = subr_newline(l);}
	else if (s == "listp"){res = subr_listp(l);}
	else if (s == "numberp"){res = subr_numberp(l);}
	else if (s == "symbolp"){res = subr_symbolp(l);}
	else if (s == "stringp"){res = subr_stringp(l);}
	else if (s == "null"){res = subr_null(l);}
	else if (s == "concat"){res = subr_concat(l);}
	else if (s == "eval"){res = subr_eval(l);}
	else if (s == "apply"){res = subr_apply(l);}
	else if (s == "error"){res = subr_error(l);}
	else{
		return lisperror("invalid subroutine");
	}
	return res;
}

Object subr_car(Object l){
	if(size(l) > 2){
		return lisperror("too many fields in car");
	}
	if(size(l) < 2){
		return lisperror("not enough fields in car");
	}
	Object arg = cadr(l);
	if(!listp(l)){
		return lisperror("argument in car is not a list");
	}
	return car(arg);
}

Object subr_cdr(Object l){
	if(size(l) > 2){
		return lisperror("too many fields in cdr");
	}
	if(size(l) < 2){
		return lisperror("not enough fields in cdr");
	}
	Object arg = cadr(l);
	if(!listp(l)){
		return lisperror("argument in car is not a list");
	}
	return cdr(arg);
}

Object subr_cons(Object l){
	if(size(l) > 3){
		return lisperror("too many fields in cons");
	}
	if(size(l) < 3){
		return lisperror("not enough fields in cons");
	}
	Object head = cadr(l);
	Object tail = caddr(l);
	if(!listp(tail) && tail != nil()){
		return lisperror("second argument in cons is not a list");
	}
	return cons(head,tail);
}

Object subr_progn(Object l){
	if(size(l) < 2){
		return lisperror("not enough fields in progn");
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
		return lisperror("too many fields in " + Object_to_string(car(l)));
	}
	if(size(l) < 3){
		return lisperror("not enough fields in " + Object_to_string(car(l)));
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
		return lisperror("read takes no argument but it is given one");
	}
	yyparse();
	Object k = just_read;
	return k;
}

Object subr_print(Object l){
	if(size(l) > 2){
		return lisperror("too many fields in print");
	}
	if(size(l) < 2){
		return lisperror("not enough fields in print");
	}
	clog << cadr(l) << endl;
	return cadr(l);
}

Object subr_debug(Object l){
	if(size(l) > 2){
		return lisperror("too many fields in debug");
	}
	if(size(l) < 2){
		return lisperror("not enough fields in debug");
	}
	if(cadr(l) == nil()){
		trace =-1;
	}
	else if(numberp(cadr(l))){
		if(Object_to_number(cadr(l)) > 0){
			trace = Object_to_number(cadr(l));
		}
	}
	else if(!numberp(cadr(l))){
		return lisperror("argument in debug is not a number, nor is it nil");
	}
	return nil();
}

Object subr_newline(Object l){
	if(size(l) > 1){
		return lisperror("newline takes no argument");
	}
	clog << "" << endl;
	return nil();
}

Object subr_listp(Object l){
	if(size(l) > 2){
		return lisperror("too many fields in listp");
	}
	if(size(l) < 2){
		return lisperror("not enough fields in listp");
	}
	if(listp(cadr(l))){return t();}
	else{return nil();}
}

Object subr_numberp(Object l){
	if(size(l) > 2){
		return lisperror("too many fields in numberp");
	}
	if(size(l) < 2){
		return lisperror("not enough fields in numberp");
	}	
	if(numberp(cadr(l))){return t();}
	else{return nil();}
}

Object subr_symbolp(Object l){
	if(size(l) > 2){
		return lisperror("too many fields in symbolp");
	}
	if(size(l) < 2){
		return lisperror("not enough fields in symbolp");
	}
	if(symbolp(cadr(l))){return t();}
	else{return nil();}
}

Object subr_stringp(Object l){
	if(size(l) > 2){
		return lisperror("too many fields in stringp");
	}
	if(size(l) < 2){
		return lisperror("not enough fields in stringp");
	}
	if(stringp(cadr(l))){return t();}
	else{return nil();}
}

Object subr_null(Object l){
	if(size(l) > 2){
		return lisperror("too many fields in null");
	}
	if(size(l) < 2){
		return lisperror("not enough fields in null");
	}
	if(null(cadr(l))){return t();}
	else{return nil();}
}

Object subr_concat(Object l){
	if(size(l) < 2){
		return lisperror("not enough fields in concat");
	}
	Object arg = cdr(l);
	string res = "";
	while(!null(arg)){
		if(stringp(car(arg)) || symbolp(car(arg))){
			res = res+Object_to_string(car(arg));
		}
		else if(numberp(car(arg))){
			int resInt = Object_to_number(car(arg));
			char buf[64];
			sprintf(buf, "%d", resInt);
			string str(buf);
			res = res + buf;
		}
		else{
			return lisperror("argument in concat is not a symbol nor a string nor a number");
		}
		arg = cdr(arg);
	}
	return string_to_Object(res);
}

Object subr_eval(Object l){
	if(size(l) > 2){
		return lisperror("too many fields in eval");
	}
	if(size(l) < 2){
		return lisperror("not enough fields in eval");
	}
	return eval(cadr(l),env);
}

Object subr_apply(Object l){
	if(size(l) > 3){
		return lisperror("too many fields in apply");
	}
	if(size(l) < 3){
		return lisperror("not enough fields in apply");
	}
	return apply(cadr(l),caddr(l),env);
}

Object subr_error(Object l){
	if(size(l) > 2){
		return lisperror("too many fields in error");
	}
	if(size(l) < 2){
		return lisperror("not enough fields in error");
	}
	if(!stringp(cadr(l))){
		return lisperror("argument in error is not a string");
	}
	return lisperror(Object_to_string(cadr(l)));
}
