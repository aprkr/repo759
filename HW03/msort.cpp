// Generated with ChatGPT
#include <iostream>
#include "msort.h"
#include <vector>
#include <algorithm>
using namespace std;

// Function to merge two sorted halves of an array
void merge(int* arr, int left, int mid, int right) {
    int n1 = mid - left + 1;
    int n2 = right - mid;

    // Create temporary arrays
    int* L = new int[n1];
    int* R = new int[n2];

    // Copy data to temporary arrays
    for (int i = 0; i < n1; i++)
        L[i] = arr[left + i];
    for (int j = 0; j < n2; j++)
        R[j] = arr[mid + 1 + j];

    // Merge the temporary arrays back into arr[left..right]
    int i = 0, j = 0, k = left;
    while (i < n1 && j < n2) {
        if (L[i] <= R[j]) {
            arr[k] = L[i];
            i++;
        } else {
            arr[k] = R[j];
            j++;
        }
        k++;
    }

    // Copy remaining elements of L[] if any
    while (i < n1) {
        arr[k] = L[i];
        i++;
        k++;
    }

    // Copy remaining elements of R[] if any
    while (j < n2) {
        arr[k] = R[j];
        j++;
        k++;
    }
}

// Main merge sort function with OpenMP
void msort(int* arr, const std::size_t n, const std::size_t threshold) {
    if ((n < threshold) | (threshold == 1)) {
        vector<int> idk(arr, arr + n);
        sort(idk.begin(), idk.end());
        arr = &idk[0];
        return;
    }

    int mid = n / 2;

    #pragma omp task
    msort(arr, mid, threshold);
    #pragma omp task
    msort(arr + mid, n - mid, threshold);
    #pragma omp taskwait
    merge(arr, 0, mid - 1, n - 1);
}
