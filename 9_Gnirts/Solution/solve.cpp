/**
 * TO COMPILE (Linux/Mac):
 * g++ solve.cpp -o solve -lssl -lcrypto -pthread -O3
 * * TO RUN:
 * ./Solve
 */

#include <iostream>
#include <string>
#include <vector>
#include <thread>
#include <mutex>
#include <iomanip>
#include <sstream>
#include <openssl/evp.h>
#include <cstring>
#include <atomic>

// Global flag to stop threads once a part is found (Optional optimization)
std::atomic<bool> found_part(false);
std::mutex print_mutex;

// --- 1. HELPER FUNCTIONS ---

// Replicates the XOR logic (gs) to recover Algorithm Names (MD5, SHA-1, etc.)
std::string gs(std::string a, std::string b) {
    std::string res = "";
    for (int i = 0; i < a.length(); i++) {
        res += a[i] ^ b[i % b.length()];
    }
    return res;
}

// Replicates toHexString
std::string to_hex(const std::vector<unsigned char>& bytes) {
    std::stringstream ss;
    for (unsigned char b : bytes) {
        ss << std::hex << std::setw(2) << std::setfill('0') << (int)b;
    }
    return ss.str();
}

// Replicates the Hashing Logic (dh) using OpenSSL's EVP interface
// This supports MD5, SHA-1, SHA-256 dynamically based on the string name
std::string dh(std::string algo, std::string s) {
    EVP_MD_CTX* ctx = EVP_MD_CTX_new();
    const EVP_MD* md = EVP_get_digestbyname(algo.c_str());

    if (!md) {
        // Fallback or error handling if algo name is weird
        EVP_MD_CTX_free(ctx);
        return "";
    }

    EVP_DigestInit_ex(ctx, md, NULL);
    EVP_DigestUpdate(ctx, s.c_str(), s.length());

    unsigned char hash[EVP_MAX_MD_SIZE];
    unsigned int lengthOfHash = 0;
    EVP_DigestFinal_ex(ctx, hash, &lengthOfHash);
    EVP_MD_CTX_free(ctx);

    std::vector<unsigned char> hashBytes(hash, hash + lengthOfHash);
    return to_hex(hashBytes);
}

// Replicates 'me' (Equality check)
bool me(std::string s1, std::string s2) {
    return s1 == s2;
}

// --- 2. SOLVER LOGIC ---

// Part 1: 3 lowercase chars (Single Threaded)
void checkFirstPart() {
    std::string algo = gs("xwe", "53P"); // Decodes to "MD5"
    std::string target = "82f5c1c9be89c68344d5c6bcf404c804";
    
    std::cout << "[Part 1] Algo: " << algo << " | Cracking..." << std::endl;

    for (char a = 'a'; a <= 'z'; a++) {
        for (char b = 'a'; b <= 'z'; b++) {
            for (char c = 'a'; c <= 'z'; c++) {
                std::string combo = {a, b, c};
                if (me(dh(algo, combo), target)) {
                    std::lock_guard<std::mutex> lock(print_mutex);
                    std::cout << "Found Part 1: " << combo << std::endl;
                    return;
                }
            }
        }
    }
}

// Part 2 Worker: 6 lowercase chars
void workerPart2(char start, char end, std::string algo, std::string target) {
    for (char c1 = start; c1 <= end; c1++) {
        if(found_part) return; // Stop if found by another thread
        for (char c2 = 'a'; c2 <= 'z'; c2++) {
            for (char c3 = 'a'; c3 <= 'z'; c3++) {
                for (char c4 = 'a'; c4 <= 'z'; c4++) {
                    for (char c5 = 'a'; c5 <= 'z'; c5++) {
                        for (char c6 = 'a'; c6 <= 'z'; c6++) {
                            std::string combo = {c1, c2, c3, c4, c5, c6};
                            if (me(dh(algo, combo), target)) {
                                std::lock_guard<std::mutex> lock(print_mutex);
                                std::cout << "Found Part 2: " << combo << std::endl;
                                found_part = true;
                                return;
                            }
                        }
                    }
                }
            }
        }
    }
}

// Part 3 Worker: 5 Uppercase chars
void workerPart3(char start, char end, std::string algo, std::string target) {
    for (char c1 = start; c1 <= end; c1++) {
        if(found_part) return;
        for (char c2 = 'A'; c2 <= 'Z'; c2++) {
            for (char c3 = 'A'; c3 <= 'Z'; c3++) {
                for (char c4 = 'A'; c4 <= 'Z'; c4++) {
                    for (char c5 = 'A'; c5 <= 'Z'; c5++) {
                        std::string combo = {c1, c2, c3, c4, c5};
                        if (me(dh(algo, combo), target)) {
                            std::lock_guard<std::mutex> lock(print_mutex);
                            std::cout << "Found Part 3: " << combo << std::endl;
                            found_part = true;
                            return;
                        }
                    }
                }
            }
        }
    }
}

// Part 4 Worker: Pattern 11xXx1111 (D D l U l D D D D)
// OPTIMIZED Part 4 Worker
void workerPart4(char d1, std::string algo, std::string target) {
    std::cout << "Thread checking Part 4 starting with: " << d1 << std::endl;
    
    // 1. Setup OpenSSL Context ONCE (reuse it)
    EVP_MD_CTX* ctx = EVP_MD_CTX_new();
    const EVP_MD* md = EVP_get_digestbyname(algo.c_str());
    unsigned char hash[EVP_MAX_MD_SIZE];
    unsigned int lengthOfHash = 0;

    // 2. Pre-allocate buffer (Avoid std::string in loop)
    char buffer[15]; // Large enough for "28jAn1596"
    // We know the structure: D1 D2 L1 U1 L2 D3 D4 D5 D6
    // Indices:              0  1  2  3  4  5  6  7  8
    buffer[0] = d1;
    buffer[9] = '\0'; // Null terminator

    const char* lower = "abcdefghijklmnopqrstuvwxyz";
    const char* upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const char* digits = "0123456789";

    // Flattened loops
    for (int i2 = 0; i2 < 10; i2++) {
        buffer[1] = digits[i2];
        for (int i3 = 0; i3 < 26; i3++) {
            buffer[2] = lower[i3];
            for (int i4 = 0; i4 < 26; i4++) {
                buffer[3] = upper[i4];
                for (int i5 = 0; i5 < 26; i5++) {
                    buffer[4] = lower[i5];
                    
                    // Inner digits loop (0000-9999)
                    for (int i = 0; i <= 9999; i++) {
                        // Fast formatting for the last 4 digits
                        buffer[5] = digits[(i / 1000) % 10];
                        buffer[6] = digits[(i / 100) % 10];
                        buffer[7] = digits[(i / 10) % 10];
                        buffer[8] = digits[i % 10];

                        // 3. Hashing without reallocation
                        EVP_DigestInit_ex(ctx, md, NULL);
                        EVP_DigestUpdate(ctx, buffer, 9);
                        EVP_DigestFinal_ex(ctx, hash, &lengthOfHash);

                        // 4. Check Match (Compare Raw Bytes, not Hex String)
                        // We convert the Hex Target string to bytes for comparison? 
                        // Actually, simpler: just convert THIS hash to hex and compare only if necessary.
                        // Optimization: Check first byte/nibble first to avoid string conversion?
                        // For simplicity, let's just do the hex conversion but keep it fast.
                        
                        // To keep it compatible with your 'target' string (which is Hex), 
                        // we quickly format to hex ONLY if we need to print or complex match.
                        // BUT: Comparing strings is slow. 
                        // Let's rely on the previous logic but keep allocation out.
                        
                        // Fast Hex Conversion
                        static const char hex_map[] = "0123456789abcdef";
                        std::string currentHex;
                        currentHex.reserve(32);
                        for (unsigned int b = 0; b < lengthOfHash; b++) {
                            currentHex.push_back(hex_map[hash[b] >> 4]);
                            currentHex.push_back(hex_map[hash[b] & 0x0F]);
                        }

                        if (currentHex == target) {
                            std::lock_guard<std::mutex> lock(print_mutex);
                            std::cout << "🎉 Found Part 4: " << buffer << std::endl;
                            found_part = true;
                            EVP_MD_CTX_free(ctx);
                            return;
                        }
                    }
                }
            }
        }
    }
    EVP_MD_CTX_free(ctx);
}

// --- 3. ORCHESTRATORS ---

void solveWithThreads(int part) {
    std::vector<std::thread> threads;
    found_part = false; // Reset flag

    if (part == 2) {
        std::string algo = gs("asd", ",7Q");
        std::string target = "e86d706732c0578713b5a2eed1e6fb81";
        std::cout << "[Part 2] Algo: " << algo << " | Cracking with 8 threads..." << std::endl;

        // Split 'a'-'z' (26 chars) among 8 threads
        int range = 26; 
        int num_threads = 8;
        int step = range / num_threads; 
        
        for(int i=0; i<num_threads; i++) {
            char start = 'a' + (i * step);
            char end = (i == num_threads - 1) ? 'z' : start + step - 1;
            threads.emplace_back(workerPart2, start, end, algo, target);
        }
    } 
    else if (part == 3) {
        std::string algo = gs("uyt", "8=A");
        std::string target = "7ff1301675eb857f345614f9d9e47c89";
        std::cout << "[Part 3] Algo: " << algo << " | Cracking with 8 threads..." << std::endl;

        int range = 26; 
        int num_threads = 8;
        int step = range / num_threads; 

        for(int i=0; i<num_threads; i++) {
            char start = 'A' + (i * step);
            char end = (i == num_threads - 1) ? 'Z' : start + step - 1;
            threads.emplace_back(workerPart3, start, end, algo, target);
        }
    }

    // Join threads
    for (auto& t : threads) t.join();
}

void solveFourthPart() {
    std::string algo = gs("42s", "yvF");
    std::string target = "b446830c23bf4d49d64a5c753b35df9a";
    std::cout << "[Part 4] Algo: " << algo << " | Cracking with 10 threads..." << std::endl;
    found_part = false;

    std::vector<std::thread> threads;
    // Split by first digit (0-9), exactly 10 threads
    for (char d = '0'; d <= '9'; d++) {
        threads.emplace_back(workerPart4, d, algo, target);
    }

    for (auto& t : threads) t.join();
}

int main() {
    // 1. Part 1 (Fast)
    checkFirstPart();

    // 2. Part 2 (Threaded)
    solveWithThreads(2);

    // 3. Part 3 (Threaded)
    solveWithThreads(3);

    // 4. Part 4 (Threaded - Longest)
    solveFourthPart();

    return 0;
}