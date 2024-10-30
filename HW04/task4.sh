#!/usr/bin/env zsh

#SBATCH -p instruction

#SBATCH -t 0-00:30:00

#SBATCH -J task4

#SBATCH -o task4.out -e task4.err

#SBATCH -c 8

for ((i=1; i<=8; i++)); do
    OMP_SCHEDULE=static ./task3 100 100 $i 
done

for ((i=1; i<=8; i++)); do
    OMP_SCHEDULE=guided ./task3 100 100 $i 
done

for ((i=1; i<=8; i++)); do
    OMP_SCHEDULE=dynamic ./task3 100 100 $i 
done
