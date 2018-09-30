#!/usr/bin/env bash

while getopts 3t: param; do
    case $param in
        t) themeColor=$OPTARG ;;
        3) themeTemplate=triple ;;
        ?)
            echo "$0: opção desconhecida '-$param'"
            exit 255
            ;;
    esac
done
shift $(( OPTIND - 1 ))

args=("$@")

# Verifica se arquivos existem
for ((i=0; i < $#; i++)); do
    [ -f "${args[$i]}" ] || {
        echo "Arquivo não existe: '${args[$i]}'"
        exit 1
    }
done

function basedirname() {
    dirname "$1" | xargs basename
}

function relativepath() {
    realpath --relative-to=. "$1"
}

# Cria a documentação
for ((i=0; i < $#; i++)); do
    src="$(realpath "${args[$i]}")"
    dst="${src%.*}.html"
    
    if [[ "$(basedirname "$src")" == '_sources' ]]; then
        dst="$(dirname "$src")/../$(basename "$dst")"
    fi

    echo "'$(relativepath "$src")' -> '$(relativepath "$dst")'"
    aglio --theme-full-width --theme-variables ${themeColor:-default}   \
        --theme-template ${themeTemplate:-default}  \
        -i "${src}" -o "${dst}" ||
    {
        echo "Erro inesperado"
        exit 2
    }
done
