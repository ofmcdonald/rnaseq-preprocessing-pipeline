# Input FASTQ Files

Place raw paired-end FASTQ files in this directory.

Example:

Sample1_R1.fastq.gz
Sample1_R2.fastq.gz
Sample2_R1.fastq.gz
Sample2_R2.fastq.gz

After adding FASTQ files, run:

bash scripts/build_data_norm.sh
bash scripts/generate_samples_tsv.sh

before launching the Snakemake workflow.
