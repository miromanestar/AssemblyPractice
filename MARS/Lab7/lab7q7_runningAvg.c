// Simple running_avg function written in C
// Lab 7.7 - Miro Manestar

void running_avg_four(int* my_array, int length) {
    for (int i = length - 1; i >= 3; i--)
        my_array[i] = (my_array[i] + my_array[i - 1] + my_array[i - 2] + my_array[i - 3])>>2;
}