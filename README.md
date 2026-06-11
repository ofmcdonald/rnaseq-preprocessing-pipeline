# RNA-seq Preprocessing Pipeline (Paired-end Mus musculus)

This repository contains a fully automated Snakemake workflow for preprocessing paired-end RNA-seq data from Mus musculus (mouse). The pipeline performs quality control, trimming, alignment, quantification, and QC reporting using a reproducible conda-based environment and SLURM execution.

---

## Overview

The pipeline performs the following steps:

1. **Input validation and sample detection**
2. **Raw FASTQ QC (FastQC)**
3. **Adapter trimming and quality filtering (fastp)**
4. **Post-trimming QC (FastQC)**
5. **Genome alignment (STAR)**
6. **Gene-level quantification (STAR GeneCounts)**
7. **BAM indexing (samtools)**
8. **Strandedness QC (RSeQC infer_experiment)**
9. **Read distribution QC (RSeQC read_distribution)**
10. **MultiQC aggregation (raw + trimmed)**

---

## Requirements

### 1. Conda environment system

This pipeline is designed to work with Miniforge3, but any Conda-compatible installation (Miniconda or Anaconda) is acceptable.

Conda must be available in your environment:

```bash
conda --version
which conda
```

It is recommended to add Conda to your shell startup file:

```bash
export PATH="$HOME/miniforge3/bin:$PATH"

---

### 2. Snakemake environment

A dedicated environment is required:

```bash
conda create -n snakemake-pipeline \
    snakemake \
    snakemake-executor-plugin-slurm
```

Activate before running:

```bash
conda activate snakemake-pipeline
```

---

### 3. SLURM HPC configuration

This pipeline assumes execution on a SLURM-managed HPC cluster.

Execution is controlled via the wrapper script:

scripts/run_snakemake.sh

You must configure:
* SNAKEMAKE_BIN: path to Snakemake executable (cluster-dependent)
* SLURM resources via Snakemake executor plugin settings (see profiles/slurm/)
* Working directory path (WORKDIR must point to repository root)

Example:

```bash
SNAKEMAKE_BIN="$HOME/miniforge3/envs/snakemake-pipeline/bin/snakemake"
```

or simply:

```bash
SNAKEMAKE_BIN="snakemake"
```

depending on your cluster setup.

---

### 4. Working directory

You MUST set the correct working directory in `run_snakemake.sh`:

```bash
WORKDIR="/path/to/rnaseq-preprocessing-pipeline"
cd "$WORKDIR"
```

Snakemake must always be executed from the repository root.

---

## Input data requirements

### 1. Raw FASTQ files

The pipeline expects paired-end FASTQ files in:

```
data_norm/
    SAMPLE1_R1.fastq.gz
    SAMPLE1_R2.fastq.gz
```

Naming must follow this convention exactly.

---

### 2. Sample sheet

A sample sheet is required:

```
samples.tsv
```

Format:

| sample  |
| ------- |
| SAMPLE1 |
| SAMPLE2 |

This file is generated using:

```bash
bash scripts/build_data_norm.sh
bash scripts/generate_samples_tsv.sh
```

and must be created before running Snakemake.

---

## Preprocessing steps (required before Snakemake)

Run in order:

```bash
bash scripts/build_data_norm.sh
bash scripts/generate_samples_tsv.sh
```

These scripts:
* Normalize FASTQ naming conventions
* Generate `data_norm/`
* Build `samples.tsv`

---

## Running the pipeline

Use the provided wrapper script:

```bash
bash run_snakemake.sh
```

This script handles:
* SLURM submission via `snakemake-executor-plugin-slurm`
* Conda environment activation
* Resource configuration
* Logging and job orchestration

---

## Dry run

To test the pipeline without execution:

```bash
bash run_snakemake.sh -n
```

---

## Output structure

```
results/
    fastqc_raw/
    fastp/
    fastqc_fastp/
    star/
    samtools/
    rseqc/
    multiqc/
```

Key outputs:

* Trimmed FASTQs: `results/fastp/`
* Alignments: `results/star/bam/`
* Gene counts: `results/star/counts/`
* QC reports: `results/multiqc/`

---

## STAR reference index

The STAR genome index is generated automatically:

```
reference/star_index/
```

This directory is large and computationally expensive to generate. It should not be deleted unless intentionally rebuilding the index.

---

## Important design assumptions

* Paired-end RNA-seq only
* Mouse reference genome (*Mus musculus*)
* FASTQ files must be gzipped
* Sample naming must match `samples.tsv`
* Workflow assumes SLURM scheduler

---

## Troubleshooting

### Missing FASTQ errors

Ensure:

```bash
data_norm/SAMPLE_R1.fastq.gz
data_norm/SAMPLE_R2.fastq.gz
```

exist for all samples in `samples.tsv`.

---

### Snakemake executor issues

Verify SLURM plugin installation:

```bash
conda list snakemake-executor-plugin-slurm
```

---

### Environment issues

Ensure Miniforge is active:

```bash
which conda
conda info
```

---

## Reproducibility notes

This pipeline is designed to be:
* Fully reproducible
* Environment-isolated via conda
* Cluster-scalable via SLURM
* Deterministic given identical inputs

---

## Author / maintenance

Olivia McDonald, PhD || okfavor@outlook.com

---

## License

This software is released under the MIT License to facilitate reuse in academic and non-academic settings.
