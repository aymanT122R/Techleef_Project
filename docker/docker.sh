#!/bin/bash

if [ $# -ne 1 ];then 
    echo "usage: $0 checkout|shell|build"
    exit 1
fi 


VENV_DIR="yocto-venv"

do_prepare_env() {
    if [ -d "$VENV_DIR" ]; then
        #make sure that it is actually a python venv
        # else fail with error message
        exit 1
    else
        python3 -m venv "$VENV_DIR" 
    fi 

    #source the venv
    source "$VENV_DIR/bin/activate" || {
        echo "[x] Failed to source virtual environment"
        exit 1
    }

    #install "kas"

    if ! pip3 install kas; then
        echo "[x] Failed to install kas"
        exit 1
    fi



}

KAS_DIR=$()


do_kas_checkout() {
    kas-container checkout ${KAS_FILE} || {
        echo "[x] kas checkout failed"
        exit 1
    }
}


main() {
    do_prepare_env

    local action = "$1"
    local yml ="$2"

    if [ "action" == "checkout" ]; then
        do_kas_checkout "$yml"
    elif [ "action" == "shell" ]; then
        do_kas_shell "$yml"
    elif [ "action" == "build" ]; then
        do_kass_build "$yml
    else
        echo "[x] Unknown action"
        exit 1
    fi

    do_kas_checkout
    do_kas_shell
    do_kass_build
}


main "$@"