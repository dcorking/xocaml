open Core.Std
open OUnit2
open Codegen
open Model

let leap_template = "\"$description\" >:: ae $expected (leap_year $input);"

let fixup ~key ~value = parameter_to_string value
let edit = Fn.id
let assert_gen exp cases = assert_equal exp
    ~printer:(fun xs -> "[" ^ (String.concat ~sep:";" xs) ^ "]")
    (Result.ok_or_failwith @@ generate_code fixup edit leap_template cases |> List.map ~f:subst_to_string)
let ae exp cases _test_ctxt = assert_gen exp cases

let codegen_tests = [
  "if there are no cases then generate an empty string" >::
    ae [] [];

  "generates one function based on leap year for one case" >::(fun ctxt ->
      let c = {description = "leap_year"; parameters = [("input", Int 1996)]; expected = Bool true} in
      assert_gen ["\"leap_year\" >:: ae true (leap_year 1996);"] [c]
    );
]
