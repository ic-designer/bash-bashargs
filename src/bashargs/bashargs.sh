#!/usr/bin/env bash
#TODO: instead of setting the environment, assert that these are setset -euo pipefail

function bashargs::add_optional_flag() {
    local -r _argname=$1
    bashargs::_append_arg_list flag ${_argname} optional
}

function bashargs::add_optional_value() {
    local -r _argname=$1
    bashargs::_append_arg_list value ${_argname} optional
}

function bashargs::add_required_value() {
    local -r _argname=$1
    bashargs::_append_arg_list value ${_argname} required
}

function bashargs::parse_args() {
    unset ${!__BASHARGS_ARRAY__@}
    bashargs::_initialize_optional_args
    bashargs::_process_args $@
    bashargs::_check_required_args $@
}

function bashargs::get_arg() {
    local -r _argname=$1
    local -r __BASHARGS_ARRAY_ARGNAME__=$(bashargs::_get_arg_varname ${_argname})
    echo ${!__BASHARGS_ARRAY_ARGNAME__}
}


function  bashargs::_append_arg_list() {
    local -r _argtype=$1
    local -r _argname=$2
    local -r _necessity=$3
    local -r entry=( $_argtype ${_argname} ${_necessity})

    if [[ -z ${__BASHARGS_ARG_LIST__++} ]]; then
        __BASHARGS_ARG_LIST__=( ${entry[@]} )
    else
        while \read -t 1 -r _ _existing_argname _ ; do
            if [[ ${_argname} == ${_existing_argname} ]]; then
                echo "ERROR: repeated argument: ${_argname}" 1>&2
                exit 1
            fi
        done < <(echo $( bashargs::_get_arg_list) | xargs -n 3 2>/dev/null)
        __BASHARGS_ARG_LIST__=( ${__BASHARGS_ARG_LIST__[@]}  ${entry[@]} )
    fi
}

function bashargs::_check_required_args() {
    while \read -t 1 -r _argtype _argname _necessity ; do
        if [[ ${_necessity} == "required" ]]; then
            local __BASHARGS_ARRAY_ARGNAME__=$(bashargs::_get_arg_varname ${_argname})
            if [[ -z ${!__BASHARGS_ARRAY_ARGNAME__++} ]]; then
                echo "ERROR: missing required argument: ${_argname}" 1>&2
                exit 1
            fi

        fi
    done < <(echo $( bashargs::_get_arg_list) | xargs -n 3 2>/dev/null)
}

function  bashargs::_get_arg_list() {
    echo "${__BASHARGS_ARG_LIST__[@]}"
}

function bashargs::_get_arg_varname() {
    local -r _argname=$1
    echo "__BASHARGS_ARRAY__${_argname//-/_}"
}

function  bashargs::_initialize_optional_args() {
    while \read -t 1 -r _argtype _argname _necessity ; do
        if [[ -n ${_argname} ]]; then
            local __BASHARGS_ARRAY_ARGNAME__=$(bashargs::_get_arg_varname ${_argname})
            if [[ -n ${!__BASHARGS_ARRAY_ARGNAME__++} ]]; then
                echo "ERROR: repeated argument: ${_argname}" 1>&2
                exit 1
            fi
            if [[ ${_necessity} == "optional" ]]; then
                case ${_argtype} in
                    flag)
                        export ${__BASHARGS_ARRAY_ARGNAME__}=false
                        ;;
                    value)
                        export ${__BASHARGS_ARRAY_ARGNAME__}=
                        ;;
                esac
            fi
        fi
    done < <(echo $( bashargs::_get_arg_list) | xargs -n 3 2>/dev/null)
}

function  bashargs::_process_args() {
    while [[ $# -gt 0 ]]; do
        local invalid_argument=true
        while \read -t 1 -r _argtype _argname _necessity ; do
            local __BASHARGS_ARRAY_ARGNAME__=$(bashargs::_get_arg_varname ${_argname})
            case ${_argtype} in
                flag)
                    if [[ $1 == ${_argname} ]]; then
                        if [[ -n ${!__BASHARGS_ARRAY_ARGNAME__++} ]]; then
                            if [[ ${!__BASHARGS_ARRAY_ARGNAME__} == "true" ]]; then
                                echo "ERROR: repeated argument: ${_argname}" 1>&2
                                exit 1
                            fi
                        fi
                        export ${__BASHARGS_ARRAY_ARGNAME__}=true
                        invalid_argument=false
                        shift
                        break
                    fi
                    ;;
                value)
                    if [[ $1 =~ ${_argname}=* ]]; then
                        if [[ -n ${!__BASHARGS_ARRAY_ARGNAME__++} ]]; then
                            if [[ -n ${!__BASHARGS_ARRAY_ARGNAME__} ]]; then
                                echo "ERROR: repeated argument: ${_argname}" 1>&2
                                exit 1
                            fi
                        fi
                        export ${__BASHARGS_ARRAY_ARGNAME__}=${1#*=}
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
        done < <(echo $( bashargs::_get_arg_list) | xargs -n 3 2>/dev/null)
        if [[ "${invalid_argument}" == "true" ]]; then
            echo "ERROR: Unknown option $1"
            exit 1
        fi
    done
}
