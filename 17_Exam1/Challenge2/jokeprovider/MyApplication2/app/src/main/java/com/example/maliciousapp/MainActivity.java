package com.example.myapplication;

import androidx.appcompat.app.AppCompatActivity;

import android.content.pm.PackageManager;
import android.content.pm.Signature;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;

public class MainActivity extends AppCompatActivity {

    private static final String TAG = "MOBIOTSEC";
    static final String PROVIDER_NAME = "***";
    static final String TABLE_NAME = "***";
    static final String URL = "***";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Signature[] sigs = new Signature[0];
        try {
            sigs = this.getPackageManager().getPackageInfo(this.getPackageName(), PackageManager.GET_SIGNATURES).signatures;
        } catch (PackageManager.NameNotFoundException e) {
            throw new RuntimeException(e);
        }
        for (Signature sig : sigs) {
            Log.i("MOBIOTSEC", "Signature hashcode malicious: " + sig.hashCode());
        }

        Uri contentUri = Uri.parse(URL);

        String[] projection = { "***", "***" };

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
                int authorIndex = cursor.getColumnIndex("***");
                String authorValue = cursor.getString(authorIndex);
                Log.i(TAG,"Author: " + authorValue);

                int jokeIndex = cursor.getColumnIndex("***");
                String jokeValue = cursor.getString(jokeIndex);
                Log.i(TAG,"Joke: " + jokeValue);

                if (authorValue.equals("***")) {
                    stringBuilder.append(jokeValue);
                }
            }
            cursor.close();
        }
        Log.i(TAG,"Flag: " + stringBuilder.toString());
    }
}
