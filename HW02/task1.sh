#!/usr/bin/env zsh

#SBATCH -p instruction

#SBATCH -t 0-00:30:00

#SBATCH -J task1

#SBATCH -o task1.out -e task1.err

#SBATCH -c 1

for ((i=10; i<=30; i++)); do
    n=$((2**i))
    ./task1 "$n"
done