#include "scan.h"
#include <stdlib.h>
#include <stdio.h>
#include <random>
#include <chrono>
// Provide some namespace shortcuts
using std::chrono::high_resolution_clock;
using std::chrono::duration;

int main(int argc, char const *argv[])
{
    if (argc > 1) {
        high_resolution_clock::time_point start;
        high_resolution_clock::time_point end;
        duration<double, std::milli> duration_sec;

        size_t n = atoi(argv[1]);
        float arr[n] = {0};
        float out[n] = {0};

        std::random_device rd;  
        std::mt19937 gen(rd());  // Mersenne Twister engine
        std::uniform_real_distribution<float> dis(-1.0, 1.0);  // Uniform distribution between -1.0 and 1.0
        for (std::size_t i = 0; i < n; i++) {
            arr[i] = dis(gen);
        }
        
        start = high_resolution_clock::now();
        scan(arr, out, n);
        end = high_resolution_clock::now();

        duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
        printf("%f\n",duration_sec.count());
        printf("%f\n",out[0]);
        printf("%f\n",out[n-1]);
    }
    
    return 0;
}