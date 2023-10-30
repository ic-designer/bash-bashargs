#! /usr/bin/env bash

function test_bashargs_parse_args_no_args() {
    local return_code=0
    $(bashargs::parse_args) || return_code=1
    [[ $return_code -eq 0 ]]
}
