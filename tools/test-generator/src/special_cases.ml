open Core.Std

open Model

let optional_int ~(none: int) = function
  | Int n when n = none -> "None"
  | Int n -> "(Some " ^ Int.to_string n ^ ")"
  | x -> parameter_to_string x

let optional_int_or_string ~(none: int) = function
  | String s -> "(Some \"" ^ s ^ "\")"
  | Int n when n = none -> "None"
  | x -> parameter_to_string x

let default_value ~(key: string) ~(value: string) (parameters: (string * string) list): (string * string) list =
  if List.exists ~f:(fun (k, _) -> k = key) parameters
  then parameters
  else (key, value) :: parameters

let optional_strings ~(f: string -> bool) (parameters: (string * string) list): (string * string) list =
  let replace parameter =
    let (k, v) = parameter in
    if f k
    then (k, "(Some \"" ^ v ^ "\")")
    else parameter in
  List.map ~f:replace parameters

let fixup ~(stringify: parameter -> string) ~(slug: string) ~(key: string) ~(value: parameter) = match (slug, key) with
  | ("hamming", "expected") -> optional_int ~none:(-1) value
  | ("say", "expected") -> optional_int_or_string ~none:(-1) value
  | _ -> stringify value

let edit ~(slug: string) (parameters: (string * string) list) = match (slug, parameters) with
  | ("hello-world", ps) -> default_value ~key:"name" ~value:"None"
    @@ optional_strings ~f:(fun _x -> true)
    @@ parameters
  | (_, ps) -> ps
