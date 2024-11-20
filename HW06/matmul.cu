#include "matmul.cuh"
#include <cuda_runtime.h>
#include <iostream>

__global__ void matmul_kernel(const float* A, const float* B, float* C, size_t n) {
    size_t row = blockIdx.x * blockDim.x + threadIdx.x;
    size_t col = blockIdx.y * blockDim.y + threadIdx.y;

    if (row < n && col < n) {
        float sum = 0.0f;
        for (size_t k = 0; k < n; ++k) {
            sum += A[row * n + k] * B[k * n + col];
        }
        C[row * n + col] = sum;
    }
}

void matmul(const float* A, const float* B, float* C, size_t n, unsigned int threads_per_block) {
    int blocks = (n + threads_per_block - 1) / threads_per_block;

    float *d_A, *d_B, *d_C;
    size_t num_bytes = n * n * sizeof(float);
    cudaMalloc(&d_A, num_bytes);
    cudaMalloc(&d_B, num_bytes);
    cudaMalloc(&d_C, num_bytes);

    cudaMemcpy(d_A, A, num_bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B, num_bytes, cudaMemcpyHostToDevice);

    matmul_kernel<<<blocks, threads_per_block>>>(d_A, d_B, d_C, n);
    
    cudaDeviceSynchronize();
    cudaMemcpy(C, d_C, num_bytes, cudaMemcpyDeviceToHost);

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
}
