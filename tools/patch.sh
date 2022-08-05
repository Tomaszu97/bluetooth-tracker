#!/bin/bash -axe

INPUT_F="in.bin"
OUTPUT_F="out.bin"
DATA="$1"

patch_at()
{
    #$1 offset (hex)
    #$2 data hex string
    data_len="$(printf "$2" | wc -c)"
    printf "$2" | xxd -r -p | dd of="$OUTPUT_F" bs=1 conv=notrunc seek="$((16#$1))"
}

cp "$INPUT_F" "$OUTPUT_F"
chmod +w "$OUTPUT_F"

patch_at 0003e1f0 "deadbeef"
patch_at 0003d1f0 "deadbeef"
patch_at 00022898 "$DATA"
patch_at 00034898 "$DATA"

