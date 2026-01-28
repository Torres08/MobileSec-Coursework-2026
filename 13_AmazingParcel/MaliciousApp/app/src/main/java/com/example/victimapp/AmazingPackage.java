//package com.example.victimapp;
package com.example.victimapp;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.os.Parcel;
import android.os.Parcelable;

/* loaded from: classes3.dex */
public class AmazingPackage implements Parcelable {
    public String activity;
    public String pkg;
    public static String TAG = "MOBIOTSEC";
    public static final Parcelable.Creator<AmazingPackage> CREATOR = new Parcelable.Creator<AmazingPackage>() { // from class: com.example.victimapp.AmazingPackage.1
        /* JADX WARN: Can't rename method to resolve collision */
        @Override // android.os.Parcelable.Creator
        public AmazingPackage createFromParcel(Parcel source) {
            return new AmazingPackage(source);
        }

        /* JADX WARN: Can't rename method to resolve collision */
        @Override // android.os.Parcelable.Creator
        public AmazingPackage[] newArray(int size) {
            return new AmazingPackage[size];
        }
    };

    // change protected -> public for access
    public AmazingPackage(Parcel in) {
        this.pkg = "";
        this.activity = "";
        this.pkg = in.readString();
        this.activity = in.readString();
    }

    public AmazingPackage(String pkg, String activity) {
        this.pkg = "";
        this.activity = "";
        this.pkg = pkg;
        this.activity = activity;
    }

    @Override // android.os.Parcelable
    public int describeContents() {
        return 0;
    }

    @Override // android.os.Parcelable
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.pkg);
        dest.writeString(this.activity);
    }

    public void nextRoute(Context ctx) {
        Intent i = new Intent();
        i.setComponent(new ComponentName(this.pkg, this.activity));
        ctx.startActivity(i);
    }
}