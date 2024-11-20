// Generated with ChatGPT
#include <iostream>
#include <cstdlib>
#include <ctime>
#include <random>
#include <cuda_runtime.h>
#include "matmul.cuh"

void fill_random(float* mat, size_t n) {
    int some_seed = 759;
    std::mt19937 generator(some_seed);

    std::uniform_real_distribution<float> adist(-1., 1.);

    for (size_t i = 0; i < n * n; ++i) {
        mat[i] = adist(generator);
    }
}

int main(int argc, char** argv) {
    size_t n = std::stoul(argv[1]);
    unsigned int threads_per_block = std::stoul(argv[2]);

    float* A = new float[n * n];
    float* B = new float[n * n];
    float* C = new float[n * n];

    fill_random(A, n);
    fill_random(B, n);

    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    cudaEventRecord(start);

    matmul(A, B, C, n, threads_per_block);

    cudaEventRecord(stop);

    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);

    std::cout << C[n * n - 1] << std::endl;

    std::cout << milliseconds << std::endl;
}
