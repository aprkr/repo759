#include <cuda_runtime.h>
#include <iostream>
#include <chrono>

template <typename T>
__host__ void matmul_common(const T *A, const T *B, T *C, unsigned int n, unsigned int block_dim) {
    T *d_A, *d_B, *d_C;
    size_t size = n * n * sizeof(T);

    // Allocate device memory
    cudaMalloc((void**)&d_A, size);
    cudaMalloc((void**)&d_B, size);
    cudaMalloc((void**)&d_C, size);

    // Copy data to device
    cudaMemcpy(d_A, A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B, size, cudaMemcpyHostToDevice);

    // Set up grid and block dimensions
    dim3 dimBlock(block_dim, block_dim);
    dim3 dimGrid((n + block_dim - 1) / block_dim, (n + block_dim - 1) / block_dim);

    // Start timer
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start);

    // Launch the kernel
    matmul_kernel<T><<<dimGrid, dimBlock>>>(d_A, d_B, d_C, n, block_dim);

    // Stop timer
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);
    std::cout << "Time taken: " << milliseconds << " ms" << std::endl;

    // Copy result back to host
    cudaMemcpy(C, d_C, size, cudaMemcpyDeviceToHost);

    // Clean up
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    cudaEventDestroy(start);
    cudaEventDestroy(stop);
}

__host__ void matmul_1(const int *A, const int *B, int *C, unsigned int n, unsigned int block_dim) {
    matmul_common(A, B, C, n, block_dim);
}

__host__ void matmul_2(const float *A, const float *B, float *C, unsigned int n, unsigned int block_dim) {
    matmul_common(A, B, C, n, block_dim);
}

__host__ void matmul_3(const double *A, const double *B, double *C, unsigned int n, unsigned int block_dim) {
    matmul_common(A, B, C, n, block_dim);
}

__global__ void matmul_kernel(const int *A, const int *B, int *C, unsigned int n, unsigned int block_dim) {
    // Tile size
    __shared__ int As[block_dim][block_dim];
    __shared__ int Bs[block_dim][block_dim];

    // Global thread indices
    unsigned int row = blockIdx.y * block_dim + threadIdx.y;
    unsigned int col = blockIdx.x * block_dim + threadIdx.x;
    
    int value = 0;

    // Loop over sub-matrices to compute the product
    for (unsigned int m = 0; m < (n + block_dim - 1) / block_dim; m++) {
        // Load the data into shared memory
        if (row < n && (m * block_dim + threadIdx.x) < n)
            As[threadIdx.y][threadIdx.x] = A[row * n + m * block_dim + threadIdx.x];
        else
            As[threadIdx.y][threadIdx.x] = 0;

        if (col < n && (m * block_dim + threadIdx.y) < n)
            Bs[threadIdx.y][threadIdx.x] = B[(m * block_dim + threadIdx.y) * n + col];
        else
            Bs[threadIdx.y][threadIdx.x] = 0;

        __syncthreads();

        // Perform partial multiplication
        for (unsigned int k = 0; k < block_dim; k++) {
            value += As[threadIdx.y][k] * Bs[k][threadIdx.x];
        }

        __syncthreads();
    }

    // Store the result in C
    if (row < n && col < n)
        C[row * n + col] = value;
}
