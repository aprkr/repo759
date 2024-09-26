#!/usr/bin/env zsh

#SBATCH -p instruction

#SBATCH -t 0-00:30:00

#SBATCH -J task3

#SBATCH -o task3.out -e task3.err

#SBATCH -c 1

./task3