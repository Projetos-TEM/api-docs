#!/usr/bin/env bash

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
    aglio --theme-full-width --theme-variables flatly   \
        -i "${src}" -o "${dst}"
done
