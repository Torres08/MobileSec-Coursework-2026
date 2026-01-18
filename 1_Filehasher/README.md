# Filehasher

You will need to write an app that exports a functionality to compute the SHA256 hash of a given file. You will need to define an activity with an intent filter for the "com.mobiotsec.intent.action.HASHFILE" action. The system will start your activity and ask you to hash a file.

The file path is specified in the Uri part of the intent you receive (which you can access with intent.getData()). You need to put the calculated hash in a result intent (under the "hash" key, see below) and in hexadecimal format. 

To help you debug problems, the system will add in the log what the content of the file was, what it was expecting as the result hash, and what it found from your reply. If the expected hash and the one from your app match, the flag will be printed in the logs.

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

## Solution:

```bash
2026-01-18 12:51:32.941  7249-7249  MOBIOTSEC               com.example.victimapp                I  Good job! The expected hash and the received hash match! The flag is FLAG{piger_ipse_sibi_obstat}
```
