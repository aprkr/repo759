#!/usr/bin/env zsh

#SBATCH -p instruction

#SBATCH -t 0-00:05:00

#SBATCH -J task3

#SBATCH -o task3.out -e task3.err

#SBATCH -c 1

#SBATCH -n 1 

#SBATCH --gpus-per-task=1

module load nvidia/cuda

module load gcc/13

nvcc task3.cu vscale.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std=c++17 -o task3 -gencode arch=compute_50,code=sm_50 -gencode arch=compute_60,code=sm_60

for ((i=10; i<=29; i++)); do
    n=$((2**i))
    ./task3 "$n" 512
done

for ((i=10; i<=29; i++)); do
    n=$((2**i))
    ./task3 "$n" 16
done