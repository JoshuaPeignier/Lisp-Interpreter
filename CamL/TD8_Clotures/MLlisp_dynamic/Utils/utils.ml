
(**************** Utilities *************************)

let (init_counter, incr_counter, decr_counter, get_counter) =
  let level = ref(0) in
  ((function () -> level := 0),
   (function () -> level := !level + 1),
   (function () -> level := !level - 1),
   (function () -> !level))
;;

let print_string_level s =
  begin
    print_string "\t";
    for i = 1 to (get_counter())
    do
      print_string " "
    done;
    print_int (get_counter());
    print_string s
  end
;;

exception Lisp_error;;

let error s =
  let message = "Lisp error! " ^ s
  in begin
    print_string message;
    print_string "\n";
    raise Lisp_error
  end
;;

let error2 obj s =
  let message = "Lisp error! " ^ s
  in begin
    print_string message;
    print_string ": ";
    print obj;
    print_string "\n";
    raise Lisp_error
  end
;;

