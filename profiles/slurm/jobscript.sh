#!/usr/bin/env bash
#SBATCH --export=ALL

set -euo pipefail

# ------------------------------------------------------------
# Ensure conda is available
# ------------------------------------------------------------

if ! command -v conda &> /dev/null; then
    echo "ERROR: conda not found in PATH."
    echo "Load Miniforge/Anaconda or ensure conda is initialized before running Snakemake."
    exit 1
fi

# Initialize conda shell functions using installed base
source "$(conda info --base)/etc/profile.d/conda.sh"

# Execute command passed by Snakemake executor
exec "$@"
