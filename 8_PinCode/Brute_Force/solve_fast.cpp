#include <iostream>
#include <vector>
#include <cstring>
#include <openssl/md5.h>
#include <thread>
#include <atomic>

// Compile: g++ solve_fast.cpp -o solve_fast -lssl -lcrypto -pthread -O3

// Target: d04988522ddfed3133cc24fb6924eae9
unsigned char TARGET[16] = {
    0xd0, 0x49, 0x88, 0x52, 0x2d, 0xdf, 0xed, 0x31,
    0x33, 0xcc, 0x24, 0xfb, 0x69, 0x24, 0xea, 0xe9
};

// Flag to stop all threads once found
std::atomic<bool> found(false);

void crack_range(int start, int end) {
    unsigned char buffer[16];
    char pin[7];

    for (int i = start; i < end; i++) {
        if (found) return; // Stop if another thread found it

        sprintf(pin, "%06d", i);

        // 1. Initial Hash
        MD5((unsigned char*)pin, 6, buffer);

        // 2. Chain 9999 more times (Total 10,000)
        for (int k = 0; k < 9999; k++) {
            MD5(buffer, 16, buffer);
        }

        // 3. Compare
        if (memcmp(buffer, TARGET, 16) == 0) {
            std::cout << "\nFOUND PIN: " << pin << std::endl;
            found = true;
            return;
        }
    }
}

int main() {
    int max_pin = 1000000;
    int num_threads = std::thread::hardware_concurrency(); // Detect CPU cores
    std::cout << "Cracking with " << num_threads << " threads..." << std::endl;

    std::vector<std::thread> threads;
    int step = max_pin / num_threads;

    // Launch threads
    for (int i = 0; i < num_threads; i++) {
        int start = i * step;
        int end = (i == num_threads - 1) ? max_pin : start + step;
        threads.emplace_back(crack_range, start, end);
    }

    // Wait for them to finish
    for (auto& t : threads) {
        t.join();
    }

    return 0;
}