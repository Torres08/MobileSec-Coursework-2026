how to solve it 

reverse engineering cryptography 

the developer hid the glag inside an ecrypted broadcast intent
- find the key and the Mode they used so you can reverse the proces 


1. find the ecryption code 


open jadx gui the justlisten.apk 


search for intent 


```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    android:versionCode="1"
    android:versionName="1.0"
    android:compileSdkVersion="33"
    android:compileSdkVersionCodename="13"
    package="com.example.victimapp"
    platformBuildVersionCode="33"
    platformBuildVersionName="13">
    <uses-sdk
        android:minSdkVersion="26"
        android:targetSdkVersion="32"/>
    <permission
        android:name="com.example.victimapp.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION"
        android:protectionLevel="signature"/>
    <uses-permission android:name="com.example.victimapp.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION"/>
    <application
        android:theme="@style/Theme.VictimApp"
        android:label="@string/app_name"
        android:icon="@mipmap/ic_launcher"
        android:debuggable="true"
        android:allowBackup="true"
        android:supportsRtl="true"
        android:extractNativeLibs="false"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:appComponentFactory="androidx.core.app.CoreComponentFactory">
        <activity
            android:name="com.example.victimapp.MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        <provider
            android:name="androidx.startup.InitializationProvider"
            android:exported="false"
            android:authorities="com.example.victimapp.androidx-startup">
            <meta-data
                android:name="androidx.emoji2.text.EmojiCompatInitializer"
                android:value="androidx.startup"/>
            <meta-data
                android:name="androidx.lifecycle.ProcessLifecycleInitializer"
                android:value="androidx.startup"/>
        </provider>
    </application>
```

does not contain the encryption keys.

You need to use JADX to look at the Java code to find the "secrets."


mainactivity

```java
/* loaded from: classes3.dex */
public class MainActivity extends AppCompatActivity {
    private static final String AES_ALGORITHM = "AES";
    private static final String AES_SECRET_KEY = "MobisecExamJuly2";
    private static final String AES_TRANSFORMATION = "AES/ECB/PKCS5Padding";
    String TAG = "MOBIOTSEC";

    @Override // androidx.fragment.app.FragmentActivity, androidx.activity.ComponentActivity, androidx.core.app.ComponentActivity, android.app.Activity
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Log.e(this.TAG, "victimapp:: onCreate");
        Intent intent = new Intent();
        intent.setAction("victim.app.FLAG_ANNOUNCEMENT");
        try {
            intent.putExtra("flag", encryptString("FLAG{carpe_diem}"));
            Log.e(this.TAG, "victimapp:: setting the flag");
            sendBroadcast(intent);
            Log.e(this.TAG, "victimapp:: broadcasting the flag");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private String encryptString(String plainText) throws Exception {
        SecretKey secretKey = new SecretKeySpec(AES_SECRET_KEY.getBytes(), AES_ALGORITHM);
        Cipher cipher = Cipher.getInstance(AES_TRANSFORMATION);
        cipher.init(1, secretKey);
        byte[] encryptedBytes = cipher.doFinal(plainText.getBytes());
        return Base64.encodeToString(encryptedBytes, 0);
    }
}
```


// 1. FILL IN THE SECRETS YOU FOUND
private static final String AES_ALGORITHM = "AES";
private static final String AES_TRANSFORMATION = "AES/ECB/PKCS5Padding";
private static final String AES_SECRET_KEY = "MobisecExamJuly2";


The string AES/ECB/PKCS5Padding tells you exactly how the data was locked.
- What it is: A symmetric encryption standard used globally to secure data.
- The developer hardcoded this secret key ("MobisecExamJuly2") inside the app code. Since you found the key, you can simply reverse the process.

This determines how the algorithm handles long text. AES processes data in fixed chunks (blocks) of 16 bytes.


AES must have blocks of exactly 16 bytes. But what if your message is 20 bytes long?


When the Victim App runs encryptString("FLAG{carpe_diem}"):

    Padding: It takes the text FLAG{carpe_diem} (17 bytes). It adds padding to make it 32 bytes (two full blocks).

    Splitting: It splits it into Block A and Block B.

    Encrypting:

        Key + Block A -> Encrypted A

        Key + Block B -> Encrypted B

    Result: It joins them together to send the broadcast.

Encrypted Bytes -> Decrypt (using Key) -> Padded Text -> Remove Padding -> FLAG{carpe_diem}


```bash
---------------------------- PROCESS ENDED (22435) for package com.example.maliciousapp ----------------------------
2026-01-28 00:19:16.953  3630-3630  ActivityThread          com.google.android.photopicker       D  Package [com.mobiotsec.nojumpstarts] reported as REPLACED, but missing application info. Assuming REMOVED.
---------------------------- PROCESS STARTED (23011) for package com.example.maliciousapp ----------------------------
2026-01-28 00:19:31.221 23057-23057 MOBIOTSEC               com.example.victimapp                E  victimapp:: onCreate
2026-01-28 00:19:31.222 23057-23057 MOBIOTSEC               com.example.victimapp                E  victimapp:: setting the flag
2026-01-28 00:19:31.224 23057-23057 MOBIOTSEC               com.example.victimapp                E  victimapp:: broadcasting the flag
2026-01-28 00:19:31.742 23011-23011 MOBIOTSEC               com.example.maliciousapp             I  FLAG{carpe_diem}
```

