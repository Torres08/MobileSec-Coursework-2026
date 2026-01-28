package com.example.superapp;

// 1. create agent class + method that the victim app expects

/*
2026-01-20 18:05:51.377 12467-12467 MOBIOTSEC               com.example.victimapp                I  service created
2026-01-20 18:05:51.393 12467-12467 MOBIOTSEC               com.example.victimapp                I  onBind
2026-01-20 18:05:51.416 12467-12467 MOBIOTSEC               com.example.victimapp                I  Malicious app bound to the service
2026-01-21 13:18:07.274 12995-12995 MOBIOTSEC               com.example.victimapp                I  calling the agent
2026-01-21 13:18:07.552 12995-12995 MOBIOTSEC               com.example.victimapp                I  nu uh not so easy, you want the flag? super secret salad dressing encryption method that makes your head spin ;)
2026-01-21 13:18:07.552 12995-12995 MOBIOTSEC               com.example.victimapp                I  figure this out, maybe a famous chef can cook a solution for you
2026-01-21 13:18:07.552 12995-12995 MOBIOTSEC               com.example.victimapp                I  I would let him cook if I were you
2026-01-21 13:18:07.552 12995-12995 MOBIOTSEC               com.example.victimapp                I  alright Ill stop talking, here is the encrypted flag fWtoeV9nbnZze1ROWVM=
2026-01-21 13:18:07.552 12995-12995 MOBIOTSEC               com.example.victimapp                I  fWtoeV9nbnZze1ROWVM=
 */
public class Agent {
    // The victim app calls this method dynamically
    public static String superSecretRequest() {
        // We return exactly what the victim app expects
        return "s3cr37_c0mm";
    }
}
