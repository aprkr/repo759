#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <random>

// CUDA kernel that calculates ax + y
__global__ void computeValues(int *dA, int a) {
    int index = threadIdx.x + blockIdx.x * blockDim.x;  // Unique thread index
    if (index < 16) {
        int x = threadIdx.x;
        int y = blockIdx.x;
        dA[index] = a * x + y;
    }
}

int main() {
    int some_seed = 759;
    std::mt19937 generator(some_seed);
    int a = generator() % 10;
    
    printf("Random integer a = %d\n", a);

    int hA[16];
    
    int *dA;
    cudaMalloc((void**)&dA, 16 * sizeof(int));

    computeValues<<<2, 8>>>(dA, a);

    cudaMemcpy(hA, dA, 16 * sizeof(int), cudaMemcpyDeviceToHost);

    cudaDeviceSynchronize();

    printf("Values in hA: ");
    for (int i = 0; i < 16; ++i) {
        printf("%d ", hA[i]);
    }
    printf("\n");

    cudaFree(dA);

    return 0;
}
