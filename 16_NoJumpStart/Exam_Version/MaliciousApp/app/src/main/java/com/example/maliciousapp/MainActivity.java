package com.example.maliciousapp;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

public class MainActivity extends Activity {
    private static final String TAG = "MOBIOTSEC";

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // android.app.Activity
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Log.i(TAG, "onCreate");
    }

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // android.app.Activity
    public void onStart() {
        super.onStart();
        Log.i(TAG, "onStart");
        Intent intent1 = new Intent();
        intent1.setComponent(new ComponentName("com.mobiotsec.nojumpstarts", "com.mobiotsec.nojumpstarts.C"));
        intent1.putExtra("authmsg", "Main-to-A/A-to-B/B-to-C");
        intent1.putExtra("sender", "com.mobiotsec.nojumpstarts");
        try {
            intent1.putExtra("authsign", Main.sign("Main-to-A/A-to-B/B-to-C"));
        } catch (Exception e) {
            Log.i(TAG, Log.getStackTraceString(e));
        }
        if (intent1.resolveActivity(getPackageManager()) != null) {
            Log.i(TAG, "Sent malicious intent");
            startActivityForResult(intent1, 1);
        }
    }

    @Override // android.app.Activity
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        Log.i(TAG, "key: " + requestCode + " " + data.getStringExtra("flag"));
    }
}