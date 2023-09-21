# pcp_frontend

Pixel Code Platform frontend

---

## Status

Currently does not match the recently changed backend contracts. Use [PixelSam123/pcp_frontend_web](https://github.com/PixelSam123/pcp_frontend_web) for now.  
I don't currently have the time/motivation to continue this Flutter frontend. If someone wants to continue this, please contact me.  
If not, then I'll continue this in December, or when the Impeller engine is available on all desktop platforms, or when Flutter 4.0 comes out, whichever comes first.

## List of modifications to OS-specific builds

1. macOS

   Added this to both `Runner/DebugProfile.entitlements` and `Runner/Release.entitlements`:

   ```xml
   <key>com.apple.security.network.client</key>
   <true/>
   ```
