# Rules for Razorpay to prevent R8 from removing required classes
-dontwarn proguard.annotation.Keep
-dontwarn proguard.annotation.KeepClassMembers
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Rules for androidx.window to handle potential reflection issues
-dontwarn androidx.window.extensions.**
-dontwarn androidx.window.sidecar.**

# General rules to avoid common Flutter issues
-keep class androidx.** { *; }
-dontwarn androidx.**
-keep class com.google.** { *; }
-dontwarn com.google.**