// Generated with chatgpt
#include "matmul.h"

// Function to multiply matrices using a straightforward triple loop (mmul1)
void mmul1(const double* A, const double* B, double* C, const unsigned int n) {
    for (unsigned int i = 0; i < n; ++i) {                // Loop over rows of C
        for (unsigned int j = 0; j < n; ++j) {            // Loop over columns of C
            for (unsigned int k = 0; k < n; ++k) {        // Loop over the dot product
                C[i * n + j] += A[i * n + k] * B[k * n + j];
            }
        }
    }
}

// Function to multiply matrices with the innermost loops swapped (mmul2)
void mmul2(const double* A, const double* B, double* C, const unsigned int n) {
    for (unsigned int i = 0; i < n; ++i) {                // Loop over rows of C
        for (unsigned int k = 0; k < n; ++k) {            // Loop over the dot product
            for (unsigned int j = 0; j < n; ++j) {        // Loop over columns of C
                C[i * n + j] += A[i * n + k] * B[k * n + j];
            }
        }
    }
}

// Function to multiply matrices with the outermost loop moved (mmul3)
void mmul3(const double* A, const double* B, double* C, const unsigned int n) {
    for (unsigned int j = 0; j < n; ++j) {                // Loop over columns of C
        for (unsigned int k = 0; k < n; ++k) {            // Loop over the dot product
            for (unsigned int i = 0; i < n; ++i) {        // Loop over rows of C
                C[i * n + j] += A[i * n + k] * B[k * n + j];
            }
        }
    }
}

// Function to multiply matrices using std::vector (mmul4)
void mmul4(const std::vector<double>& A, const std::vector<double>& B, double* C, const unsigned int n) {
    for (unsigned int i = 0; i < n; ++i) {                // Loop over rows of C
        for (unsigned int j = 0; j < n; ++j) {            // Loop over columns of C
            C[i * n + j] = 0.0;                            // Initialize C[i][j]
            for (unsigned int k = 0; k < n; ++k) {        // Loop over the dot product
                C[i * n + j] += A[i * n + k] * B[k * n + j];
            }
        }
    }
}
