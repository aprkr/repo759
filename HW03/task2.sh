#!/usr/bin/env zsh

#SBATCH -p instruction

#SBATCH -t 0-00:30:00

#SBATCH -J task2

#SBATCH -o task2.out -e task2.err

#SBATCH -c 20

for ((i=1; i<=20; i++)); do
    ./task2 1024 $i
done