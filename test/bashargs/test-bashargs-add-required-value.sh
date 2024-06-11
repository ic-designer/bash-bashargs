function test_bashargs_add_required_value_parse_with_empty_value() {
    bashargs::add_required_value --argname
    bashargs::parse_args --argname=
    [[ $(bashargs::get_arg --argname) == "" ]]
}

function test_bashargs_add_required_value_parse_with_non_empty_value() {
    bashargs::add_required_value --argname
    bashargs::parse_args --argname=value
    [[ $(bashargs::get_arg --argname) == "value" ]]
}

function test_bashargs_add_required_value_parse_without_required_argument() {
    local return_code=0
    bashargs::add_required_value --argname
    $(bashargs::parse_args) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_bashargs_add_required_value_parse_without_value() {
    local return_code=0
    bashargs::add_required_value --argname
    $(bashargs::parse_args --argname) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_bashargs_add_required_value_parse_repeated_invocations() {
    local return_code=0
    bashargs::add_required_value --argname
    $(bashargs::parse_args --argname=value1 --argname=value2) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_bashargs_add_required_value_repeated_declaration() {
    local return_code=0
    bashargs::add_required_value --argname
    $(bashargs::add_required_value --argname) || return_code=1
    [[ $return_code -eq 1 ]]
}
