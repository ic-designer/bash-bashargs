function test_bashargs_get_args_no_args() {
    local return_code=0
    $(bashargs::get_arg) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_bashargs_get_args_invalid_arg() {
    local return_code=0
    $(bashargs::get_arg --argname) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_bashargs_get_args_multiple_arguments() {
    bashargs::add_optional_flag --argname-alpha
    bashargs::add_optional_flag --argname-beta
    bashargs::parse_args --argname-alpha
    [[ $(bashargs::get_arg --argname-alpha) == "true" ]]
    [[ $(bashargs::get_arg --argname-beta) == "false" ]]
}
