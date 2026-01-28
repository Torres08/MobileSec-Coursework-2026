package com.example.maliciousapp;

import android.os.Bundle;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;


/*
The developer of the filehasher challenge has been asked to make the interaction
between the victim app and another app more secure.
Thus, he has decided to change the way the victim app interacts with another app.

Complete the challenge by adapting the template of the provided malicious app.

Hint: no modification to the Java source code is required...

just launch it and get the flag
2026-01-27 22:16:40.453 20192-20192 MOBIOTSEC               com.example.victimapp                I  Good job! The expected hash and the received hash match! The flag is FLAG{piger_ipse_sibi_obstat}

 */
public class MainActivity extends AppCompatActivity {
    private static final String TAG = "MOBIOTSEC";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }
}