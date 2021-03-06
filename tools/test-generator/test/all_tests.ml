open Core.Std
open OUnit2
open Codegen_test
open Model_test
open Parser_test
open Special_cases_test
open Template_test
open Utils_test

let () =
  run_test_tt_main ("tests" >:::List.concat [codegen_tests; model_tests; parser_tests; special_cases_tests; template_tests; utils_tests])
