function zlib-decompress --description "decompress thing" --argument-names "file"
    if not set -q file; or test "$file" = ""
        return 1
    end
    printf "\x1f\x8b\x08\x00\x00\x00\x00\x00" | cat - "$file" | gzip -dc
end
