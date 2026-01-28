import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.util.Base64;

/*
URL:    https://www.math.unipd.it/~elosiouk/test.dex
Class:  com.mobiotsec.loadimage.LoadImage
Method: load
----
Target Class:  com.mobiotsec.check.Check
Target Method: check
Asset Filename: logo.png

 */

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
