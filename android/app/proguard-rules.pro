# Ignorar avisos sobre OkHttp e Okio (usados pelo uCrop para imagens da web)
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**

# Manter as classes do uCrop intactas
-keep class com.yalantis.ucrop** { *; }
-keep interface com.yalantis.ucrop** { *; }