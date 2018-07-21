#!/usr/bin/env bash

while getopts t: param; do
    case $param in
        t) themeColor=$OPTARG ;;
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

# Cria a documentação
for ((i=0; i < $#; i++)); do
    src="${args[$i]}"
    dst="${src%.*}.html"

    echo "'$src' -> '$dst'"
    aglio --theme-full-width --theme-variables ${themeColor:-default}   \
        -i "${src}" -o "${dst}" ||
    {
        echo "Erro inesperado"
        exit 2
    }
done
