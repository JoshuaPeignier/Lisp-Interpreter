#include <iostream>
#include <cassert>
#include <string>
#include "object.hh"

using namespace std;
extern int allow_print;

Object nil() {
  return Cell::nil();
}


Object t(){
  return string_to_Object("t");
}

bool null(Object l) {
  return l == nil();
}

Object cons(Object a, Object l) {
  Object p = new Cell();
  p -> make_cell_pair(a, l);
  return p;
}

Object car(Object l) {
  assert(!null(l));
  return l -> to_pair_item();
}

Object cdr(Object l) {
  assert(!null(l));
  return l -> to_pair_next();
}

int size(Object l) {
  if(null(l)){return 0;}
  else{return 1 + size(cdr(l));}
}

Object empty() {
  return nil();;
}

bool is_empty(Object l) {
  return null(l);
}

Object number_to_Object(int n) {
  Object p = new Cell();
  p -> make_cell_number(n);
  return p;
}

Object string_to_Object(string s) {
  Object p = new Cell();
  p -> make_cell_string(s);
  return p;
}

Object symbol_to_Object(string s) {
  Object p = new Cell();
  p -> make_cell_symbol(s);
  return p;
}

int Object_to_number(Object l) {
  return l -> to_number();
}

string Object_to_string(Object l) {
  assert(l -> is_string() || l -> is_symbol());
  if (l -> is_string()) return l -> to_string();
  if (l -> is_symbol()) return l -> to_symbol();
  assert(false);
}

Object lisperror(string s){
	clog << "Lisp error : " << s << endl;
	allow_print = 0;
	return nil();
}
