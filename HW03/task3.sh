#!/usr/bin/env zsh

#SBATCH -p instruction

#SBATCH -t 0-00:30:00

#SBATCH -J task3

#SBATCH -o task3.out -e task3.err

#SBATCH -c 20

# part 1
for ((i=1; i<=10; i++)); do
    n=$((2**i))
    ./task3 1000000 8 "$n"
done

# # part 2
# for ((i=1; i<=20; i++)); do
#     ./task3 1000000 $i $ts
# done