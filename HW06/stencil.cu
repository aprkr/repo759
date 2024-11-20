
#include "stencil.cuh"
#include <cuda_runtime.h>
#include <iostream>

// Kernel function for performing the stencil operation
__global__ void stencil_kernel(const float* image, const float* mask, float* output, unsigned int n, unsigned int R) {
    // Shared memory to store the mask and the image window for the block
    extern __shared__ float shared_mem[];

    // Mask is stored in the first part of shared memory
    float* shared_mask = shared_mem;
    // Image window for the current block is stored after the mask
    float* shared_image = shared_mem + (2 * R + 1);

    // Thread index within the block
    unsigned int thread_idx = threadIdx.x;

    // Load the mask into shared memory
    if (thread_idx < (2 * R + 1)) {
        shared_mask[thread_idx] = mask[thread_idx];
    }

    // Load the image elements needed for convolution into shared memory
    unsigned int global_idx = blockIdx.x * blockDim.x + thread_idx - R;
    if (global_idx >= 0 && global_idx < n) {
        shared_image[thread_idx] = image[global_idx];
    } else {
        shared_image[thread_idx] = 1.0f; // Outside the image boundary, set image value to 1
    }

    __syncthreads();  // Synchronize threads to ensure shared memory is loaded

    // Each thread computes one element of the output array
    if (global_idx >= 0 && global_idx < n) {
        float result = 0.0f;
        for (int j = -R; j <= R; ++j) {
            result += shared_image[thread_idx + j] * shared_mask[j + R];
        }
        output[global_idx] = result;
    }
}

// Host function that launches the stencil kernel
void stencil(const float* image, const float* mask, float* output, unsigned int n, unsigned int R, unsigned int threads_per_block) {
    // Allocate device memory for image, mask, and output arrays
    float *d_image, *d_mask, *d_output;
    cudaMalloc(&d_image, n * sizeof(float));
    cudaMalloc(&d_mask, (2 * R + 1) * sizeof(float));
    cudaMalloc(&d_output, n * sizeof(float));

    // Copy data from host to device
    cudaMemcpy(d_image, image, n * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_mask, mask, (2 * R + 1) * sizeof(float), cudaMemcpyHostToDevice);

    // Calculate grid size: the number of blocks needed
    unsigned int blocks = (n + threads_per_block - 1) / threads_per_block;

    // Launch the stencil kernel
    size_t shared_mem_size = (2 * R + 1 + threads_per_block) * sizeof(float);  // Shared memory size for both image window and mask
    stencil_kernel<<<blocks, threads_per_block, shared_mem_size>>>(d_image, d_mask, d_output, n, R);

    // Check for any CUDA errors
    cudaError_t err = cudaGetLastError();
    if (err != cudaSuccess) {
        std::cerr << "CUDA kernel failed: " << cudaGetErrorString(err) << std::endl;
    }

    // Copy result from device to host
    cudaMemcpy(output, d_output, n * sizeof(float), cudaMemcpyDeviceToHost);

    // Free device memory
    cudaFree(d_image);
    cudaFree(d_mask);
    cudaFree(d_output);
}

