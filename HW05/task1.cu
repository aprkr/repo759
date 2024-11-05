#include <cstdio>
#include <cuda_runtime.h>

// Kernel function to compute factorial of integers 1 to 8
__global__ void computeFactorial() {
    int index = threadIdx.x + 1; // Thread index: 1 to 8
    unsigned int fact = 1;

    // Compute factorial of index
    for (int i = 1; i <= index; i++) {
        fact *= i;
    }

    // Print result in the form: a!=b
    printf("%d!=%u\n", index, fact);
}

int main() {
    // Launch the kernel with 1 block and 8 threads
    computeFactorial<<<1, 8>>>();

    // Wait for the kernel to finish
    cudaDeviceSynchronize();

    return 0;
}
