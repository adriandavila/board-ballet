#!/bin/bash

# Bash library for controlling the BoardBallet build and environment

############################################
# Variables
############################################

export REPO_ROOT="$(cd ${SCRIPT_DIR} && git rev-parse --show-superproject-working-tree --show-toplevel | head -1)"

export BUILD_DIR="${ORTOA_SHARED}/build"
export INSTALL_DIR="${ORTOA_SHARED}/install"

############################################
# Help
############################################

ortoa-help() {
    cat <<'_EOF_'
--------------------------------------------------------------------
board-ballet-lib: a collection of bash functions to ease development
--------------------------------------------------------------------

    Building and Installing:
        bob-configure: ------------ Configure C++ projects
        bob-build: ---------------- Build C++ projects
        bob-install: -------------- Install C++ projects
        bob-cbi: ------------------ Configure, build & install C++ projects
        bob-clean: ---------------- Cleanup C++ build and install directories

Happy developing!
_EOF_

    [[ ${#} -eq 0 ]]
}

############################################
# Building and Installing
############################################

bob-configure() {
    local HELP="""\
Run cmake configuration stage for C++ projects

Syntax: bob-configure [-h] [cmake-parameters]
-----------------------------------------------
    h                   Prints this help message
    cmake-parameters    Parameters passed to CMake configure invocation
"""
    OPTIND=1
    while getopts ":h" option; do
        case "${option}" in
            h) echo "${HELP}"; return 0 ;;
            *) break
        esac
    done

    cd "${REPO_ROOT}"

    shift $((OPTIND - 1))

    mkdir -p "${BUILD_DIR}"
    cmake -S "${REPO_ROOT}" \
          -B "${BUILD_DIR}" \
          -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}" \
          "${@}"
}

bob-build() {
    local HELP="""\
Build C++ projects (requires bob-configure)

Syntax: bob-build [-h] [cmake-parameters]
-------------------------------------------
    h                   Prints this help message
    cmake-parameters    Parameters passed to CMake invocation
"""
    OPTIND=1
    while getopts ":h" option; do
        case "${option}" in
            h) echo "${HELP}"; return 0 ;;
        esac
    done

    cd "${REPO_ROOT}"

    cmake --build "${BUILD_DIR}" "${@}"
}

bob-install() {
    local HELP="""\
Install C++ projects (requires bob-build)

Syntax: bob-install [-h] [cmake-parameters]
---------------------------------------------
    h                   Prints this help message
    cmake-parameters    Parameters passed to CMake invocation
"""
    OPTIND=1
    while getopts ":h" option; do
        case "${option}" in
            h) echo "${HELP}"; return 0 ;;
        esac
    done

    cd "${REPO_ROOT}"

    cmake --install "${BUILD_DIR}" --prefix "${INSTALL_DIR}" "${@}"
}

bob-cbi() {
    local HELP="""\
Run cmake configure, build and install stages for C++ projects
Must be run from the repo root

Syntax: bob-cbi [-h] [cmake-parameters]
-----------------------------------------
    h                   Prints this help message
    cmake-parameters    Parameters passed to CMake configure invocation
""" 
    OPTIND=1
    while getopts ":h" option; do
        case "${option}" in
            h) echo "${HELP}"; return 0 ;;
        esac
    done

    cd "${REPO_ROOT}"

    bob-configure "${@}"
    bob-build
    bob-install
}

bob-clean() {
    local HELP="""\
Clean build and install directories

Syntax: bob-clean [-h]
------------------------
    h                   Prints this help message
"""
    OPTIND=1
    while getopts ":h" option; do
        case "${option}" in
            h) echo "${HELP}"; return 0 ;;
            *) break ;;
        esac
    done

    cd "${REPO_ROOT}"

    rm -rf \
        "${BUILD_DIR}/"* \
        "${INSTALL_DIR}/"*
}
