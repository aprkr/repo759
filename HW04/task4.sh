#!/usr/bin/env zsh

#SBATCH -p instruction

#SBATCH -t 0-00:30:00

#SBATCH -J task4

#SBATCH -o task4.out -e task4.err

#SBATCH -c 8

OMP_SCHEDULE=static
for ((i=1; i<=8; i++)); do
    ./task3 100 100 $i 
done

OMP_SCHEDULE=guided
for ((i=1; i<=8; i++)); do
    ./task3 100 100 $i 
done

OMP_SCHEDULE=dynamic
for ((i=1; i<=8; i++)); do
    ./task3 100 100 $i 
done