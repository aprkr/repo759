// Generated with chatgpt
// I had to modify the edge/corner checking
#include "convolution.h"
#include <cstddef>

void convolve(const float *image, float *output, std::size_t n, const float *mask, std::size_t m) {

    // Calculate the offset for the mask
    int offset = m / 2;

    // Perform convolution
    #pragma omp parallel for
    for (std::size_t x = 0; x < n; ++x) {
        for (std::size_t y = 0; y < n; ++y) {
            float sum = 0.0f;

            // Apply the convolution mask
            for (std::size_t i = 0; i < m; ++i) {
                for (std::size_t j = 0; j < m; ++j) {
                    // Calculate the corresponding pixel in the original image
                    std::size_t f_x = x + i - offset;
                    std::size_t f_y = y + j - offset;

                    // Determine the value of the image at (f_x, f_y)
                    float f_value;
                    if (f_x < 0) {
                        if (f_y < 0 | f_y >= n) {
                            f_value = 0.0f;
                        } else {
                            f_value = 1.0f;
                        }
                    } else if(f_x >= n) {
                        if (f_y < 0 | f_y >= n) {
                            f_value = 0.0f;
                        } else {
                            f_value = 1.0f;
                        }
                    }
                    if (f_x < 0 || f_x >= n || f_y < 0 || f_y >= n) {
                        // Out of bounds: apply padding rules
                        if (f_x < 0 || f_x >= n || f_y < 0 || f_y >= n) {
                            f_value = 0.0f; // Corner cases (out of bounds)
                        } else {
                            f_value = 1.0f; // Edge cases (on the edges but not corners)
                        }
                    } else {
                        f_value = image[f_x * n + f_y]; // In bounds
                    }

                    // Accumulate the convolution sum
                    sum += mask[i * m + j] * f_value;
                }
            }

            output[x * n + y] = sum; // Store the result in the output array
        }
    }
}