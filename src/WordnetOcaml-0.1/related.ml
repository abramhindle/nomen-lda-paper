(**
      Related Words               
      using Wordnet Ocaml API                                
   Author: Ramu Ramamurthy ramu_ramamurthy at yahoo dot com  
   (C) 2006                                                 

   Given a word, this tool will suggest related words ordered
   by usage frequency (duplicates may be there)
   Words are related if they are synonyms (more relevant) or are 
   siblings (less relevant) where their senses are siblings under 
   the HYPONYM/HYPERNYM tree
   (notion of related can be changed to include other kinds of
   pointer relationships between senses)


   Examples:

   relatedWords "camel" 
   gives

 [(0, "camel"); (0, "hippo"); (0, "hippopotamus");
 (0, "hippopotamus_amphibius"); (0, "llama"); (0, "musk_hog");
 (0, "peccary"); (0, "river_horse"); (0, "ruminant"); (0, "swine");
 (0, "vicugna_vicugna"); (0, "vicuna")]

   relatedWords "google" 
   gives

 [(0, "google"); (0, "google"); (1, "cast_around"); (1, "re-explore");
 (0, "ask_jeeves"); (0, "beat_about"); (0, "cast_about"); (0, "prospect");
 (0, "yahoo")]
   
   interesting, MSN must be feeling left out!!   
*)

open Wordnet;;

let all_pos = [NOUN;VER;ADJ;ADV]
;;

(** get synonyms for the wordform for the pos *)
let getSynonyms wordform pos =
  try
    let word = getWord wordform pos in
      getSenses word
  with x -> []
;;

(** get siblings for the wordform for the pos *)
let getSiblings wordform pos =
  try
    let word = getWord wordform pos in
    let senses = getSenses word in
    let parents = List.flatten (List.map (getPtrSense HYPERPTR) senses) in
    let children = List.flatten (List.map (getPtrSense HYPOPTR) parents) in
    let check_dup s1 s2 =
      if (isEqualSense s1 s2) then [] else [s2]
    in
    let remove_sense lis sense =
      List.flatten (List.map (check_dup sense) lis)
    in
      List.fold_left remove_sense children senses 
  with x -> []
;;

(** add usage counts to each word *)
let getCntsWords sense =
  let freqTup word = [((getWordSenseCount word sense), word)] in
    List.flatten (List.map freqTup (getWordForms sense))
;;

let relatedWords str =
  let synSenses = List.flatten (List.map (getSynonyms str) all_pos) in
  let sibSenses = List.flatten (List.map (getSiblings str) all_pos) in
  let synwords  =  List.flatten (List.map getCntsWords synSenses) in
  let sibwords  =  List.flatten (List.map getCntsWords sibSenses) in
  let compare (x1,y1) (x2,y2) = 
    if (x1 < x2) then 1
    else if (x1 > x2) then -1 
    else if (y1 < y2) then -1
    else if (y1 > y2) then 1
    else 0
  in
    (List.sort compare synwords)@(List.sort compare sibwords)
;;
    
