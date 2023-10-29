#! /usr/bin/env bash

function test_bashargs_add_optional_flag_parse_without_flag() {
    bashargs::add_optional_flag --argname
    bashargs::parse_args
    [[ $(bashargs::get_arg --argname) == "false" ]]
}

function test_bashargs_add_optional_flag_parse_with_flag() {
    bashargs::add_optional_flag --argname
    bashargs::parse_args --argname
    [[ $(bashargs::get_arg --argname) == "true" ]]
}

function test_bashargs_add_optional_flag_parse_repeated_flag() {
    local return_code=0
    bashargs::add_optional_flag --argname
    $(bashargs::parse_args --argname --argname) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_bashargs_add_optional_flag_repeated_declaration() {
    local return_code=0
    bashargs::add_optional_flag --argname
    $(bashargs::add_optional_flag --argname) || return_code=1
    [[ $return_code -eq 1 ]]
}
