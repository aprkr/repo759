// Generated with chatgpt

#include <iostream>
#include <vector>
#include <chrono>
#include <random>
#include "matmul.h"

void generate_random_matrix(std::vector<float>& matrix, unsigned int n) {
    std::random_device rd;  
    std::mt19937 gen(rd());  // Mersenne Twister engine
    std::uniform_real_distribution<float> dis(-10.0, 10.0);
    for (unsigned int i = 0; i < n * n; ++i) {
        matrix[i] = dis(gen); // Random values between -10.0 and 10.0
    }
}

int main(int argc, char* argv[]) {
    const unsigned int n = std::atoi(argv[1]);; // Dimension of the matrices
    const unsigned int threads = std::atoi(argv[2]);; // Number of threads
    omp_set_num_threads(threads);
    std::vector<float> A(n * n);
    std::vector<float> B(n * n);
    std::vector<float> C(n * n); // Output matrix

    // Generate random matrices A and B
    generate_random_matrix(A, n);
    generate_random_matrix(B, n);

    // Measure time for mmul
    auto start = std::chrono::high_resolution_clock::now();
    mmul(A.data(), B.data(), C.data(), n);
    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<float, std::milli> duration1 = end - start;
    std::cout << C[0] << std::endl;
    std::cout << C[n * n - 1] << std::endl;
    std::cout << duration1.count() << std::endl;

    return 0;
}
