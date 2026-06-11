#!/usr/bin/env bash
set -euo pipefail

SNAKEMAKE_BIN="/mnt/home/favoroli/.conda/envs/snakemake/bin/snakemake"

cd /mnt/gs21/scratch/favoroli/rnaseq-preprocessing-legacy-test

"${SNAKEMAKE_BIN}" \
  --profile profiles/slurm \
  --executor slurm \
  -j 100 \
  "$@"
