# Loadme

only an apk, lets get the flag

should be dynamic code loading
- victim app likely to load a plugin, a library or a helper file (.dex,.jar) from a disk or network 

trick app to load your maliicous code 

____

## How to solve it 

### 1. Lets see the manifest 

android:networkSecurityConfig="@xml/network_security_config"  
- means that app uses a custom security network 
- - if it allows cleartext traffic, we can do MiTM


### 2. checl .xml 

go to res/xml/network_security_config.xml

```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config cleartextTrafficPermitted="true">
        <domain includeSubdomains="true">10.0.2.2
        </domain>
    </domain-config>
</network-security-config>
```

<domain includeSubdomains="true">10.0.2.2
- allow cleartex traffic
- 10.0.2.2 host coputer localhost
- scenario app is programmed to connect back to your computer to download a file 

attack plan -> dynamic code loading
1. apps behaviour: It will request a file (jar or apk) from a web server running on the machine 
2. run a simple web server on your computer and serve a malicious file that allows to get the flag 

### 3. MainActivity check 
we need to know 
- what specific file is requestiong 
- what class does it try to load from that file 
- what method does it call inside that class 


you can see directyl the flag in the Check file 

```java
/* loaded from: assets/logo.png */
public class Check {
    public static boolean check(String paramString) {
        return paramString.equals("FLAG{memores_acti_prudentes_futuri}");
    }
}
```

look at package -> lodme 
- the trigger result = new DoStuff.start ....

### 4. Do Stuff

function ds ->             Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5PADDING"); -> AES encryption 

key -> derived from the package name 
            SecretKeySpec skeySpec = new SecretKeySpec((parts[1] + parts[0] + "key!").getBytes("UTF-8"), "AES");

key : mobiotseccomkey!

com.mobiosec.loadme
0 - 1 - 2

we need to decrypt the hiddden url classes + name -> scratch.java file 


```java
class Decryptor {
    public static void main(String[] args) {
        try {
            // 1. Key and IV from your analysis
            String KEY = "mobiotseccomkey!";
            byte[] initVector = {
                    -34, -83, -66, -17, -34, -83, -66, -17,
                    -34, -83, -66, -17, -34, -83, -66, -17
            };

            // 2. Encrypted Strings from DoStuff.java
            String urlEnc = "Bj9yLW24l0OpvkoxoPXLb+UqJGp1t1slVcl/aTlHM+iolk4i083NV8E1LNJj/6w1";
            String classEnc = "C8A5LnGuoQKLdKpSOwC/4cMimh4v5cWqsy+xAmaFrRUYWnfpb+SCA4nSqeuUQ+b6";
            String methodEnc = "m+KXkYIOwwx09+iEGTnFOg==";

            System.out.println("URL:    " + decrypt(urlEnc, KEY, initVector));
            System.out.println("Class:  " + decrypt(classEnc, KEY, initVector));
            System.out.println("Method: " + decrypt(methodEnc, KEY, initVector));


            String className = "zbTHGeQeUUxj3dJ43fDwkcKmk4erD60GZXReeWl3ITA=";
            String methodName = "LlzQOUB3opWgJZeFNI/Jsg==";
            String assetName = "oxTrCOohrr2fAZfJZAjcNA==";

            System.out.println("Target Class:  " + decrypt(className, KEY, initVector));
            System.out.println("Target Method: " + decrypt(methodName, KEY, initVector));
            System.out.println("Asset Filename: " + decrypt(assetName, KEY, initVector));


        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static String decrypt(String enc, String key, byte[] ivBytes) throws Exception {
        byte[] ciphertext = Base64.getDecoder().decode(enc);
        IvParameterSpec iv = new IvParameterSpec(ivBytes);
        SecretKeySpec skeySpec = new SecretKeySpec(key.getBytes("UTF-8"), "AES");

        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5PADDING");
        cipher.init(Cipher.DECRYPT_MODE, skeySpec, iv);

        return new String(cipher.doFinal(ciphertext));
    }
}
```

```bash
URL:    https://www.math.unipd.it/~elosiouk/test.dex
Class:  com.mobiotsec.loadimage.LoadImage
Method: load
----
Target Class:  com.mobiotsec.check.Check
Target Method: check
Asset Filename: logo.png
```

we can go to the url and download the test.dex -> drop in JADX-GUI 

-look at method loadImage 
- encrypted with AES as well 
- same key mobiosecomkey! + DEADBEEF pattern 


1. app download test.dex
2. textdex download file name logo.png
3. loads that image as executable logo.png (dex indisguised)
4. runs com.mobiosec.cjacl.check.check -> valiate the flag 

loadme.apk -> assets -< logo.png

drag & drop into jadx-gui 

 its an android app with funtion check 

```java
package com.mobiotsec.check;

/* loaded from: /home/torres/Documents/Github/MAS/MobileSec-Coursework-2026/15_Loadme/logo.png */
public class Check {
    public static boolean check(String paramString) {
        return paramString.equals("FLAG{memores_acti_prudentes_futuri}");
    }
}
```