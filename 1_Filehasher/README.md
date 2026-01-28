# Filehasher Form 

You will need to write an app that exports a functionality to compute the 
SHA256 hash of a given file. You will need to define an activity with an 
intent filter for the "com.mobiotsec.intent.action.HASHFILE" action. 
The system will start your activity and ask you to hash a file.

The file path is specified in the Uri part of the intent you receive 
(which you can access with intent.getData()). 
You need to put the calculated hash in a result intent (under the "hash" key, see below) and in hexadecimal format. 

To help you debug problems, the system will add in the log what 
the content of the file was, what it was expecting as the result 
hash, and what it found from your reply. If the expected hash and 
the one from your app match, the flag will be printed in the logs.

Example on how to pass the hash back:

```bash
// calculate hash
String hash = calcHash(filePath);

// return the hash in a "result" intent
Intent resultIntent = new Intent();
resultIntent.putExtra("hash", hash);
setResult(Activity.RESULT_OK, resultIntent);
finish()
```

___

## How to solve it 

We need to create an **implicit intent** + **intent filter** pointing to the action: `com.mobiosec.intent.action.HASHFILE`.

*(Supposed that we have the function `calcHash()`)*

### 1. Creating an Intent Filter in our Android Manifest

Same as the example of `ACTION_SEND`.
Reference: [Intents and Intent Filters](https://developer.android.com/guide/components/intents-filters)

**Always start by looking at the Android Manifest.**

We need to create an intent filter to tell the Android OS "I can handle `com.mobiotsec.intent.action.HASHFILE`". This defines how we're going to receive the implicit intent.

**Specifications:**
1.  **Action to handle:** `com.mobiotsec.intent.action.HASHFILE`
2.  **Category:** `DEFAULT`
3.  **MimeType:** `text/plain`

```xml
<activity>
    ....

    <intent-filter>
        <action android:name="com.mobiotsec.intent.action.HASHFILE" />
        <category android:name="android.intent.category.DEFAULT" />
        <data android:mimeType="text/plain"/>
    </intent-filter>

</activity>
```

### 2. MainActivity

We need to perform the following steps:
* **OnCreate:** The app starts here.
* **GetIntent:** Grab the message that started the app.
* **GetData:** Extract the file path from the intent.
* **Log.d:** Our way to see messages on `logcat` (our terminal).

All this happens inside of `OnCreate`:

```java
private static int TAG = "CTF";

// 1. Get the intent that we're looking for
Intent intent = getIntent();

// 2. Check that it's not null 
if (intent != null){

    // 3. We're looking for a URI object inside of the data of intent
    Uri fileUri = intent.getData();

    if (fileUri != null){
        
        // Just to show what I'm using 
        Log.d(TAG, "File URI: " + fileUri.getPath());

        // 4. Calculate the hash function 
        String hash = calculateSHA256(fileUri);

        // 5. Send the result back
        Intent resultIntent = new Intent();
        resultIntent.putExtra("hash", hash);
        setResult(RESULT_OK, resultIntent);
        finish(); // Don't forget to finish the activity

    } else {
        Log.d(TAG, "No file URI found in the intent");
    }

}
```

## Solution

Log output showing success:

```bash
2026-01-18 12:51:32.941  7249-7249  MOBIOTSEC  com.example.victimapp  I  Good job! The expected hash and the received hash match! The flag is FLAG{piger_ipse_sibi_obstat}
```

**Flag:** `FLAG{piger_ipse_sibi_obstat}`