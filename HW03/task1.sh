#!/usr/bin/env zsh

#SBATCH -p instruction

#SBATCH -t 0-00:30:00

#SBATCH -J task1

#SBATCH -o task1.out -e task1.err

#SBATCH -c 20

for ((i=1; i<=20; i++)); do
    ./task1 1024 i
done