#!/usr/bin/env zsh

#SBATCH -p instruction

#SBATCH -t 0-00:05:00

#SBATCH -J task2

#SBATCH -o task2.out -e task2.err

#SBATCH -c 1

#SBATCH -n 1 

#SBATCH --gpus-per-task=1

module load nvidia/cuda

module load gcc/13

nvcc task2.cu stencil.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std=c++17 -o task2 -gencode arch=compute_50,code=sm_50 -gencode arch=compute_60,code=sm_60

for ((i=10; i<=29; i++)); do
    n=$((2**i))
    ./task2 "$n" 128 1024
done

for ((i=10; i<=29; i++)); do
    n=$((2**i))
    ./task2 "$n" 128 16
done