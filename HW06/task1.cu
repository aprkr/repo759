// Generated with ChatGPT
#include <iostream>
#include <cstdlib>
#include <ctime>
#include <cuda_runtime.h>
#include "matmul.cuh"

void fill_random(float* mat, size_t n) {
    for (size_t i = 0; i < n * n; ++i) {
        mat[i] = static_cast<float>(rand()) / RAND_MAX * 2.0f - 1.0f;
    }
}

int main(int argc, char** argv) {
    size_t n = std::stoul(argv[1]);
    unsigned int threads_per_block = std::stoul(argv[2]);

    float* A = new float[n * n];
    float* B = new float[n * n];
    float* C = new float[n * n];

    srand(static_cast<unsigned int>(time(0)));
    fill_random(A, n);
    fill_random(B, n);

    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    cudaEventRecord(start);

    matmul(A, B, C, n, threads_per_block);

    cudaEventRecord(stop);

    cudaEventSynchronize(stop);
    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);

    std::cout << C[n * n - 1] << std::endl;

    std::cout << milliseconds << std::endl;

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    delete[] A;
    delete[] B;
    delete[] C;
}
