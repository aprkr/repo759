#!/usr/bin/env zsh

#SBATCH -p instruction

#SBATCH -t 0-00:05:00

#SBATCH -J task1

#SBATCH -o task1.out -e task1.err

#SBATCH -c 1

#SBATCH -n 1 

#SBATCH --gpus-per-task=1

module load nvidia/cuda

module load gcc/13

nvcc task1.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std=c++17 -o task1 -gencode arch=compute_50,code=sm_50 -gencode arch=compute_60,code=sm_60
./task1