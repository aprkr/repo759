
#include "stencil.cuh"
#include <cuda_runtime.h>
#include <iostream>

// Kernel function for performing the stencil operation
__global__ void stencil_kernel(const float* image, const float* mask, float* output, unsigned int n, unsigned int R) {
    // Shared memory: first part will store the mask, second part will store the image window
    extern __shared__ float shared_mem[];

    // Shared memory pointers
    float* shared_mask = shared_mem;          // Shared memory for the mask
    float* shared_image = shared_mem + (2 * R + 1); // Shared memory for the image window

    // Thread index within the block
    unsigned int thread_idx = threadIdx.x;

    // Load the mask into shared memory (all threads load the full mask)
    if (thread_idx < (2 * R + 1)) {
        shared_mask[thread_idx] = mask[thread_idx];
    }

    // Global index of the element to be processed
    unsigned int global_idx = blockIdx.x * blockDim.x + thread_idx - R;

    // Load image elements into shared memory
    if (global_idx >= 0 && global_idx < n) {
        shared_image[thread_idx] = image[global_idx];
    } else {
        shared_image[thread_idx] = 1.0f; // Boundary handling (image[i] = 1 for out-of-bounds)
    }

    __syncthreads(); // Synchronize to make sure image and mask are loaded before computation

    // Compute the output value if the global index is within bounds
    if (global_idx >= 0 && global_idx < n) {
        float result  0.0f;
        // Perform convolution: sum(mask[j] * image[i+j]) for j = -R to R
        for (int j = -R; j <= R; ++j) {
            int image_idx = thread_idx + j;
            result += shared_image[image_idx] * shared_mask[j + R];
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

