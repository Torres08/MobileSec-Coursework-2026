# MobileSec-Coursework-2026
A collection of Capture The Flag (CTF) solutions and write-ups for the Mobile Security (2025-2026) course UNIPD. Covers Android application analysis, reverse engineering, and vulnerability exploitation.


## 1. Filehasher 
Focus: Handle an implicit intent to hash text and return SHA‑256.
Steps:
1. Add the intent-filter in AndroidManifest.xml.
2. Read the file Uri, compute SHA‑256, put "hash" in the result Intent, finish.

## 2. JustAsk
Focus: Send explicit/implicit intents and read the returned data.
Steps:
1. Send 4 intents (2 explicit, 2 implicit) based on the victim manifest.
2. Handle results with an ActivityResultLauncher and read nested Bundles in

## 3. Serial Intent
Focus: Deserialize a Java object and read the flag.
Steps:
1. Create the twin class com.example.victimapp.FlagContainer.
2. Launch the victim activity, cast the received object, make its flag method accessible, and read it.

## 4. JustListen
Focus: Listen for a broadcast and read the flag from Intent extras.
Steps: 
1. Register a BroadcastReceiver
2. filter the victim’s action
3. log the “flag” extra.

## 5. JokerProvider
Focus: Query a ContentProvider to extract hidden data.
Steps: 
1. Identify the provider URI
2. query via ContentResolver
3. read Cursor rows/columns to get the flag.

## 6. Unbindable 
Focus: Interact with a service that resists binding.
Steps: 
1. Use exported entry points (startService/Intent), 
2. match expected action/extras, 
3. trigger the code path that returns the flag.

## 7. Babyrev
Focus: Reverse a simple transformation to recover the flag.
Steps: 
1. Decompile the APK
2. find the encode/decode method
3. reimplement it
4. run it to get the flag.

## 8. PinCode
Focus: Deobfuscate strings (“gnirts”).
Steps: 
1. Locate obfuscated string logic
2. reverse the operations (reverse/Base64/xor)
3. reconstruct the original flag by bruteforce.

## 9. Gnirts 
Focus: Deobfuscate strings (“gnirts”).
Steps: 
1. Locate obfuscated string logic
2. reverse the operations (reverse/Base64/xor), 
3. reconstruct the original flag by bruteforce

## 10. GoinNative
Focus: Basic native (JNI) function analysis.
Steps: 
1. Read the C/C++ in goingnative
2. find the check/transform
3. call it or reimplement to output the flag

## 11. GoingSeriusNative
Focus: Harder native reversing with obfuscation.
Steps: 
1. Analyze the .so in goingseriousnative
2. reconstruct the decryption/verification
3. feed the correct input to get the flag.

## 12. TrustChallenge
Focus: Pass a trust check and decode the flag.
Steps:
1. Return the expected string in com.example.superapp.Agent.
2. Read the encrypted flag from logs and decode Base64 (and decrypt if needed).

## 13. Amazing Parcel 
Focus: Use a Parcelable to jump to target components.
Steps:
1. Implement com.example.victimapp.AmazingPackage.
2. Build the object and call com.example.victimapp.AmazingPackage.nextRout

## 14.Pending 
Focus: Abuse or reuse a PendingIntent to act as the victim.
Steps: 
1. Obtain the PendingIntent
2. modify or send it with crafted extras
3. trigger victim action that returns the flag.

## 15. Loadme
Focus: Dynamic code/Dex loading to execute hidden logic.
Steps: 
1. Prepare/load the dex or module
2. invoke the target class/method via reflection
3. read the flag from the return value/logs.

## 16 NoJumpStart
Focus: Send a signed intent chain to pass checks.
Steps:
1. Use com.example.maliciousapp.Main to sign "src-to-dst"
2. add "authmsg"/"authsign"
3. send the intent.
