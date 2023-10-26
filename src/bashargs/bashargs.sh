#! /usr/bin/env bash
#TODO: instead of setting the environment, assert that these are setset -euo pipefail

function bashargs::add_optional_flag() {
    local argname=$1
    local varname=$2
     bashargs::_append_arg_list flag $argname $varname optional
}

function bashargs::add_optional_value() {
    local argname=$1
    local varname=$2
     bashargs::_append_arg_list value $argname $varname optional
}

function bashargs::parse_args() {
     bashargs::_initialize_args
     bashargs::_process_args $@
}

function  bashargs::_append_arg_list() {
    argtype=$1
    argname=$2
    varname=$3
    necessity=$4
    local entry=( $argtype $argname $varname $necessity)

    if [[ -z ${__BASHARGS_ARG_LIST__+x} ]]; then
        __BASHARGS_ARG_LIST__=( ${entry[@]} )
    else
        __BASHARGS_ARG_LIST__=( ${__BASHARGS_ARG_LIST__[@]}  ${entry[@]} )
    fi
}

function  bashargs::_get_arg_list() {
    echo "${__BASHARGS_ARG_LIST__[@]}"
}

function  bashargs::_initialize_args() {
    while \read -t 1 -r argtype argname varname necessity ; do
        case ${argtype} in
            flag)
                declare -g "$varname"=false
                ;;
            *)
                unset $varname
                ;;

        esac
    done < <(echo $( bashargs::_get_arg_list) | xargs -n 4)
}

function  bashargs::_process_args() {
    while [[ $# -gt 0 ]]; do
        invalid_argument=true
        while \read -t 1 -r argtype argname varname necessity ; do
            case ${argtype} in
                flag)
                    if [[ "$1" == "--$argname" ]]; then
                        declare -gr ${varname}=true
                        invalid_argument=false
                        shift
                        break
                    fi
                    ;;
                value)
                    if [[ "$1" == "--${argname}=*)" ]]; then
                        declare -gr ${varname}="${1#*=}"
                        invalid_argument=false
                        shift
                        break
                    fi
                    ;;
                *)
                    fatal "ERROR: unknown arguemnt type: ${argtype}"
                    ;;
            esac
        done < <(echo $( bashargs::_get_arg_list) | xargs -n 4 2>/dev/null)
        if [[ "${invalid_argument}" == "true" ]]; then
            fatal "Unknown option $1"
        fi
    done
}
