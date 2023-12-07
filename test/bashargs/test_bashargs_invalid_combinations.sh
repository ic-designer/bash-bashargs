#! /usr/bin/env bash
function test_bashargs_add_required_value_with_existing_repeated_optional_declaration() {
    local return_code=0
    bashargs::add_optional_value --argname
    $(bashargs::add_required_value --argname) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_bashargs_add_optional_value_with_existing_repeated_required_declaration() {
    local return_code=0
    bashargs::add_required_value --argname
    $(bashargs::add_optional_value --argname) || return_code=1
    [[ $return_code -eq 1 ]]
}
