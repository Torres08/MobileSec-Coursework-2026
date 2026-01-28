# Babyrev

The career of every reverser starts with a babyrev chall. Here is yours.

___

## How to solve it 

**Core Concept:** Introduction to Reverse Engineering (Local Verification).
We have an apk that verifies a secret code locally on the device. The task is to reverse engineer the application, understand the verification logic, and reconstruct the correct flag.

**Tools:** `jadx-gui`

**Where to look?**
* **Manifest:** Entry points.
* **MainActivity:** Handles the UI.
* **Goal:** You need to read Java `if` statements, string manipulations (`substring`, `reverse`, `charAt`), and basic boolean logic (`&&`).

### 1. Drag + Drop 
Drag + drop the APK into **Jadx-GUI** and load it.
Navigate to: `com.mobiosec.babyrev` -> `MainActivity`.

We see this verification logic:
```java
if (FlagChecker.checkFlag(MainActivity.this, flagWidget.getText().toString())) {
    msg = "Valid flag!";
    color = -16737536;
} else {
    msg = "Invalid flag";
    color = SupportMenu.CATEGORY_MASK;
}
```
This tells us the core logic is inside the `FlagChecker` class.

### 2. FlagChecker Analysis

The goal is to understand the `checkFlag` function. It is a long chain of boolean checks joined by `&&` (AND).

```java
public static boolean checkFlag(Context ctx, String flag) {
    return flag.startsWith("FLAG{") && 
           new StringBuilder(flag).reverse().toString().charAt(0) == '}' && 
           flag.length() == 27 && 
           flag.toLowerCase().substring(5).startsWith("scientia") && 
           new StringBuilder(flag).reverse().toString().toLowerCase().substring(1).startsWith(ctx.getString(R.string.last_part)) && 
           flag.toLowerCase().charAt(12) == 'a' && 
           flag.charAt(13) == '_' && 
           flag.charAt(22) == '_' && 
           flag.toLowerCase().charAt(12) == 'a' && 
           flag.toLowerCase().charAt(12) == flag.toLowerCase().charAt(21) && 
           flag.toLowerCase().charAt((int) (Math.pow((double) getX(), (double) getX()) + Math.pow((double) getX(), (double) getY()))) == flag.toLowerCase().charAt((int) (Math.pow((double) getZ(), (double) getX()) + 5.0d)) && 
           bam(flag.substring((int) (Math.pow((double) getZ(), (double) getX()) - 2.0d), ((int) Math.pow((double) getX(), (double) (getX() + getY()))) + (-10))).equals("cBgRaGvN") && 
           flag.substring(5, flag.length() - 1).matches(getR());
}
```

**Divide & Conquer Strategy:**

1.  **Wrapper:** `startsWith("FLAG{")` & `reverse()...charAt(0) == '}'`
    * Current State: `FLAG{.....}`
2.  **Length:** `flag.length() == 27`
    * Total 27 chars. Removing `FLAG{}` (6 chars) leaves **21 characters** inside.
3.  **Start (Inner):** `flag.toLowerCase().substring(5).startsWith("scientia")`
    * Current State: `FLAG{scientia.....}`
4.  **End (Inner):** `reverse()...startsWith(ctx.getString(R.string.last_part))`
    * This checks a string resource, not hardcoded code.
    * Go to `Resources` -> `resources.arsc` -> `res/values/strings.xml`.
    * Value: `<string name="last_part">tse</string>`
    * The code reverses the flag to check, so the actual ending is `tse` reversed -> `est`.
    * Current State: `FLAG{scientia...est}`
5.  **Separators:** `charAt(13) == '_'` && `charAt(22) == '_'`
    * Current State: `FLAG{scientia_..._est}`
6.  **Middle Section (The Cipher):**
    * The complex math basically points to the middle section.
    * Logic: `bam(middle_string).equals("cBgRaGvN")`

#### 3. Analyzing `bam()` (ROT13)



```java
private static String bam(String s) {
    StringBuilder out = new StringBuilder();
    for (int i = 0; i < s.length(); i++) {
        char c = s.charAt(i);
        if (c >= 'a' && c <= 'm') { c = (char) (c + '\r'); }      // +13
        else if (c >= 'A' && c <= 'M') { c = (char) (c + '\r'); } // +13
        else if (c >= 'n' && c <= 'z') { c = (char) (c - '\r'); } // -13
        else if (c >= 'N' && c <= 'Z') { c = (char) (c - '\r'); } // -13
        out.append(c);
    }
    return out.toString();
}
```

This is a classic **Shift Cipher (ROT13)**.
* Input to match: `cBgRaGvN`
* Apply ROT13 to decrypt: `c`->`p`, `B`->`O`, `g`->`t`, `R`->`E`, `a`->`n`, `G`->`T`, `v`->`i`, `N`->`A`.
* Result: `pOtEnTiA`
* Current State: `FLAG{scientia_pOtEnTiA_est}`

#### 4. The Final Check: `getR()`

We are almost there, but the case (upper/lower) needs to be correct.
Code: `flag.matches(getR())`

```java
public static String getR() {
    StringBuilder r = new StringBuilder();
    boolean upper = true;
    for (int i = 0; i < 21; i++) {
        if (upper) { r.append("[A-Z_]"); } 
        else { r.append("[a-z_]"); }
        upper = !upper; // Toggle case every character
    }
    return r.toString();
}
```

**Rule:** The inner content must alternate: **Uppercase, Lowercase, Uppercase...**

* Raw string: `scientia_potentia_est`
* Apply pattern:
    * S (Upper)
    * c (Lower)
    * I (Upper)
    * e (Lower)
    * ...

## Solution 

Applying the alternating case rule to our constructed string:

**Raw:** `scientia_potentia_est`
**Formatted:** `ScIeNtIa_pOtEnTiA_EsT`

```bash
FLAG{ScIeNtIa_pOtEnTiA_EsT}
```