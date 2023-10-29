#! /usr/bin/env bash
#TODO: instead of setting the environment, assert that these are setset -euo pipefail

function bashargs::add_optional_flag() {
    local -r _argname=$1
    bashargs::_append_arg_list flag ${_argname} optional
}

function bashargs::add_optional_value() {
    local -r _argname=$1
    bashargs::_append_arg_list value ${_argname} optional
}

function bashargs::parse_args() {
    bashargs::_initialize_args
    bashargs::_process_args $@
}

function bashargs::get_arg() {
    local -r _argname=$1
    echo ${__BASHARGS_ARRAY__["${_argname}"]}
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
        done < <(echo $( bashargs::_get_arg_list) | xargs -n 3)
        __BASHARGS_ARG_LIST__=( ${__BASHARGS_ARG_LIST__[@]}  ${entry[@]} )
    fi
}

function  bashargs::_get_arg_list() {
    echo "${__BASHARGS_ARG_LIST__[@]}"
}

function  bashargs::_initialize_args() {
    declare -Ag __BASHARGS_ARRAY__
    while \read -t 1 -r _argtype _argname _necessity ; do
        if [[ -n ${__BASHARGS_ARRAY__["${_argname}"]++} ]]; then
            echo "ERROR: repeated argument: ${_argname}" 1>&2
            exit 1
        fi
        case ${_argtype} in
            flag)
                __BASHARGS_ARRAY__["${_argname}"]="false"
                ;;
            value)
                __BASHARGS_ARRAY__["${_argname}"]=""
                ;;
        esac

    done < <(echo $( bashargs::_get_arg_list) | xargs -n 3)
}

function  bashargs::_process_args() {
    while [[ $# -gt 0 ]]; do
        local invalid_argument=true
        while \read -t 1 -r _argtype _argname _necessity ; do
            case ${_argtype} in
                flag)
                    if [[ $1 == ${_argname} ]]; then
                        if [[ ${__BASHARGS_ARRAY__["${_argname}"]} == "true" ]]; then
                            echo "ERROR: repeated argument: ${_argname}" 1>&2
                            exit 1
                        fi
                        __BASHARGS_ARRAY__["${_argname}"]=true
                        invalid_argument=false
                        shift
                        break
                    fi
                    ;;
                value)
                    if [[ $1 =~ ${_argname}=* ]]; then
                        if [[ -n ${__BASHARGS_ARRAY__["${_argname}"]} ]]; then
                            echo "ERROR: repeated argument: ${_argname}" 1>&2
                            exit 1
                        fi
                        __BASHARGS_ARRAY__["${_argname}"]="${1#*=}"
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
