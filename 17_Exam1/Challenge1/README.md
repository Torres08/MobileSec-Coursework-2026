How to solve it 

- filehasher problem remember it 
- implicit intent + intent filter pointing to the action 

which action? 
- com.mobiotsec.intent.action.HASHFILE


in the filehasher we're listeners, we're the server 

1. lets hear 
```xml
<activity android:name=".HashMe" android:exported="true">
            <intent-filter>
                <action android:name="com.mobiotsec.intent.action.HASHFILE" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:mimeType="text/plain"/>
            </intent-filter>
        </activity>
```


2. whats happening in hash.java

we dont need to modify anything from this part 

we have the fucntion 
    protected String calcHash(String uriString) throws NoSuchAlgorithmException {

- calculate the hash that we need to send
- Logic: It reads the file stream from intent.getData().
- The Key Line: It logs the raw content of the file before hashing it.


```bash
2026-01-27 22:16:40.226 20192-20192 MOBIOTSEC               com.example.victimapp                I  /data/YM3oPnYG.dat
2026-01-27 22:16:40.387 20162-20162 MOBIOTSEC               com.example.maliciousapp             I  Dat: content://com.example.victimapp.fileprovider/data/YM3oPnYG.dat
2026-01-27 22:16:40.401 20162-20162 MOBIOTSEC               com.example.maliciousapp             I  Hash String: YXIGwdxJwMcaNSMOYQz
2026-01-27 22:16:40.405 20162-20162 MOBIOTSEC               com.example.maliciousapp             I  Hash SHA256: a592816cedf1d57ea9228d7ba1145256d4d9764efc78b70bcc58b5b4922f305c
2026-01-27 22:16:40.453 20192-20192 MOBIOTSEC               com.example.victimapp                I  Good job! The expected hash and the received hash match! The flag is FLAG{piger_ipse_sibi_obstat}
```


The victim app suffers from Implicit Intent Hijacking. It broadcasts sensitive file URIs using an implicit intent (com.mobiotsec.intent.action.HASHFILE) without restricting the receiver to a specific package or signature. This allows any third-party app with a matching Intent Filter to intercept the data.


maybe its just adding a intent filter on the manifest 
- I confirmed the AndroidManifest.xml contained an <intent-filter> listening for the HASHFILE action and text/plain MIME type, matching the victim's broadcast.
- I set the package name to com.example.maliciousapp (or the specific name required by the victim) to ensure the Android system routed the request to my app.
- I utilized the provided HashMe activity, which opens the input stream from intent.getData() and logs the content.
- Upon launching the victim app, the intent was intercepted by my app, and the flag FLAG{piger_ipse_sibi_obstat} was extracted from the Logcat output."

FLAG{piger_ipse_sibi_obstat}


The Goal of the Attack is indeed to inject that Intent Filter.

    The Victim shouts: "I need action com.mobiotsec.intent.action.HASHFILE!"

    The Filter answers: "I handle com.mobiotsec.intent.action.HASHFILE!"

    The Result: The connection is made.

"The solution was to register an Intent Filter for the action com.mobiotsec.intent.action.HASHFILE."