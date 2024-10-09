// Generated with ChatGPT
#include <iostream>
#include "msort.h"

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

// Serial merge sort
void serial_merge_sort(int* arr, const std::size_t n) {
    if (n < 2) return; // Base case
    int mid = n / 2;
    serial_merge_sort(arr, mid);
    serial_merge_sort(arr + mid, n - mid);
    merge(arr, 0, mid - 1, n - 1);
}

// Main merge sort function with OpenMP
void msort(int* arr, const std::size_t n, const std::size_t threshold) {
    if ((n < threshold) | (threshold == 1)) {
        serial_merge_sort(arr, n);
        return;
    }

    int mid = n / 2;

    #pragma omp parallel
    {
        #pragma omp single
        {
            #pragma omp task
            msort(arr, mid, threshold);
            #pragma omp task
            msort(arr + mid, n - mid, threshold);
        }
    }

    merge(arr, 0, mid - 1, n - 1);
}
