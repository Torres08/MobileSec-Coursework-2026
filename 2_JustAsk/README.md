# justask
There is an app installed on the system. The app has four activities. Each of them has one part of the flag. If you ask them nicely, they will all kindly reply with their part of the flag. They will reply with an Intent, the part of the flag is somehow contained there. Check the app's manifest for the specs. Good luck ;-)

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
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

## Solution

```bash
2026-01-18 17:39:24.285  9242-9242  CTF                     com.example.maliciousapp             D  --- APP STARTED ---
2026-01-18 17:39:24.791  9242-9242  CTF                     com.example.maliciousapp             D  Key: never ending story, Value: _cadendo}
2026-01-18 17:39:24.791  9242-9242  CTF                     com.example.maliciousapp             D  Key: flag, Value: lapidem_non_vi
2026-01-18 17:39:24.791  9242-9242  CTF                     com.example.maliciousapp             D  Key: hiddenFlag, Value: _sed_saepe
2026-01-18 17:39:24.791  9242-9242  CTF                     com.example.maliciousapp             D  Key: flag, Value: let's spice this up
2026-01-18 17:39:24.791  9242-9242  CTF                     com.example.maliciousapp             D  Key: flag, Value: FLAG{Gutta_cavat_
```