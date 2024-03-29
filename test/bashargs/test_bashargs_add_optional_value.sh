function test_bashargs_add_optional_value_parse_without_value_without_default() {
    bashargs::add_optional_value --argname
    bashargs::parse_args
    [[ $(bashargs::get_arg --argname) == "" ]]
}

function test_bashargs_add_optional_value_parse_with_empty_value_without_default() {
    bashargs::add_optional_value --argname
    bashargs::parse_args --argname=
    [[ $(bashargs::get_arg --argname) == "" ]]
}

function test_bashargs_add_optional_value_parse_with_non_empty_value_without_default() {
    bashargs::add_optional_value --argname
    bashargs::parse_args --argname=
    [[ $(bashargs::get_arg --argname) == "" ]]
}


function test_bashargs_add_optional_value_parse_without_value_with_empty_default() {
    bashargs::add_optional_value --argname ""
    bashargs::parse_args
    [[ $(bashargs::get_arg --argname) == "" ]]
}

function test_bashargs_add_optional_value_parse_with_empty_value_with_empty_default() {
    bashargs::add_optional_value --argname ""
    bashargs::parse_args --argname=
    [[ $(bashargs::get_arg --argname) == "" ]]
}

function test_bashargs_add_optional_value_parse_with_non_empty_value_with_empty_default() {
    bashargs::add_optional_value --argname ""
    bashargs::parse_args --argname=value
    [[ $(bashargs::get_arg --argname) == value ]]
}


function test_bashargs_add_optional_value_parse_without_value_with_non_empty_default() {
    bashargs::add_optional_value --argname value
    bashargs::parse_args
    [[ $(bashargs::get_arg --argname) == value ]]
}

function test_bashargs_add_optional_value_parse_with_empty_value_with_non_empty_default() {
    bashargs::add_optional_value --argname value
    bashargs::parse_args --argname=
    [[ $(bashargs::get_arg --argname) == "" ]]
}

function test_bashargs_add_optional_value_parse_with_non_empty_value_with_same_non_empty_default() {
    bashargs::add_optional_value --argname value
    bashargs::parse_args --argname=value
    [[ $(bashargs::get_arg --argname) == value ]]
}

function test_bashargs_add_optional_value_parse_with_non_empty_value_with_different_non_empty_default() {
    bashargs::add_optional_value --argname value
    bashargs::parse_args --argname=different
    [[ $(bashargs::get_arg --argname) == different ]]
}

function test_bashargs_add_optional_value_parse_with_quoted_value () {
    bashargs::add_optional_value --argname
    bashargs::parse_args --argname="value"
    [[ $(bashargs::get_arg --argname) == "value" ]]
}

function test_bashargs_add_optional_value_parse_with_quoted_value_spaces () {
    bashargs::add_optional_value --argname
    bashargs::parse_args --argname="value value"
    [[ $(bashargs::get_arg --argname) == "value value" ]]
}

function test_bashargs_add_optional_value_parse_repeated_invocation() {
    local return_code=0
    bashargs::add_optional_value --argname
    $(bashargs::parse_args --argname=value1 --argname=value2) || return_code=1
    [[ $return_code -eq 1 ]]
}

function test_bashargs_add_optional_value_repeated_declaration() {
    local return_code=0
    bashargs::add_optional_value --argname
    $(bashargs::add_optional_value --argname) || return_code=1
    [[ $return_code -eq 1 ]]
}
