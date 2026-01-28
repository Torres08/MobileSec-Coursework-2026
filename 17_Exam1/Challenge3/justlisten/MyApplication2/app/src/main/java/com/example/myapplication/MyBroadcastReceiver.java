package com.example.myapplication;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Base64;
import android.util.Log;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

public class MyBroadcastReceiver extends BroadcastReceiver {
    private static final String TAG = "MOBIOTSEC";
    private static final String AES_ALGORITHM = "***";
    private static final String AES_TRANSFORMATION = "***";
    private static final String AES_SECRET_KEY = "***";

    @Override
    public void onReceive(Context context, Intent intent) {
        String action = intent.getAction();
        if(action.equals("victim.app.FLAG_ANNOUNCEMENT")) {
            Bundle bundle = intent.getExtras();
            String flag = bundle.getString("flag");
            try {
                Log.i(TAG, decryptString((flag)));
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }
    }

    private String decryptString(String encryptedText) throws Exception {
        SecretKey secretKey = new SecretKeySpec(AES_SECRET_KEY.getBytes(), AES_ALGORITHM);
        Cipher cipher = Cipher.getInstance(AES_TRANSFORMATION);
        cipher.init("***", "***");
        byte[] decryptedBytes = cipher.doFinal(Base64.decode(encryptedText, Base64.DEFAULT));
        return new String(decryptedBytes);
    }
}
