function bashargs::add_optional_flag() {
    # Creates an optional flag argument
    #
    # Args:
    #   name: Name of the argument.
    #
    # Error:
    #   Throws and error if the argument already exists
    #
    # Example:
    #   bashargs::add_optional_flag --argument
    #
    local -r _argname=$1
    bashargs::_append_arg_list flag ${_argname} optional -
}

function bashargs::add_optional_value() {
    # Creates an optional value argument
    #
    # Args:
    #   name: Name of the argument.
    #
    # Error:
    #   Throws and error if the argument already exists
    #
    # Example:
    #   bashargs::add_optional_value --argument
    #
    local -r _argname=$1
    bashargs::_append_arg_list value ${_argname} optional default=${2:-}
}

function bashargs::add_required_value() {
    # Creates an required value argument
    #
    # Args:
    #   name: Name of the argument.
    #
    # Error:
    #   Throws and error if the argument already exists
    #
    # Example:
    #   bashargs::add_required_value --argument
    #
    local -r _argname=$1
    bashargs::_append_arg_list value ${_argname} required -
}

function bashargs::parse_args() {
    # Parses the command line arguments
    #
    # Args:
    #   Variable list of arguments
    #
    # Error:
    #   Throws an error if a bad argument is passes
    #
    # Example:
    #   bashargs::parse_args "$@"
    #
    eval "unset \${!$(bashargs::_get_varname_arg_count "")@}"
    eval "unset \${!$(bashargs::_get_varname_arg_value "")@}"
    bashargs::_initialize_optional_args
    bashargs::_process_args "$@"
    bashargs::_check_required_args "$@"
}

function bashargs::get_arg() {
    # Returns the value associcated with the argument
    #
    # Args:
    #   name: Name of the argument.
    #
    # Error:
    #   Throws an error argument doesn't exist
    #
    # Example:
    #   bashargs::get_arg --flag
    #   bashargs::get_arg --value
    #
    local -r _argname=$1
    local -r varname_value=$(bashargs::_get_varname_arg_value ${_argname})
    echo ${!varname_value}
}

function bashargs::_append_arg_list() {
    # Appends the argument definition fields to the global variable naemd by the
    # bashargs::_get_varname_arg_list() function. The fields are ordered as follows:
    # argtype, argname, necessity, and default.
    #
    # Args:
    #   argtype: Type of argument: flag, value.
    #   argname: Name of the argument.
    #   necessity: Necessity of argument: optional, required.
    #   default (optional): Default value of argument. Defaults to "".
    #
    # Exports:
    #   Space delimited order list of argument fields to global list variable
    #
    # Error:
    #   Throws an error if an argument is repeated
    #
    local -r _argtype=$1
    local -r _argname=$2
    local -r _necessity=$3
    local -r _default=$4
    local -r entry=( "${_argtype} ${_argname} ${_necessity} ${_default}" )
    local -r varname_arg_list=$(bashargs::_get_varname_arg_list)
    if [[ -z ${!varname_arg_list++} ]]; then
        eval "${varname_arg_list}"='( ${entry[@]} )'
    else
        while \read -t 1 -r _ _existing_argname _ _; do
            if [[ ${_argname} == ${_existing_argname} ]]; then
                echo "ERROR: repeated argument: ${_argname}" 1>&2
                exit 1
            fi
        done < <(echo $(bashargs::_get_arg_list)| xargs -n 4 2>/dev/null)
        eval "${varname_arg_list}"='( ${'"${varname_arg_list}"'[@]}  ${entry[@]} )'
    fi
    export ${varname_arg_list}
}

function bashargs::_check_required_args() {
    # Checks that all the required command line arguments are present.
    #
    # Error:
    #   Throws an error if an argument is missing
    #
    while \read -t 1 -r _argtype _argname _necessity _default ; do
        if [[ ${_necessity} == "required" ]]; then
            local varname_value=$(bashargs::_get_varname_arg_value ${_argname})
            if [[ -z ${!varname_value++} ]]; then
                echo "ERROR: missing required argument: ${_argname}" 1>&2
                exit 1
            fi

        fi
    done < <(echo $(bashargs::_get_arg_list)| xargs -n 4 2>/dev/null)
}

function bashargs::_get_arg_list() {
    # Retrieves the list of argument fields from the the global variable list.
    #
    # Returns:
    #   prefix string
    #
    eval 'echo ${'"$(bashargs::_get_varname_arg_list)"'[@]}'
}

function bashargs::_get_varname_arg_count() {
    # Returns the global variable associated with the argument count.
    #
    # Args:
    #   argname: Name of the argument.
    #
    # Returns:
    #   argument global count variable name
    #
    local -r _argname=$1
    echo "$(bashargs::_get_varname_prefix)_COUNT_${_argname//-/_}__"
}

function bashargs::_get_varname_arg_list() {
    # Retrieves the list of argument fields from the the global variable list.
    #
    # Returns:
    #   space delimited ordered list of all argument fields
    #
    echo "$(bashargs::_get_varname_prefix)_LIST__"
}

function bashargs::_get_varname_arg_value() {
    # Returns the global variable associated with the argument value.
    #
    # Args:
    #   argname: Name of the argument.
    #
    # Returns:
    #   argument global value variable name
    #
    local -r _argname=$1
    echo "$(bashargs::_get_varname_prefix)_VALUE_${_argname//-/_}__"
}

function bashargs::_get_varname_prefix() {
    # Retrieves the common prefix shared by all global variables
    #
    # Returns:
    #   global variable prefix
    #
    echo "__BASHARGS_VARIABLE_"
}

function bashargs::_initialize_optional_args() {
    # Initializes the optional arguments to default values. The values are stored in a global
    # variable named by the bashargs::_get_varname_arg_value() function.
    #
    # Exports:
    #   default argument value to global variable determined by bashargs::_get_varname_arg_value()
    #
    # Error:
    #   Throws an error if the global variable is already defined.
    #
    while \read -t 1 -r _argtype _argname _necessity _default ; do
        if [[ -n ${_argname} ]]; then
            local varname=$(bashargs::_get_varname_arg_value ${_argname})
            if [[ ${_necessity} == "optional" ]]; then
                if [[ -n ${!varname++} ]]; then
                    echo "ERROR: optional variable name already in use: ${_argname}" 1>&2
                    exit 1
                fi
                case ${_argtype} in
                    flag)
                        export ${varname}=false
                        ;;
                    value)
                        export ${varname}=${_default#*=}
                        ;;
                esac
            fi
        fi
    done < <(echo $(bashargs::_get_arg_list)| xargs -n 4 2>/dev/null)
}

function bashargs::_process_args() {
    # Process the command line argumentes
    #
    # Args:
    #   command line arguments
    #
    # Error:
    #   Throws an error if an argument is repeated
    #   Throws an error if an argument is not recongnized
    #
    while [[ $# -gt 0 ]]; do
        local invalid_argument=true
        while \read -t 1 -r _argtype _argname _necessity _default; do
            local varname_count=$(bashargs::_get_varname_arg_count ${_argname})
            local varname_value=$(bashargs::_get_varname_arg_value ${_argname})
            if [[ -n ${!varname_count++} ]]; then
                echo "ERROR: repeated argument: ${_argname}" 1>&2
                exit 1
            fi
            case ${_argtype} in
                flag)
                    if [[ $1 = ${_argname} ]]; then
                        export ${varname_value}=true
                        export ${varname_count}=1
                        invalid_argument=false
                        shift
                        break
                    fi
                    ;;
                value)
                    if [[ $1 =~ ^${_argname}= ]]; then
                        export ${varname_value}="${1#*=}"
                        export ${varname_count}=1
                        invalid_argument=false
                        shift
                        break
                    fi
                    ;;
                *)
                    echo "ERROR: unknown arguemnt type: ${_argtype}"
                    exit 1
                    ;;
            esac
        done < <(echo $(bashargs::_get_arg_list)| xargs -n 4 2>/dev/null)
        if [[ "${invalid_argument}" == "true" ]]; then
            echo "ERROR: Unknown option $1"
            exit 1
        fi
    done
}
