// Generated with chatgpt
// Functions to print values and measure time were added by me
#include <iostream>
#include <vector>
#include <random>
#include <cstdlib>
#include "convolution.h"
#include <chrono>
// Provide some namespace shortcuts
using std::chrono::high_resolution_clock;
using std::chrono::duration;

int main(int argc, char *argv[]) {

    high_resolution_clock::time_point start;
    high_resolution_clock::time_point end;
    duration<double, std::milli> duration_sec;

    // Read from command line arguments
    std::size_t n = std::stoul(argv[1]);
    unsigned int threads = std::stoi(argv[2]);

    omp_set_num_threads(threads);
    std::size_t m = 3;

    // Create an n x n image matrix with random floats between -10.0 and 10.0
    std::vector<float> image(n * n);
    std::default_random_engine generator;
    std::uniform_real_distribution<float> image_distribution(-10.0f, 10.0f);
    for (std::size_t i = 0; i < n * n; ++i) {
        image[i] = image_distribution(generator);
    }

    // Create an m x m mask matrix with random floats between -1.0 and 1.0
    std::vector<float> mask(m * m);
    std::uniform_real_distribution<float> mask_distribution(-1.0f, 1.0f);
    for (std::size_t i = 0; i < m * m; ++i) {
        mask[i] = mask_distribution(generator);
    }

    // Prepare an output array to hold the result of the convolution
    std::vector<float> output(n * n);

    // Apply the convolution
    start = high_resolution_clock::now();
    convolve(image.data(), output.data(), n, mask.data(), m);
    end = high_resolution_clock::now();

    duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    printf("%f\n",output[0]);
    printf("%f\n",output[n * n - 1]);
    printf("%f\n",duration_sec.count());

    return EXIT_SUCCESS;
}