# pincode

Give me the PIN, I'll give you the flag.

___ 

## How to solve it 

**Core Concept:** Reverse Engineering + Hashing Brute-force.

We have intercepted an app that protects a secret flag with a **6-digit PIN code**. The app uses a standard hashing algorithm (MD5) to verify the PIN.

**Task:**
1.  Reverse engineer the APK to understand the verification logic.
2.  Recover the PIN by brute-forcing the hash (since MD5 is a one-way function).
3.  Unlock the flag.

### 1. Static Analysis (Jadx-GUI)

Drag and drop the APK into **Jadx-GUI**. Look for the `checkPin` function.

We can see a teasing `getFlag` function:
```java
public String getFlag(String pin) {
    return "FLAG{in_vino_veritas}";
}
```
We want to know the PIN to unlock the flag.

```java
public static boolean checkPin(Context ctx, String pin) throws NoSuchAlgorithmException {
    if (pin.length() != 6) {
        return false;
    }
    try {
        byte[] pinBytes = pin.getBytes();
        for (int i = 0; i < 25; i++) {
            for (int j = 0; j < 400; j++) {
                MessageDigest md = MessageDigest.getInstance("MD5");
                md.update(pinBytes);
                pinBytes = (byte[]) md.digest().clone();
            }
        }
        return toHexString(pinBytes).equals("d04988522ddfed3133cc24fb6924eae9");
    } catch (Exception e) {
        Log.e("MOBIOTSEC", "Exception while checking pin");
        return false;
    }
}
```

**Analysis:**
* `pin.length() != 6` -> The PIN is composed of **6 numbers**.
* `MessageDigest.getInstance("MD5")` -> The algorithm used is **MD5**.
* The loops (`25 * 400`) indicate the hash is re-calculated 10,000 times.

### 2. Brute Force

We need to create a function to brute-force the PIN. C++ is usually faster for this task.

You can create a new scratch file in your IDE or use the code below.

**File:** `solve_fast.cpp`

```cpp
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
```

## Solution

```bash
❯ ./solve_fast 
Cracking with 8 threads...

FOUND PIN: 703958
```