open Core
open Cudd
open Wmc
open TopLevel
open CoreGrammar
open AddImpl
open Lexing
open Lexer
open Parser

let print_position outx lexbuf =
  let pos = lexbuf.lex_curr_p in
  fprintf outx "%s:%d:%d" pos.pos_fname
    pos.pos_lnum (pos.pos_cnum - pos.pos_bol + 1)

let parse_with_error lexbuf =
  try Parser.program Lexer.token lexbuf with
  | SyntaxError msg ->
    fprintf stderr "%a: %s\n" print_position lexbuf msg;
    failwith ""
  | Parser.Error ->
    fprintf stderr "%a: syntax error\n" print_position lexbuf;
    failwith ""

let rec parse_and_print lexbuf =
  let parsed = parse_with_error lexbuf in
  Format.printf "%s\n" (ExternalGrammar.string_of_eexpr parsed)

let loop filename () =
  let inx = In_channel.create filename in
  let lexbuf = Lexing.from_channel inx in
  lexbuf.lex_curr_p <- { lexbuf.lex_curr_p with pos_fname = filename };
  parse_and_print lexbuf;
  In_channel.close inx

let () =
  Command.basic_spec ~summary:"Parse and display JSON"
    Command.Spec.(empty +> anon ("filename" %: string))
    loop
  |> Command.run

