(**
   Public-facing grammar. This is the parser target.
*)

open Core

type eexpr =
    And of eexpr * eexpr
  | Or of eexpr * eexpr
  | Not of eexpr
  | Ite of eexpr * eexpr * eexpr
  | Flip of float
  | Let of String.t * eexpr * eexpr
  | Observe of eexpr
  | True
  | False

type program = eexpr

let rec string_of_eexpr e =
  match e with
  | And(e1, e2) -> sprintf "%s && %s" (string_of_eexpr e1) (string_of_eexpr e2)
  | Or(e1, e2) -> sprintf "%s || %s" (string_of_eexpr e1) (string_of_eexpr e2)
  | Not(e) -> sprintf "! %s" (string_of_eexpr e)
  | Ite(g, thn, els) ->
    sprintf "if %s then %s else %s"
      (string_of_eexpr g) (string_of_eexpr thn) (string_of_eexpr els)
  | Let(id, e1, e2) ->
    sprintf "let %s = %s in %s"
      id (string_of_eexpr e1) (string_of_eexpr e2)
  | Observe(e) -> sprintf "observe %s" (string_of_eexpr e)
  | True -> "true"
  | False -> "false"
  | Flip(f) -> sprintf "flip %f" f
