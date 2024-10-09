#include "matmul.h"
// Function to multiply matrices
void mmul(const float* A, const float* B, float* C, const std::size_t n) {
    #pragma omp parallel for collapse(3)
    for (unsigned int i = 0; i < n; ++i) {                // Loop over rows of C
        for (unsigned int k = 0; k < n; ++k) {            // Loop over the dot product
            for (unsigned int j = 0; j < n; ++j) {        // Loop over columns of C
                C[i * n + j] += A[i * n + k] * B[k * n + j];
            }
        }
    }
}