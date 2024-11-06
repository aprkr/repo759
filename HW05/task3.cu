#include <cstdio>
#include <cstdlib>
#include <random>
#include "vscale.cuh"
#include <chrono>

using std::chrono::high_resolution_clock;
using std::chrono::duration;

int main(int argc, char *argv[]) {

    int N = std::stoi(argv[1]);

    int some_seed = 759;
    std::mt19937 generator(some_seed);

    std::uniform_real_distribution<float> adist(-10., 10.);
    std::uniform_real_distribution<float> bdist(0., 1.);

    float hA[N], hB[N];
    
    for (int i = 0; i < N; i++) {
        hA[i] = adist(generator);
        hB[i] = bdist(generator);
    }
    
    
    
    float *dA, *dB;
    cudaMalloc((void**)&dA, N * sizeof(float));
    cudaMalloc((void**)&dB, N * sizeof(float));

    cudaMemcpy(dA, hA, N * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(dB, hB, N * sizeof(float), cudaMemcpyHostToDevice);

    int threadsPerBlock = std::stoi(argv[2]);;
    if (N < threadsPerBlock) {
        threadsPerBlock = N;
    }
    int blocks = (N + threadsPerBlock - 1) / threadsPerBlock;

    high_resolution_clock::time_point start;
    high_resolution_clock::time_point end;
    duration<double, std::milli> duration_sec;

    start = high_resolution_clock::now();
    vscale<<<blocks, threadsPerBlock>>>(dA, dB, N);

    cudaMemcpy(hA, dA, N * sizeof(float), cudaMemcpyDeviceToHost);
    cudaMemcpy(hB, dB, N * sizeof(float), cudaMemcpyDeviceToHost);

    cudaDeviceSynchronize();
    end = high_resolution_clock::now();

    duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);

    printf("%f\n",duration_sec.count());
    printf("%f\n",hB[0]);
    printf("%f\n",hB[N - 1]);

    

    cudaFree(dA);
    cudaFree(dB);

    return 0;
}
