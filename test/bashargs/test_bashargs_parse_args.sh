function test_bashargs_parse_args_no_args() {
    local return_code=0
    $(bashargs::parse_args) || return_code=1
    [[ $return_code -eq 0 ]]
}

function test_bashargs_parse_args_repeated_parse_with_and_without_optional_flag() {
    bashargs::add_optional_flag --argname
    bashargs::parse_args --argname
    bashargs::parse_args
    [[ $(bashargs::get_arg --argname) == "false" ]]
}

function test_bashargs_parse_args_repeated_parse_without_and_with_optional_flag() {
    bashargs::add_optional_flag --argname
    bashargs::parse_args
    bashargs::parse_args --argname
    [[ $(bashargs::get_arg --argname) == "true" ]]
}

function test_bashargs_parse_args_mulitple_required_arguments() {
    bashargs::add_required_value --alpha
    bashargs::add_required_value --beta
    bashargs::parse_args --alpha=alpha --beta=beta
    [[ $(bashargs::get_arg --alpha) == "alpha" ]]
    [[ $(bashargs::get_arg --beta) == "beta" ]]
}

function test_bashargs_parse_args_mulitple_optional_arguments() {
    bashargs::add_optional_value --alpha
    bashargs::add_optional_value --beta
    bashargs::parse_args --alpha=alpha --beta=beta
    [[ $(bashargs::get_arg --alpha) == "alpha" ]]
    [[ $(bashargs::get_arg --beta) == "beta" ]]
}
