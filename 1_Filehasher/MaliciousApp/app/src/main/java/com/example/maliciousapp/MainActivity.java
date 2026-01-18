package com.example.maliciousapp;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

import java.io.FileInputStream;
import java.io.InputStream;
import java.security.MessageDigest;

public class MainActivity extends AppCompatActivity {

    // For logs
    final String tag = "CTF";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // 2. Get the intent the activity started with
        Intent intent = getIntent();

        // 3. check if intent get something
        if (intent != null){
            Log.d(tag, "Intent received Action: " + intent.getAction());

            // 4. filepath from the usi get
            Uri fileUri = intent.getData();

            if (fileUri != null) {
                Log.d(tag, "File URI: " + fileUri.getPath());

                String hash = calculateSHA256(fileUri);

                Log.d(tag, "SHA-256 Hash: " + hash);

                // 5. send the result back
                Intent resultIntent = new Intent();
                resultIntent.putExtra("hash", hash);
                setResult(RESULT_OK, resultIntent);

            } else {
                Log.d(tag, "No file URI found in the intent");
            }

        }

        // 6. finish activity
        finish();
    }

    // copy paste function
    private String calculateSHA256(Uri fileUri) {
        try {
            Log.d("CTF", "Opening input stream for URI: " + fileUri);

            java.security.MessageDigest digest = java.security.MessageDigest.getInstance("SHA-256");
            java.io.InputStream fis = getContentResolver().openInputStream(fileUri);

            byte[] buffer = new byte[1024];
            int nread;
            while ((nread = fis.read(buffer)) != -1) {
                digest.update(buffer, 0, nread);
            }
            fis.close();

            byte[] hashBytes = digest.digest();
            StringBuilder hexString = new StringBuilder();
            for (byte b : hashBytes) {
                hexString.append(String.format("%02x", b));
            }
            return hexString.toString();

        } catch (Exception e) {
            Log.e("CTF", "Error calculating hash: " + e.getMessage());
            e.printStackTrace();
            return "";
        }
    }
}