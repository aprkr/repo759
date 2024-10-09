#include <iostream>
#include <cstdlib>
#include "msort.h"
#include <random>
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
    std::size_t ts = std::stoul(argv[3]);

    omp_set_num_threads(threads);

    int array[n];

    std::random_device rd;  
    std::mt19937 gen(rd());  // Mersenne Twister engine
    std::uniform_real_distribution<float> dis(-1000.0, 1000.0);  // Uniform distribution between -1.0 and 1.0
    for (std::size_t i = 0; i < n; i++) {
        array[i] = (int)dis(gen);
    }

    // Apply the convolution
    start = high_resolution_clock::now();
    msort(array, n, ts);
    end = high_resolution_clock::now();

    duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    printf("%d\n",array[0]);
    printf("%d\n",array[n - 1]);
    printf("%f\n",duration_sec.count());

    return EXIT_SUCCESS;
}