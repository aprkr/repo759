#!/usr/bin/env bash

#SBATCH --job-name=task1

#SBATCH -p instruction

#SBATCH --ntasks=1 --cpus-per-task=2

#SBATCH --time=0-00:30:00

#SBATCH --output="./task1.out"

#SBATCH --error="./task1.err"

#SBATCH --gres=gpu:1

set -e

# Load necessary modules
module load nvidia/cuda/11.8.0

module load gcc/9.4.0

# Compile the program
nvcc task1.cu matmul.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std=c++17 -o task1

# Run the program for n = 2^5 to 2^14
for ((i=5; i<=14; i++)); do
    n=$((2**i))
    ./task1 $n 16 >> task1_b.out
done

# Clean up
rm task1