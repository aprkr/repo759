#!/usr/bin/env bash

#SBATCH --job-name=task2

#SBATCH -p instruction

#SBATCH --ntasks=1 --cpus-per-task=2

#SBATCH --time=0-00:30:00

#SBATCH --output="./task2.out"

#SBATCH --error="./task2.err"

#SBATCH --gres=gpu:1

set -e

# Load necessary modules
module load nvidia/cuda/11.8.0
module load gcc/9.4.0

# Compile the program
nvcc task2.cu reduce.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std=c++17 -o task2

# Run the program for n = 2^10 to 2^30 with threads_per_block=256
for ((i=10; i<=29; i++)); do
    n=$((2**i))
    ./task2 $n 256
done

# Run the program for n = 2^10 to 2^30 with threads_per_block=1024
for ((i=10; i<=29; i++)); do
    n=$((2**i))
    ./task2 $n 1024
done

# Clean up
rm task2