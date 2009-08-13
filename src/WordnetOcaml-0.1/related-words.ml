(* A related words driver *)
open Arg;;
open Related;;

let parse_args helpmsg =
  let files = ref [] in
  let _ =  Arg.parse [] (fun s -> files := s :: !files) helpmsg in
  let files = List.rev !files in    
    files
;;


List.iter (fun w ->
             let res = relatedWords w in
               print_endline w;
               List.iter (fun (cnt, word) ->
                            print_endline word
                         ) res
          ) (parse_args "related words!")

