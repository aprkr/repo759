// Generated with chatgpt

#include <iostream>
#include <vector>
#include <chrono>
#include <random>
#include "matmul.h"

void generate_random_matrix(std::vector<double>& matrix, unsigned int n) {
    std::random_device rd;  
    std::mt19937 gen(rd());  // Mersenne Twister engine
    std::uniform_real_distribution<double> dis(-10.0, 10.0);
    for (unsigned int i = 0; i < n * n; ++i) {
        matrix[i] = dis(gen); // Random values between -10.0 and 10.0
    }
}

int main() {
    const unsigned int n = 1000; // Dimension of the matrices
    std::vector<double> A(n * n);
    std::vector<double> B(n * n);
    std::vector<double> C(n * n); // Output matrix

    // Generate random matrices A and B
    generate_random_matrix(A, n);
    generate_random_matrix(B, n);

    // Print the number of rows
    std::cout << n << std::endl;

    // Measure time for mmul1
    auto start = std::chrono::high_resolution_clock::now();
    mmul1(A.data(), B.data(), C.data(), n);
    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::milli> duration1 = end - start;
    std::cout << duration1.count() << std::endl;
    std::cout << C[n * n - 1] << std::endl;

    // Measure time for mmul2
    std::fill(C.begin(), C.end(), 0.0); // Clear C for reuse
    start = std::chrono::high_resolution_clock::now();
    mmul2(A.data(), B.data(), C.data(), n);
    end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::milli> duration2 = end - start;
    std::cout << duration2.count() << std::endl;
    std::cout << C[n * n - 1] << std::endl;
    
    // Measure time for mmul3
    std::fill(C.begin(), C.end(), 0.0); // Clear C for reuse
    start = std::chrono::high_resolution_clock::now();
    mmul3(A.data(), B.data(), C.data(), n);
    end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::milli> duration3 = end - start;
    std::cout << duration3.count() << std::endl;
    std::cout << C[n * n - 1] << std::endl;

    // Measure time for mmul4
    std::fill(C.begin(), C.end(), 0.0); // Clear C for reuse
    start = std::chrono::high_resolution_clock::now();
    mmul4(A, B, C.data(), n);
    end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::milli> duration4 = end - start;
    std::cout << duration4.count() << std::endl;
    std::cout << C[n * n - 1] << std::endl;

    return 0;
}
