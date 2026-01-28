# justlisten
The flag is announced on the system with a broadcast intent with action victim.app.FLAG_ANNOUNCEMENT

___

## How to solve it 

**Core Concept:** We are a **passive listener**.
The system is "shouting" the flag to everyone on the device using a Broadcast, and we need to catch it.

* **Action to listen for:** `victim.app.FLAG_ANNOUNCEMENT`
* **Mechanism:** `BroadcastReceiver`

Reference: [Android Broadcasts Overview](https://developer.android.com/develop/background-work/background-tasks/broadcasts)



### 1. Create MyBroadcastReceiver 

We need to extend the `BroadcastReceiver` class. Inside `onReceive`, we check the action and dump the extras (similar to how we handled bundles in previous challenges).

```java
public static class MyBroadcastReceiver extends BroadcastReceiver {
    private static final String TAG = "CTF";

    @Override
    public void onReceive(Context context, Intent intent) {

        // 1. Check for the action we want to listen to
        if (Objects.equals(intent.getAction(), "victim.app.FLAG_ANNOUNCEMENT")) {

            // 2. Bundle everything together to extract the flag
            Bundle extras = intent.getExtras();
            if (extras != null) {
                for (String key : extras.keySet()) {
                    Log.d(TAG, "Key: " + key + " Value: " + extras.get(key));
                }
            }
        }
    }
}
```

Don't forget to create an instance of the receiver as a class member in your Activity:
```java
MyBroadcastReceiver myBroadcastReceiver = new MyBroadcastReceiver();
```

### 2. Define Filter + Registration 
In the `onCreate` function of your MainActivity:

We need to register the receiver dynamically. Note that for newer Android versions (Android 14+), you **must** specify `RECEIVER_EXPORTED` if you want to listen to broadcasts from other apps.

```java
// 1. Define the intent filter with the specific action string
IntentFilter filter = new IntentFilter("victim.app.FLAG_ANNOUNCEMENT");

// 2. Determine flags (Required for Android 13/14+)
boolean listenToBroadcastsFromOtherApps = true;
int receiverFlags = listenToBroadcastsFromOtherApps
        ? ContextCompat.RECEIVER_EXPORTED
        : ContextCompat.RECEIVER_NOT_EXPORTED;

// 3. Register the receiver
// ContextCompat.registerReceiver(Context, Receiver, Filter, Flags);
ContextCompat.registerReceiver(this, myBroadcastReceiver, filter, receiverFlags);
```

**Good Practice:** Unregister the receiver when the app closes to prevent memory leaks.
```java
@Override
protected void onDestroy() {
    super.onDestroy();
    unregisterReceiver(myBroadcastReceiver);
}
```

## Solution 

Once the app is running and the system broadcasts the intent, the logs will show:

```bash
2026-01-20 12:07:28.531 10109-10109 CTF    com.example.maliciousapp   D  Key: flag Value: FLAG{carpe_diem}
```

**Flag:** `FLAG{carpe_diem}`