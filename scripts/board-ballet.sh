#!/bin/bash

# Bash library for controlling the BoardBallet build and environment

############################################
# Variables
############################################

export REPO_ROOT="$(git rev-parse --show-superproject-working-tree --show-toplevel | head -1)"

export BUILD_DIR="${REPO_ROOT}/build"
export INSTALL_DIR="${REPO_ROOT}/install"

############################################
# Help
############################################

boba-help() {
    cat <<'_EOF_'
--------------------------------------------------------------------
board-ballet-lib: a collection of bash functions to ease development
--------------------------------------------------------------------

    Building and Installing:
        boba-configure: ------------ Configure C++ projects
        boba-build: ---------------- Build C++ projects
        boba-install: -------------- Install C++ projects
        boba-cbi: ------------------ Configure, build & install C++ projects
        boba-clean: ---------------- Cleanup C++ build and install directories

Happy developing!
_EOF_

    return 0
}

############################################
# Building and Installing
############################################

boba-configure() {
    local HELP="""\
Run cmake configuration stage for C++ projects

Syntax: boba-configure [-h] [cmake-parameters]
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

boba-build() {
    local HELP="""\
Build C++ projects (requires boba-configure)

Syntax: boba-build [-h] [cmake-parameters]
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

boba-install() {
    local HELP="""\
Install C++ projects (requires boba-build)

Syntax: boba-install [-h] [cmake-parameters]
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

boba-cbi() {
    local HELP="""\
Run cmake configure, build and install stages for C++ projects
Must be run from the repo root

Syntax: boba-cbi [-h] [cmake-parameters]
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

    boba-configure "${@}"
    boba-build
    boba-install
}

boba-clean() {
    local HELP="""\
Clean build and install directories

Syntax: boba-clean [-h]
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
