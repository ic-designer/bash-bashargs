#! /usr/bin/env bash

function test_bashargs_parse_args_no_args() {
    local return_code=0
    $(bashargs::parse_args) || return_code=1
    [[ $return_code -eq 0 ]]
}

function test_bashargs_parse_args_repeated_parse_with_then_without_flag() {
    bashargs::add_optional_flag --argname
    bashargs::parse_args --argname
    bashargs::parse_args
    [[ $(bashargs::get_arg --argname) == "false" ]]
}

function test_bashargs_parse_args_repeated_parse_without_then_with_flag() {
    bashargs::add_optional_flag --argname
    bashargs::parse_args
    bashargs::parse_args --argname
    [[ $(bashargs::get_arg --argname) == "true" ]]
}
