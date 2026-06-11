#!/usr/bin/env bash
set -euo pipefail

OUTPUT="samples.tsv"
DATA_DIR="data_norm"

echo -e "sample" > "$OUTPUT"

declare -A R1
declare -A R2

for f in "$DATA_DIR"/*.fastq.gz; do
    [[ -e "$f" ]] || continue

    base=$(basename "$f")
    sample="${base%%_R[12]*}"

    if [[ "$base" == *_R1.fastq.gz ]]; then
        R1["$sample"]=1
    elif [[ "$base" == *_R2.fastq.gz ]]; then
        R2["$sample"]=1
    fi
done

echo "Found ${#R1[@]} R1 samples"
echo "Found ${#R2[@]} R2 samples"

for sample in "${!R1[@]}"; do
    if [[ -z "${R2[$sample]+x}" ]]; then
        echo "ERROR: missing R2 for $sample"
        exit 1
    fi

    echo "$sample" >> "$OUTPUT"
done

echo "Generated $OUTPUT"
column -t "$OUTPUT"
