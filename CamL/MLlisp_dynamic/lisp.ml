
(************* Lisp interpreter, dynamic/static binding ******)

(*
   lisp.ml types.ml globals.ml parser.mly lexer.mll io.ml \
   utils.ml objects.ml env.ml \
   closure.ml \
   defs.ml \
   eval.ml subr.ml toplevel.ml
*)

#use "Defs/types.ml";;

#use "Utils/globals.ml";;

#use "Read/parser.ml";;

#use "Read/lexer.ml";;

#use "Utils/io.ml";;

#use "Utils/utils.ml";;

#use "Utils/objects.ml";;

#use "Env/env.ml";;

#use "Defs/defs.ml";;

#use "Eval/closure.ml";;

#use "Eval/eval.ml";;

#use "Defs/subr.ml";;

#use "toplevel.ml";;

(******************************************************)

(* Set up all global variables, defined in file "globals.ml" *)

debug := false;;
global_env_ref := empty_env;;
current_channel := stdin;;
max_print_level := 4;;
max_print_env_level := 2;;
print_env_hidden := false;;

(* Set up initialization file, "/dev/null" for a raw start *)

let init_file = "init.lsp";;

(* And now, ready to go! *)

let go () =

  (* Initialize predefined subroutines *)
  init_env_subr ();

  (* Load in the init file, without debug trace, up to end of file *)
  current_channel := (open_in init_file);
  reset_parser ();
  begin
    let initial_debug = !debug
    in
    debug := false;
    begin
      try toplevel ()
      with
      | End_of_file ->
        print_string ("File " ^ init_file ^ " loaded!\n")
    end;
    debug := initial_debug
  end;
  close_in !current_channel;

  (* Switch to direct user interaction *)
  current_channel := stdin;
  reset_parser ();
  try
    begin
      while true do
        try toplevel ()
        with
        | Lisp_error -> ()
      done
    end
  with
  | End_of_file | Lisp_end_of_toplevel ->
    print_string "May Lisp be with you!\n"
;;

go ();;

